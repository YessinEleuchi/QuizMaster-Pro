import 'package:http/http.dart' as http;
import 'package:quiz_app/model/question_summary.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<QuestionSummary>> fetchQuizSummary() async {
    final response = await client.get(Uri.parse('https://example.com/quiz/results'));

    if (response.statusCode == 200) {
      return questionSummaryFromJson(response.body);
    } else {
      throw Exception('Failed to load quiz summary');
    }
  }
}
