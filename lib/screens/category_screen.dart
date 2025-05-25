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
  String selectedDifficulty = "easy";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.isDarkMode
                ? [Color(0xFF1F1B24), Color(0xFF3C2F4D)]
                : [Color(0xFF8E44AD), Color(0xFFD7BDE2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, size: 60, color: Theme.of(context).textTheme.bodyLarge?.color),
                  SizedBox(height: 10),
                  Text(
                    "Choisir une catégorie",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sélectionnez une catégorie et difficulté",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedDifficulty,
                    dropdownColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                    style: GoogleFonts.poppins(color: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}), fontSize: 16),
                    items: ["Easy", "Medium", "Hard"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toLowerCase(),
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedDifficulty = value!),
                  ),
                  SizedBox(height: 20),
                  CategoryButton(
                    text: "Science",
                    icon: Icons.science,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            category: "Science",
                            difficulty: selectedDifficulty,
                            amount: 10,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CategoryButton(
                    text: "Entertainment",
                    icon: Icons.movie,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            category: "Entertainment",
                            difficulty: selectedDifficulty,
                            amount: 10,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CategoryButton(
                    text: "General Knowledge",
                    icon: Icons.lightbulb,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            category: "General Knowledge",
                            difficulty: selectedDifficulty,
                            amount: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CategoryButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) {
        setState(() => _isTapped = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: _isTapped ? 2 : 6,
              offset: Offset(0, _isTapped ? 1 : 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        transform: Matrix4.identity()..scale(_isTapped ? 0.98 : 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}), size: 24),
            SizedBox(width: 10),
            Text(
              widget.text,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}