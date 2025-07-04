import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../service/quiz_history_service.dart';
import '../widget/question_history_widget.dart';

class QuizHistoryPage extends StatelessWidget {
  final historyService = QuizHistoryService();

  QuizHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final backgroundGradient = isDark
        ? [const Color(0xFF1F1B24), const Color(0xFF121212)]
        : [const Color(0xFFFAF3FF), const Color(0xFF9FBCEA)];

    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text("📊 ${t.history}")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: historyService.getUserScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final scores = snapshot.data ?? [];

            if (scores.isEmpty) {
              return Center(child: Text(t.noQuizTaken));
            }

            return ListView.builder(
              itemCount: scores.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final score = scores[index];
                return QuestionHistoryWidget(
                  category: score['category'] ?? t.unknown,
                  score: score['score'] ?? 0,
                  date: score['timestamp']?.toDate(),
                  isDarkMode: isDark,
                );
              },
            );
          },
        ),
      ),
    );
  }
}