import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final formattedDate = date != null
        ? DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR').format(date!)
        : "Date inconnue";

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
                  Text("📚 Catégorie : $category",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87)),
                  const SizedBox(height: 6),
                  Text("✅ Score : $score",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: isDarkMode ? Colors.white70 : Colors.black87)),
                  Text("🕒 Date : $formattedDate",
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
