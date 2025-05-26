import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/screens/signUp_screen.dart';
import 'category_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

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
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Signed In Successfully",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CategoryScreen()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: ${e.message ?? 'Sign-in failed'}",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? Color(0xFF00C4B4) : Color(0xFF07010C);
    final bgGradient = isDark
        ? [Color(0xFF030937), Color(0xFF0F1647)]
        : [Color(0xFF032397), Color(0xFFEEF4F4)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 16,
                  shadowColor: Colors.black.withOpacity(0.2),
                  color: isDark ? Color(0xFF2A2A2E) : Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Welcome Back!",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Sign in to continue your quiz journey!",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.poppins(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                labelStyle: GoogleFonts.poppins(
                                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                                ),
                                prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                                filled: true,
                                fillColor: isDark ? Color(0xFF3A3A3C) : Color(0xFFF1F4F8),
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              ),
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              style: GoogleFonts.poppins(fontSize: 16),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: GoogleFonts.poppins(
                                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                                ),
                                prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: primaryColor,
                                  ),
                                  onPressed: () => setState(() => _obscureText = !_obscureText),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                                filled: true,
                                fillColor: isDark ? Color(0xFF3A3A3C) : Color(0xFFF1F4F8),
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 32),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : () => signIn(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                  shadowColor: primaryColor.withOpacity(0.4),
                                  animationDuration: Duration(milliseconds: 200),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => SignUpScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}