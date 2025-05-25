import 'dart:convert';

class QuestionSummary {
  final int questionIndex;
  final String questionText;
  final String correctAnswer;
  final String selectedAnswer;

  QuestionSummary({
    required this.questionIndex,
    required this.questionText,
    required this.correctAnswer,
    required this.selectedAnswer,
  });

  factory QuestionSummary.fromJson(Map<String, dynamic> json) {
    return QuestionSummary(
      questionIndex: json['questionIndex'],
      questionText: json['questionText'],
      correctAnswer: json['correctAnswer'],
      selectedAnswer: json['selectedAnswer'],
    );
  }
}

List<QuestionSummary> questionSummaryFromJson(String str) {
  final jsonData = json.decode(str);
  return List<QuestionSummary>.from(jsonData.map((x) => QuestionSummary.fromJson(x)));
}
