// 📁 lib/widgets/question_body.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/controller/question_controller.dart';

class QuestionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QuestionController>(context);
    final question = controller.questions[controller.currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (controller.currentQuestionIndex + 1) / controller.widget.amount,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: controller.timeLeft / 15,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.timeLeft > 10
                        ? Colors.green
                        : controller.timeLeft > 5
                        ? Colors.yellow
                        : Colors.red,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text("${controller.timeLeft}s"),
            ],
          ),
          SizedBox(height: 10),
          Text("Bonus: ${controller.streak}"),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                question["question"],
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: controller.hintsLeft > 0 && !controller.isAnswered ? controller.useHint : null,
            icon: Icon(Icons.lightbulb_outline),
            label: Text("Indice (${controller.hintsLeft})"),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: question["options"].map<Widget>((answer) {
                final isCorrect = answer == controller.correctAnswer;
                final isSelected = answer == controller.selectedAnswer;

                Color backgroundColor;
                if (!controller.isAnswered) {
                  backgroundColor = Theme.of(context).primaryColor;
                } else if (isCorrect) {
                  backgroundColor = Colors.green;
                } else if (isSelected) {
                  backgroundColor = Colors.red;
                } else {
                  backgroundColor = Theme.of(context).primaryColor;
                }

                return GestureDetector(
                  onTap: () => !controller.isAnswered ? controller.checkAnswer(answer) : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      answer,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
