import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class QuizService {
  static const String baseUrl = "https://opentdb.com/api.php";
  static const String categoryUrl = "https://opentdb.com/api_category.php"; // New URL for categories

  // Function to decode HTML entities
  static String decodeHtml(String text) {
    return parse(text).body?.text ?? text;
  }

  // Fetch questions from the OpenTDB API based on selected category ID
  Future<List<Map<String, dynamic>>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
  }) async {
    final url =
        "$baseUrl?amount=$amount&category=$categoryId&difficulty=$difficulty&type=multiple";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedQuestions = [];

      for (var item in data['results']) {
        fetchedQuestions.add({
          "question": decodeHtml(item['question']),
          "options": [
            ...item['incorrect_answers'].map((ans) => decodeHtml(ans)),
            decodeHtml(item['correct_answer']),
          ]..shuffle(),
          "correctAnswer": decodeHtml(item['correct_answer']),
        });
      }

      return fetchedQuestions;
    } else {
      throw Exception("Failed to load questions");
    }
  }

  // Fetch categories from the OpenTDB API
  Future<List<Map<String, dynamic>>> fetchGroupedCategories() async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> groupedCategories = [];

      Map<String, List<Map<String, dynamic>>> categoryGroups = {
        "Science": [],
        "Entertainment": [],
        "General Knowledge": [],
        // Add other groups as needed
      };

      for (var category in data['trivia_categories']) {
        String categoryName = category['name'];
        int categoryId = category['id'];

        // Group the categories based on predefined categories
        if (categoryName.contains('Science')) {
          categoryGroups['Science']?.add({'name': categoryName, 'id': categoryId});
        } else if (categoryName.contains('Entertainment')) {
          categoryGroups['Entertainment']?.add({'name': categoryName, 'id': categoryId});
        } else if (categoryName.contains('General Knowledge')) {
          categoryGroups['General Knowledge']?.add({'name': categoryName, 'id': categoryId});
        }
        // Add more conditions to group other categories
      }

      // Now, convert this grouped data into a list of categories
      categoryGroups.forEach((group, categories) {
        groupedCategories.add({
          "groupName": group,
          "categories": categories,
        });
      });

      return groupedCategories;
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
