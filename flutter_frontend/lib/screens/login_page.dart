import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/services/google_service.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

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
  bool obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/homepage',
        arguments: userCredential.user!.uid,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final user = await GoogleService().signInWithGoogle();
      if (!mounted || user == null) return;

      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goBack() {
    Navigator.pushNamed(context, '/startpage');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final spacingSize = height * 0.03;
    final fontsizeTitle = width * 0.1;
    final fontsizeTextTitle = width * 0.04;
    final fontsizeButton = width * 0.05;
    final buttonWidth = base * 0.75;
    final buttonHeight = base * 0.15;
    final buttonPaddingHorizontal = base * 0.05;
    final buttonPaddingVertical = base * 0.04;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;
    Color buttonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    Color buttonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: AppBackground(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // TITLE
                          Text(
                            "Log In to Your Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontsizeTitle,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),

                          SizedBox(height: spacingSize),

                          Text(
                            "Email Address",
                            style: TextStyle(
                              fontSize: fontsizeTextTitle,
                              color: subtitleColor,
                            ),
                          ),

                          SizedBox(height: spacingSize / 5),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: AppColors.inputText,
                            style: TextStyle(color: AppColors.inputText),
                            decoration: InputDecoration(
                              hintText: "example@email.com",
                              hintStyle: TextStyle(color: AppColors.hintText),
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              if (!value.contains('@')) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: spacingSize),

                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: fontsizeTextTitle,
                              color: subtitleColor,
                            ),
                          ),

                          SizedBox(height: spacingSize / 5),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: obscurePassword,
                            obscuringCharacter: "*",
                            cursorColor: AppColors.inputText,
                            style: TextStyle(color: AppColors.inputText),
                            decoration: InputDecoration(
                              hintText: "Example1!",
                              hintStyle: TextStyle(color: AppColors.hintText),
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.inputText,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: spacingSize),

                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(buttonWidth, buttonHeight),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: buttonPaddingHorizontal,
                                        vertical: buttonPaddingVertical,
                                      ),
                                      backgroundColor: buttonBackgroundColor,
                                    ),
                                    onPressed: logIn,
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: fontsizeButton,
                                        color: buttonTextColor,
                                      ),
                                    ),
                                  ),
                                ),

                          SizedBox(height: spacingSize),

                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(buttonWidth, buttonHeight),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: buttonPaddingHorizontal,
                                      vertical: buttonPaddingVertical,
                                    ),
                                    backgroundColor: buttonBackgroundColor,
                                  ),
                                  onPressed: signInWithGoogle,
                                  child: Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                      fontSize: fontsizeButton,
                                      color: buttonTextColor,
                                    ),
                                  ),
                                ),

                          SizedBox(height: spacingSize),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                              padding: EdgeInsets.symmetric(
                                horizontal: buttonPaddingHorizontal,
                                vertical: buttonPaddingVertical,
                              ),
                              backgroundColor: buttonBackgroundColor,
                            ),
                            onPressed: _goBack,
                            child: Text(
                              "Return to Starting Page",
                              style: TextStyle(
                                fontSize: fontsizeButton,
                                color: buttonTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}