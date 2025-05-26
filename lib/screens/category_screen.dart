import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/screens/question_screen.dart';
import 'dart:async';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String selectedDifficulty = "easy";
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
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() => toggleIcon = !toggleIcon);
      }
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
    final primaryColor = isDark ? const Color(0xFF00E5C4) : const Color(0xFF07010C);
    final backgroundGradient = isDark
        ? [const Color(0xFF121212), const Color(0xFF1F1F1F)]
        : [const Color(0xFFEAF6FF), const Color(0xFFFFFFFF)];

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
                    // 🧠 Titre + icônes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Icon(
                            toggleIcon ? Icons.quiz : Icons.psychology_alt_rounded,
                            key: ValueKey(toggleIcon),
                            color: primaryColor,
                            size: 44,
                          ),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                        ),
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                            color: primaryColor,
                            size: 30,
                          ),
                          onPressed: () => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Quiz Preferences",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Select a category and difficulty level",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // 🎚️ Dropdown
                    Center(
                      child: DropdownButtonFormField<String>(
                        value: selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: "Difficulty",
                          prefixIcon: Icon(Icons.grade_outlined, color: primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F4F8),
                        ),
                        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        items: ["Easy", "Medium", "Hard"].map((value) {
                          return DropdownMenuItem<String>(
                            value: value.toLowerCase(),
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedDifficulty = value!),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 🧩 Boutons
                    Expanded(
                      child: ListView(
                        children: [
                          CategoryButton(
                            text: "Science",
                            icon: Icons.science_outlined,
                            color: const Color(0xFF0F1647),
                            onPressed: () => _navigate("Science"),
                          ),
                          CategoryButton(
                            text: "Entertainment",
                            icon: Icons.movie_creation_outlined,
                            color: const Color(0xFFEF6C00),
                            onPressed: () => _navigate("Entertainment"),
                          ),
                          CategoryButton(
                            text: "General Knowledge",
                            icon: Icons.lightbulb_outline,
                            color: const Color(0xFF9622EF),
                            onPressed: () => _navigate("General Knowledge"),
                          ),
                        ].map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: e,
                        )).toList(),
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

  void _navigate(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionScreen(
          category: category,
          difficulty: selectedDifficulty,
          amount: 10,
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CategoryButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
