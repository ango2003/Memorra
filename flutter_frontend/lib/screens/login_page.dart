import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/auth_service.dart';
import 'package:flutter_frontend/screens/home_page.dart';

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

  // Login Function
  Future<void> logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      
      if (!mounted) return;

      UserCredential userCredential = await _authService.logIn(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(userId: userCredential.user!.uid),
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
         padding: const EdgeInsets.all(30),
         child: Form(
           key: _formKey,
           child: Column(
             children: [
              Text("Login to\nAccount", 
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

                // EMAIL
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

                // PASSWORD
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
                         onPressed: _isLoading ? null : logIn,
                         child: const Text("Log In"),
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