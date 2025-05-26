import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/screens/question_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? const Color(0xFF00E5C4) : const Color(0xFF3A0CA3);
    final backgroundGradient = isDark
        ? [const Color(0xFF1F1B24), const Color(0xFF121212)]
        : [const Color(0xFFFAF3FF), const Color(0xFF9FBCEA)];

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
                    // 🎨 Header + toggle icon
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
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                            color: primaryColor,
                          ),
                          onPressed: () => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🎉 Title
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "🎉 Let's Play!",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            "Customize your quiz adventure",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🧠 Difficulty dropdown
                    _buildDropdown<String>(
                      value: selectedDifficulty,
                      label: "🎯 Difficulty",
                      icon: Icons.auto_fix_high,
                      items: ["easy", "medium", "hard"],
                      onChanged: (val) => setState(() => selectedDifficulty = val!),
                    ),

                    const SizedBox(height: 16),

                    // 📊 Number of questions
                    _buildDropdown<int>(
                      value: selectedAmount,
                      label: "🧮 Number of Questions",
                      icon: Icons.format_list_numbered,
                      items: [5, 10, 15, 20],
                      displayText: (val) => "$val questions",
                      onChanged: (val) => setState(() => selectedAmount = val!),
                    ),

                    const SizedBox(height: 24),

                    // 📚 Categories
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "📚 Choose a Category",
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

                    const Spacer(),

                    // ▶️ Start Quiz
                    ElevatedButton.icon(
                      onPressed: _navigateToQuiz,
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text("Start Quiz", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
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

  // 🌟 Dropdown Builder
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

  // 🧩 Category Chips
  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return ChoiceChip(
      label: Text(label),
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

  // ⏭️ Go to QuestionScreen
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
