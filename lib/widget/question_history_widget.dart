import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionHistoryWidget extends StatelessWidget {
  final String category;
  final int score;
  final DateTime? date;
  final bool isDarkMode;

  const QuestionHistoryWidget({
    super.key,
    required this.category,
    required this.score,
    required this.date,
    required this.isDarkMode,
  });

  String translateCategoryName(String label, BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (label) {
      case "Science":
        return t.categoryScience;
      case "Entertainment":
        return t.categoryEntertainment;
      case "General Knowledge":
        return t.categoryGeneral;
      default:
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final formattedDate = date != null
        ? DateFormat('dd MMMM yyyy à HH:mm', Localizations.localeOf(context).toLanguageTag()).format(date!)
        : t.unknown_date;

    return Card(
      color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.school, color: isDarkMode ? Colors.cyanAccent : Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📚 ${t.category_label} : ${translateCategoryName(category, context)}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87)),
                  const SizedBox(height: 6),
                  Text("✅ ${t.score_label} : $score",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: isDarkMode ? Colors.white70 : Colors.black87)),
                  Text("🕒 ${t.date_label} : $formattedDate",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: isDarkMode ? Colors.grey : Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
