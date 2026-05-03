import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/screens/start_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_frontend/utils/pick_avatar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? user;
  bool isLoading = true;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final fetchedUser = await authService.value.fetchUser(widget.userId);
      if (mounted) {
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  
  // Sign Out Function
  Future<void> signOut() async {
    
    setState(() => isLoading = true);

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
        setState(() => isLoading = false);
      }
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
      if(_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image')),
        );
        return;
      }
      
      setState(() => isLoading = true);

      try {
        String resp = await StoreData().saveData(file: _image!);
        if (!mounted) return;
        if (resp == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            ),
          );
          await _loadUser();
          setState(() => _image = null);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile: $resp')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          ),
        );
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
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

              if (_image != null)
                Column(
                  children: [
                    // Show preview of selected image
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(_image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: sizeboxSize),
                    
                    // Save button with loading indicator
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: isLoading ? null : saveProfile,
                          child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Save Profile Picture"),
                        ),
                      ),
                    ),
                    SizedBox(height: sizeboxSize),
                  ],
                ),

              // Select image button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBGColor,
                    ),
                    onPressed: isLoading ? null : selectImage,
                    child: Text(
                      "Change Profile Picture",
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: sizeboxSize * 3),

              Text(
                user?.name ?? 'User',
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
                    onPressed: isLoading ? null : () { signOut(); },
                    child: isLoading
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