import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final fontsizeTitle = base * 0.12;
    final spacingSize = base * 0.03;
    final buttonWidth = base * 0.75;
    final buttonHeight = base * 0.15;
    final buttonPaddingHorizontal = base * 0.05;
    final buttonPaddingVertical = base * 0.04;
    final fontsizeButton = base * 0.06;
    final logoSize = base * 0.65;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color buttonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    Color buttonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;

    return Scaffold(
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false,
                scrollbars: false,
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: spacingSize * 2),
                            Text(
                              "Welcome to\nMemorra",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontsizeTitle,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),

                            SizedBox(height: spacingSize * 3.5),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(buttonWidth, buttonHeight),
                                padding: EdgeInsets.symmetric(
                                  horizontal: buttonPaddingHorizontal,
                                  vertical: buttonPaddingVertical,
                                ),
                                backgroundColor: buttonBackgroundColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/signuppage');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: fontsizeButton,
                                  color: buttonTextColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(buttonWidth, buttonHeight),
                                padding: EdgeInsets.symmetric(
                                  horizontal: buttonPaddingHorizontal,
                                  vertical: buttonPaddingVertical,
                                ),
                                backgroundColor: buttonBackgroundColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/loginpage');
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: fontsizeButton,
                                  color: buttonTextColor,  
                                ),
                              ),
                            ),

                            SizedBox(height: spacingSize * 5),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.asset(
                                'assets/logo.png',
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(height: spacingSize * 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}