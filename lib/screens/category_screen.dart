import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/screens/question_screen.dart';
import 'QuizHistoryPage.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String selectedCategory = "Science";
  String selectedDifficulty = "easy";
  int selectedAmount = 10;
  bool toggleIcon = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();

    Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) setState(() => toggleIcon = !toggleIcon);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String translateDifficulty(String level, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? const Color(0xFF00E5C4) : const Color(0xFF3A0CA3);
    final backgroundGradient = isDark
        ? [const Color(0xFF1F1B24), const Color(0xFF121212)]
        : [const Color(0xFFFAF3FF), const Color(0xFF9FBCEA)];

    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Icon(
                            toggleIcon ? Icons.emoji_objects : Icons.auto_awesome,
                            key: ValueKey(toggleIcon),
                            color: primaryColor,
                            size: 44,
                          ),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                                color: primaryColor,
                              ),
                              onPressed: () => themeProvider.toggleTheme(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Locale>(
                                  onChanged: (Locale? locale) {
                                    if (locale != null) {
                                      Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
                                    }
                                  },
                                  value: Localizations.localeOf(context),
                                  items: const [
                                    Locale('en'),
                                    Locale('fr'),
                                    Locale('ar'),
                                  ].map((locale) {
                                    final flag = locale.languageCode == 'fr'
                                        ? '🇫🇷'
                                        : locale.languageCode == 'ar'
                                        ? '🇸🇦'
                                        : '🇺🇸';
                                    return DropdownMenuItem(
                                      value: locale,
                                      child: Text(flag, style: const TextStyle(fontSize: 22)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "🎉 ${t.title}",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            t.customize,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown<String>(
                      value: selectedDifficulty,
                      label: "🎯 ${t.difficulty}",
                      icon: Icons.auto_fix_high,
                      items: ["easy", "medium", "hard"],
                      displayText: (val) => translateDifficulty(val, context),
                      onChanged: (val) => setState(() => selectedDifficulty = val!),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<int>(
                      value: selectedAmount,
                      label: "🧮 ${t.number_questions}",
                      icon: Icons.format_list_numbered,
                      items: [5, 10, 15, 20],
                      displayText: (val) => "$val ${t.questions}",
                      onChanged: (val) => setState(() => selectedAmount = val!),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "📚 ${t.category}",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildCategoryChip("Science"),
                              _buildCategoryChip("Entertainment"),
                              _buildCategoryChip("General Knowledge"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _navigateToQuiz,
                      icon: const Icon(Icons.play_circle_fill),
                      label: Text(t.start, style: const TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizHistoryPage()),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: Text(t.history, style: const TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF00E5C4) : const Color(0xFF3A0CA3),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required String label,
    required IconData icon,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? displayText,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: isDark ? Colors.cyanAccent : Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F4F8),
      ),
      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      style: GoogleFonts.poppins(fontSize: 15, color: isDark ? Colors.white : Colors.black),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(displayText != null ? displayText(item) : item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
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

  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return ChoiceChip(
      label: Text(translateCategoryName(label, context)),
      selected: isSelected,
      onSelected: (_) => setState(() => selectedCategory = label),
      selectedColor: const Color(0xFF4C5A93),
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? const Color(0xFF4C5A93) : Colors.grey.shade400,
          width: 1.2,
        ),
      ),
      labelStyle: GoogleFonts.poppins(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    );
  }

  void _navigateToQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionScreen(
          category: selectedCategory,
          difficulty: selectedDifficulty,
          amount: selectedAmount,
        ),
      ),
    );
  }
}
