import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/question_controller.dart';
import 'package:quiz_app/widget/question_body.dart';
import 'package:quiz_app/widget/question_header.dart';
import 'package:quiz_app/main.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionScreen extends StatefulWidget {
  final String category;
  final String difficulty;
  final int amount;

  const QuestionScreen({
    Key? key,
    required this.category,
    required this.difficulty,
    required this.amount,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  QuestionController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller = QuestionController(context, widget, vsync: this);
      controller!.init(vsync: this);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? const Color(0xFF05FD94) : const Color(0xFF07010C);
    final backgroundGradient = isDark
        ? [const Color(0xFF121212), const Color(0xFF1F1F1F)]
        : [const Color(0xFFE3F2FD), const Color(0xFFFFFFFF)];

    if (controller == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<QuestionController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(color: primaryColor)),
            );
          }

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: backgroundGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // 🧠 En-tête avec titre et couleur adaptée
                      Text(
                        "Quiz - ${widget.category} (${widget.difficulty})",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: QuestionHeader(),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0E0909) : const Color(0xFFF7F9FC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: QuestionBody(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}