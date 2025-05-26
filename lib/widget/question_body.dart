// 📁 lib/widgets/question_body.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/controller/question_controller.dart';
import 'package:quiz_app/main.dart';

class QuestionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QuestionController>(context);
    final question = controller.questions[controller.currentQuestionIndex];
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? const Color(0xFF00E5C4) : const Color(0xFF07010C);
    final cardColor = isDark ? const Color(0xFF2E2E2E) : Colors.white;
    final buttonColor = isDark ? const Color(0xFF00E5C4) : const Color(
        0xFF3A0CA3);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (controller.currentQuestionIndex + 1) / controller.widget.amount,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
            color: buttonColor,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: controller.timeLeft / 15,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.timeLeft > 10
                        ? Colors.green
                        : controller.timeLeft > 5
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${controller.timeLeft}s",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Bonus: ${controller.streak}",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
          Card(
            color: cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                question["question"],
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.hintsLeft > 0 && !controller.isAnswered ? controller.useHint : null,
            icon: const Icon(Icons.lightbulb_outline),
            label: Text("Indice (${controller.hintsLeft})"),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: question["options"].map<Widget>((answer) {
                final isCorrect = answer == controller.correctAnswer;
                final isSelected = answer == controller.selectedAnswer;

                Color backgroundColor;
                if (!controller.isAnswered) {
                  backgroundColor = buttonColor;
                } else if (isCorrect) {
                  backgroundColor = Colors.green;
                } else if (isSelected) {
                  backgroundColor = Colors.red;
                } else {
                  backgroundColor = buttonColor;
                }

                return GestureDetector(
                  onTap: () => !controller.isAnswered ? controller.checkAnswer(answer) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      answer,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
