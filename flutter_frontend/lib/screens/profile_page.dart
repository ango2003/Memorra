import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/screens/start_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  
  // Sign Out Function
  Future<void> signOut() async {
    
    setState(() => _isLoading = true);

    try {
      await authService.value.signOut();
      
      if (!mounted) return;
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final profileBorderSize = base * 0.01;
    final profileRadius = base * 0.19;
    final defaultProfileSize = base * 0.25;
    final usernameFontSize = base * 0.08;
    final buttonWidth = base * 0.85;
    final buttonHeight = base * 0.12;
    final buttonPaddingH = base * 0.05;
    final buttonPaddingV = base * 0.025;
    final buttonFontSize = base * 0.05;
    
    Color profileBorderColor = isDark ? AppColors.profileColorDark.withValues(alpha: 0.8) : AppColors.profileColorLight.withValues(alpha: 0.8);
    Color profileBG = isDark ? AppColors.profileBGDark.withValues(alpha: 0.25) : AppColors.profileBGLight.withValues(alpha: 0.25);
    Color defaultProfileColor = isDark ? AppColors.profileColorDark.withValues(alpha: 0.8) : AppColors.profileColorLight.withValues(alpha: 0.8);
    Color usernameColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color buttonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize * 3),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: profileBorderColor,
                    width: profileBorderSize,
                  ),
                ),
                child: CircleAvatar(
                  radius: profileRadius,
                  backgroundColor: profileBG,
                  child: Icon(
                    Icons.person,
                    size: defaultProfileSize,
                    color: defaultProfileColor,
                  ),
                ),
              ),

              SizedBox(height: sizeboxSize),

              Text(
                "Thornwick Briarblade",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: usernameFontSize,
                  color: usernameColor,
                ),
              ),

              SizedBox(height: sizeboxSize * 5),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      backgroundColor: buttonBGColor,
                    ),
                    onPressed:() {
                      Navigator.pushNamed(context, '/listcollection');
                    },
                    child: Text(
                      "My Friend's Lists",
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: buttonFontSize,
                      )
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: sizeboxSize),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      backgroundColor: buttonBGColor,
                    ),
                    onPressed: _isLoading ? null : () { signOut(); },
                    child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                        "Sign Out",
                        style: TextStyle(
                          color: buttonTextColor,
                          fontSize: buttonFontSize,
                      )
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 4,
        ),
      ),
    );
  }
}