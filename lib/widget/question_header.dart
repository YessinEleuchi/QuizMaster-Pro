import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/question_controller.dart';
import 'package:quiz_app/main.dart';

class QuestionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QuestionController>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Question ${controller.currentQuestionIndex + 1}/${controller.widget.amount}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(controller.isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: controller.togglePause,
              ),
              IconButton(
                icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: themeProvider.toggleTheme,
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: controller.deconnect,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
