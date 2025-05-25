import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/question_controller.dart';
import 'package:quiz_app/widget/question_body.dart';
import 'package:quiz_app/widget/question_header.dart';
import 'package:quiz_app/main.dart';

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
      setState(() {}); // Redessiner après init
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<QuestionController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  QuestionHeader(),
                  Expanded(child: QuestionBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
