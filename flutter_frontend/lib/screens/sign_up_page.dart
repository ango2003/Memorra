import 'package:flutter/material.dart';
import 'package:flutter_frontend/auth_service.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            child: Column(
              children: [
                Text("Create New\nAccount", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Color(0xFF1A3F7A),
                  )
                ),
                
                SizedBox(height: 15),

                Text("Email Address",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Color(0xFF3A3A3A),
                  )
                ),

                SizedBox(height: 3),

                // EMAIL ADDRESS FIELD
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "example@email.com",
                    labelStyle: TextStyle(
                      color:  Color(0xFF3A3A3A),
                    ),
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

                const SizedBox(height: 10),

                Text("Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Color(0xFF3A3A3A),
                  )
                ),

                SizedBox(height: 3),

                /// PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Example1!",
                    labelStyle: TextStyle(
                      color:  Color(0xFF3A3A3A),
                    ),
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

                const SizedBox(height: 10),

                Text("Confirm Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Color(0xFF3A3A3A),
                  )
                ),

                SizedBox(height: 3),

                /// CONFIRM PASSWORD
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Example1!",
                   labelStyle: TextStyle(
                      color:  Color(0xFF3A3A3A),
                    ),
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

                const SizedBox(height: 24),

                _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size (200, 60),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          foregroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Color(0xFF3A3A3A),
                        ),
                        onPressed: createAccount,
                        child: Text('Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                          )
                        ),
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