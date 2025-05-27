import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class QuizService {
  static const String baseUrl = "https://opentdb.com/api.php";
  static const String categoryUrl = "https://opentdb.com/api_category.php";

  // Function to decode HTML entities
  static String decodeHtml(String text) {
    return parse(text).body?.text ?? text;
  }

  // Traduction des noms de catégorie
  static String translateCategoryName(String rawName, BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (rawName.contains("Science")) return t.categoryScience;
    if (rawName.contains("Entertainment")) return t.categoryEntertainment;
    if (rawName.contains("General Knowledge")) return t.categoryGeneral;

    // Retourne le texte brut si aucune correspondance
    return rawName;
  }

  // Traduction des niveaux de difficulté
  static String translateDifficulty(String level, BuildContext context) {
    final t = AppLocalizations.of(context)!;

    switch (level.toLowerCase()) {
      case 'easy':
        return t.easy;
      case 'medium':
        return t.medium;
      case 'hard':
        return t.hard;
      default:
        return level;
    }
  }

  // Fetch questions from the OpenTDB API
  Future<List<Map<String, dynamic>>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
  }) async {
    final url = "$baseUrl?amount=$amount&category=$categoryId&difficulty=$difficulty&type=multiple";

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

  // Fetch categories from the OpenTDB API and group them
  Future<List<Map<String, dynamic>>> fetchGroupedCategories() async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> groupedCategories = [];

      Map<String, List<Map<String, dynamic>>> categoryGroups = {
        "Science": [],
        "Entertainment": [],
        "General Knowledge": [],
      };

      for (var category in data['trivia_categories']) {
        String categoryName = category['name'];
        int categoryId = category['id'];

        if (categoryName.contains('Science')) {
          categoryGroups['Science']?.add({'name': categoryName, 'id': categoryId});
        } else if (categoryName.contains('Entertainment')) {
          categoryGroups['Entertainment']?.add({'name': categoryName, 'id': categoryId});
        } else if (categoryName.contains('General Knowledge')) {
          categoryGroups['General Knowledge']?.add({'name': categoryName, 'id': categoryId});
        }
      }

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
