import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiz_app/service/quiz_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/screens/signIn_screen.dart';
import 'package:vibration/vibration.dart';

class QuestionController extends ChangeNotifier {
  final BuildContext context;
  final dynamic widget;
  final TickerProvider vsync;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  int score = 0;
  int streak = 0;
  bool isAnswered = false;
  bool isPaused = false;
  int timeLeft = 15;
  int hintsLeft = 1;
  String correctAnswer = "";
  String? selectedAnswer;

  final quizService = QuizService();
  Timer? _timer;

  final Map<String, int> categoryMap = {
    'Science': 17,
    'Entertainment': 11,
    'General Knowledge': 9,
  };

  QuestionController(this.context, this.widget, {required this.vsync});

  void init({required TickerProvider vsync}) {
    animationController = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 800),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    fetchQuestions();
    animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    try {
      int categoryId = categoryMap[widget.category] ?? 9;
      questions = await quizService.fetchQuestions(
        amount: widget.amount,
        categoryId: categoryId,
        difficulty: widget.difficulty,
      );
      isLoading = false;
      startTimer();
      notifyListeners();
    } catch (e) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text("Erreur", style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black)),
          content: Text("Impossible de charger les questions.", style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: GoogleFonts.poppins(color: isDark ? Colors.tealAccent : Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  void startTimer() async {
    _timer?.cancel();

    await _audioPlayer.stop(); // stop old sound
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource("sounds/timer.mp3"), volume: 1.0);

    if (!isPaused) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (timeLeft > 0 && !isPaused) {
          timeLeft--;

          if (timeLeft == 5) {
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 300);
            }
          }
        } else if (!isAnswered && !isPaused) {
          _timer?.cancel();
          await _audioPlayer.stop();
          checkAnswer("", autoTimeout: true);
        }

        notifyListeners();
      });
    }
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      _timer?.cancel();
      _stopTimerLoop();
    } else {
      startTimer();
    }
    notifyListeners();
  }

  Future<void> _stopTimerLoop() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
    } catch (e) {
      debugPrint("Erreur arrêt timer: $e");
    }
  }

  Future<void> _playSound(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _audioPlayer.play(AssetSource(path), volume: 1.0);
    } catch (e) {
      debugPrint("Erreur audio: $e");
    }
  }

  Future<void> deconnect() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion: $e")),
      );
    }
  }

  void checkAnswer(String answer, {bool autoTimeout = false}) async {
    _timer?.cancel();
    await _audioPlayer.stop();
    isAnswered = true;
    selectedAnswer = answer;
    correctAnswer = questions[currentQuestionIndex]["correctAnswer"];
    notifyListeners();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!autoTimeout && (await Vibration.hasVibrator() ?? false)) {
      Vibration.vibrate(duration: 150);
    }

    if (answer == correctAnswer) {
      streak++;
      score += streak >= 3 ? 2 : 1;
      _playSound("sounds/correct.mp3");
      if (!autoTimeout) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Good answer!", style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: isDark ? Colors.green[400] : Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } else {
      streak = 0;
      _playSound("sounds/wrong.mp3");
      if (!autoTimeout) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Bad response!", style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: isDark ? Colors.red[400] : Colors.red,
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    }

    Future.delayed(Duration(seconds: autoTimeout ? 2 : 1), () {
      if (currentQuestionIndex < widget.amount - 1) {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswer = null;
        timeLeft = 15;
        animationController.forward(from: 0);
        startTimer();
      } else {
        _playSound("sounds/complete.mp3");
        showResults();
      }
      notifyListeners();
    });
  }

  void useHint() {
    if (hintsLeft > 0 && !isAnswered) {
      List<String> options = List.from(questions[currentQuestionIndex]["options"]);
      options.remove(correctAnswer);
      options.shuffle();
      questions[currentQuestionIndex]["options"] = [correctAnswer, options.first]..shuffle();
      hintsLeft--;
      notifyListeners();
    }
  }

  void showResults() {
    _timer?.cancel();
    _stopTimerLoop();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text("Quiz Terminé", style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Score: $score / ${widget.amount}", style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black)),
            Text("Streak max: $streak", style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black)),
            Text("Catégorie: ${widget.category}", style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Retour", style: GoogleFonts.poppins(color: isDark ? Colors.tealAccent : Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              currentQuestionIndex = 0;
              score = 0;
              streak = 0;
              isAnswered = false;
              selectedAnswer = null;
              hintsLeft = 1;
              timeLeft = 15;
              fetchQuestions();
              notifyListeners();
            },
            child: Text("Rejouer", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Color getColor(String answer) {
    if (!isAnswered) return Theme.of(context).primaryColor;
    if (answer == correctAnswer) return Colors.green;
    if (answer == selectedAnswer) return Colors.red;
    return Theme.of(context).primaryColor;
  }
}
