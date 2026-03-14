import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/screens/home_page.dart';
import 'package:flutter_frontend/services/google_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // EMAIL/PASSWORD LOGIN
  Future<void> logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(userId: userCredential.user!.uid),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // GOOGLE LOGIN
  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final user = await GoogleService().signInWithGoogle();

      if (!mounted || user == null) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(userId: user.uid),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goBack() {
    Navigator.pushNamed(context, '/startpage');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [
                    Color(0xFF237F8F),
                    Color(0xFF19365C),
                  ]
                : const [
                    Color(0xFF5A86C4),
                    Color(0xFF8AD7C9),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Login to\nAccount",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A3F7A),
                  ),
                ),

                const SizedBox(height: 15),

                // EMAIL LABEL
                Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white70 : const Color(0xFF3A3A3A),
                  ),
                ),

                const SizedBox(height: 3),

                // EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "example@email.com",
                    filled: true,
                    fillColor: Color(0xFFC6DCFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Email is required" : null,
                ),

                const SizedBox(height: 10),

                // PASSWORD LABEL
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white70 : const Color(0xFF3A3A3A),
                  ),
                ),

                const SizedBox(height: 3),

                // PASSWORD FIELD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Example1!",
                    filled: true,
                    fillColor: const Color(0xFFC6DCFF),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Password is required"
                      : null,
                ),

                const SizedBox(height: 24),

                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                    ),
                    onPressed: logIn,
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                const SizedBox(height: 24),

                if (!_isLoading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                    ),
                    onPressed: signInWithGoogle,
                    child: const Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 60),
                  ),
                  onPressed: _goBack,
                  child: const Text(
                    "Return to Starting Page",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}