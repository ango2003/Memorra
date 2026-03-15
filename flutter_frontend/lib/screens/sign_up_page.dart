import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/services/google_service.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final GoogleService _googleService = GoogleService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Password validation: uppercase, number, special character
  bool isValidPassword(String password) {
    final uppercase = RegExp(r'[A-Z]');
    final number = RegExp(r'\d');
    final special = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    return password.length >= 8 &&
        uppercase.hasMatch(password) &&
        number.hasMatch(password) &&
        special.hasMatch(password);
  }

  // Signup function
  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Pre-check password
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must be at least 8 characters and include an uppercase letter, a number, and a special character.'),
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      // Create Auth user
      await _authService.createAccount(
        email: email,
        password: password,
      );
        
      if(!mounted) return;
      Navigator.pushReplacementNamed(context, '/homepage');
  
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      final user = await _googleService.signInWithGoogle();
      
      if (!mounted || user == null) return;
      
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            padding: EdgeInsets.all(30),
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
                          Text(
                            "Create New Account",
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

                          // EMAIL FIELD
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
                                borderRadius: BorderRadius.all(Radius.circular(10)),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: fontsizeTextTitle,
                                  color: subtitleColor,
                                ),
                              ),
                              SizedBox(width: spacingSize / 20),
                              IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: subtitleColor,
                                ),
                                onPressed: () { 
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: buttonBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      titleTextStyle: TextStyle(
                                        fontSize: fontsizeTextTitle,
                                        fontWeight: FontWeight.bold,
                                        color: titleColor,
                                      ),
                                      contentTextStyle: TextStyle(
                                        fontSize: fontsizeTextTitle * 0.9,
                                        color: subtitleColor,
                                      ),
                                      title: Text("Password Requirements"),
                                      content: Text(
                                        "Your password must be at least 8 characters long and include:\n\n"
                                        "- At least one uppercase letter\n"
                                        "- At least one number\n"
                                        "- At least one special character (e.g. !@#\$%^&*)",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),

                          SizedBox(height: spacingSize / 5),

                          // PASSWORD FIELD
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            obscuringCharacter: "*",
                            cursorColor: AppColors.inputText,
                            style: TextStyle(color: AppColors.inputText),
                            decoration: InputDecoration(
                              hintText: "Example1!",
                              hintStyle: TextStyle(color: AppColors.hintText),
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.inputText,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (!isValidPassword(value)) {
                                return "Min 8 chars, 1 uppercase, 1 number, 1 special char";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: spacingSize),

                          Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontSize: fontsizeTextTitle,
                              color: subtitleColor,
                            ),
                          ),

                          SizedBox(height: spacingSize / 5),

                          // CONFIRM PASSWORD FIELD
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            obscuringCharacter: "*",
                            cursorColor: AppColors.inputText,
                            style: TextStyle(color: AppColors.inputText),
                            decoration: InputDecoration(
                              hintText: "Example1!",
                              hintStyle: TextStyle(color: AppColors.inputText),
                              labelStyle: TextStyle(color: AppColors.border),
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.border,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: spacingSize),

                          // SIGN UP BUTTON
                          _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(buttonWidth, buttonHeight),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: buttonPaddingHorizontal, 
                                    vertical: buttonPaddingVertical
                                  ),
                                  backgroundColor: buttonBackgroundColor,
                                ),
                                onPressed: createAccount,
                                child: Text(
                                 'Sign Up',
                                  style: TextStyle(
                                    fontSize: fontsizeButton,
                                    color: buttonTextColor,
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: spacingSize),

                          // GOOGLE SIGN-IN BUTTON
                          _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                              padding: EdgeInsets.symmetric(
                                horizontal: buttonPaddingHorizontal, 
                                vertical: buttonPaddingVertical
                              ),
                              backgroundColor:buttonBackgroundColor,
                            ),
                              onPressed: signInWithGoogle,
                              child: Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: fontsizeButton,
                                  color: buttonTextColor,
                                ),
                              ),
                            ),

                          SizedBox(height: spacingSize),

                          // RETURN BUTTON
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonWidth, buttonHeight),
                              padding:EdgeInsets.symmetric(
                                horizontal: buttonPaddingHorizontal, 
                                vertical: buttonPaddingVertical
                              ),
                              backgroundColor: buttonBackgroundColor,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/startpage');
                            },
                            child: Text(
                              'Return to Starting Page',
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