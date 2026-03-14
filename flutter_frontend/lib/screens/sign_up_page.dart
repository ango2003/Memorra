import 'package:flutter/material.dart';
import 'package:flutter_frontend/auth_service.dart';
import 'package:flutter_frontend/google_service.dart';

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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final spacing_size = height * 0.03;
    final fontsize_title = width * 0.1;
    final fontsize_button = width * 0.05;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [
                      Color(0xFF237F8F),
                      Color(0xFF19365C),
                    ]
                  : [
                      Color(0xFF5A86C4),
                      Color(0xFF8AD7C9),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
                              fontSize: fontsize_title,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Color(0xFF1A3F7A),
                            ),
                          ),

                          SizedBox(height: spacing_size),

                          Text(
                            "Email Address",
                            style: TextStyle(
                              fontSize: fontsize_button,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Color(0xFF3A3A3A),
                            ),
                          ),

                          SizedBox(height: spacing_size / 5),

                          // EMAIL FIELD
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Color(0xFF96A4B5),
                            style: TextStyle(color: Color(0xFF96A4B5)),
                            decoration: InputDecoration(
                              hintText: "example@email.com",
                              hintStyle: TextStyle(color: Color(0xFF96A4B5)),
                              labelStyle: TextStyle(color: Color(0xFF3A3A3A)),
                              filled: true,
                              fillColor: Color(0xFFC6DCFF),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFF3A3A3A),
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

                          SizedBox(height: spacing_size),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: fontsize_button,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white70
                                      : Color(0xFF3A3A3A),
                                ),
                              ),
                              SizedBox(width: spacing_size / 20),
                              IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF3A3A3A),
                                ),
                                onPressed: () { 
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? Color(0xFF19365C)
                                        : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      titleTextStyle: TextStyle(
                                        fontSize: fontsize_button,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Color(0xFF1A3F7A),
                                      ),
                                      contentTextStyle: TextStyle(
                                        fontSize: fontsize_button * 0.9,
                                        color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white70
                                          : Color(0xFF3A3A3A),
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

                          SizedBox(height: spacing_size / 5),

                          // PASSWORD FIELD
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            obscuringCharacter: "*",
                            cursorColor: Color(0xFF96A4B5),
                            style: TextStyle(color: Color(0xFF96A4B5)),
                            decoration: InputDecoration(
                              hintText: "Example1!",
                              hintStyle: TextStyle(color: Color(0xFF96A4B5)),
                              labelStyle: TextStyle(color: Color(0xFFA0A0A0)),
                              filled: true,
                              fillColor: Color(0xFFC6DCFF),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFF3A3A3A),
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFF3A3A3A),
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

                          SizedBox(height: spacing_size),

                          Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontSize: fontsize_button,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Color(0xFF3A3A3A),
                            ),
                          ),

                          SizedBox(height: spacing_size / 5),

                          // CONFIRM PASSWORD FIELD
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            obscuringCharacter: "*",
                            cursorColor: Color(0xFF96A4B5),
                            style: TextStyle(color: Color(0xFF96A4B5)),
                            decoration: InputDecoration(
                              hintText: "Example1!",
                              hintStyle: TextStyle(color: Color(0xFF96A4B5)),
                              labelStyle: TextStyle(color: Color(0xFF3A3A3A)),
                              filled: true,
                              fillColor: Color(0xFFC6DCFF),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFF3A3A3A),
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF3A3A3A),
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

                          SizedBox(height: spacing_size),

                          // SIGN UP BUTTON
                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(200, 60),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      foregroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Color(0xFF3A3A3A),
                                    ),
                                    onPressed: createAccount,
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(fontSize: fontsize_button),
                                    ),
                                  ),
                                ),

                          SizedBox(height: spacing_size),

                          // GOOGLE SIGN-IN BUTTON
                          _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 60),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                              foregroundColor:Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xFF3A3A3A),
                            ),
                              onPressed: signInWithGoogle,
                              child: Text(
                                'Continue with Google',
                                style: TextStyle(fontSize: fontsize_button),
                              ),
                            ),

                          SizedBox(height: spacing_size),

                          // RETURN BUTTON
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 60),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              foregroundColor:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Color(0xFF3A3A3A),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/startpage');
                            },
                            child: Text(
                              'Return to Starting Page',
                              style: TextStyle(fontSize: fontsize_button),
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