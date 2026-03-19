import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../screens/connections_page.dart';
import '../screens/reminder_collection.dart';
import '../screens/filler_page.dart';
import '../themes/app_colors.dart';
import 'dart:ui';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    super.key,
    required this.currentIndex,
  });

  BottomNavigationBarItem buildItem({
  required IconData icon,
  required IconData activeIcon,
  required String label,
  required int index,
  }) 
  {
  final isSelected = currentIndex == index && currentIndex != -1;

  return BottomNavigationBarItem(
    icon: Icon(
      isSelected ? activeIcon : icon,
      color: null,
    ),
    label: label,
  );
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final base = screenWidth < screenHeight ? screenWidth : screenHeight;

    final iconSize = base * 0.055;
    final barHeight = screenHeight * 0.09;

    final double outerCurve = 20;
    final double navSpacing = 4;
    final FontWeight unchosenIcon = FontWeight.w400;
    final FontWeight chosenIcon = FontWeight.w600;

    Color navBarBgColor = isDark 
      ? AppColors.buttonBackgroundDark.withValues(alpha: 0.4) 
      : AppColors.buttonBackgroundLight.withValues(alpha: 0.15);
    
    Color iconSelected = isDark
      ? AppColors.navSelectedDark
      : AppColors.navSelectedLight;
    Color iconUnselected = isDark
      ? AppColors.navUnselectedDark
      : AppColors.navUnselectedLight;

    return SizedBox(
      height: barHeight,
      child: Padding(
        padding: EdgeInsets.only(left: navSpacing/2, right: navSpacing/2, bottom: navSpacing),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(outerCurve),
            topRight: Radius.circular(outerCurve),
            bottomLeft: Radius.circular(outerCurve),
            bottomRight: Radius.circular(outerCurve),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              backgroundColor: navBarBgColor,
              elevation: 0,
              currentIndex: currentIndex == -1 ? 0 : currentIndex,
              selectedItemColor: currentIndex == -1
              ? iconUnselected
              : iconSelected,
              unselectedItemColor: iconUnselected,
              selectedIconTheme: IconThemeData(
                color: currentIndex == -1
                ? iconUnselected
                : iconSelected,
                size: iconSize,
              ),
              selectedLabelStyle: TextStyle(
                color: iconSelected,
                fontWeight: currentIndex == -1 ? unchosenIcon : chosenIcon,
              ),
              unselectedLabelStyle: TextStyle(
                color: iconUnselected,
                fontWeight: unchosenIcon,
              ),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme: IconThemeData(size: iconSize),
              onTap: (index) {
                Widget target;
                if (index == 0) {
                  target = FillerPage(userId: ' ',);
                }
                else if (index == 1) {
                  target = ReminderCollectionPage();
                }
                else if (index == 2) {
                  target = HomePage(userId: ' ',);
                }
                else if (index == 3) {
                  target = ConnectionsTestPage();
                }
                else if (index == 4) {
                  target = ProfilePage();
                }
                else {
                  return;
                }
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (_, _, _) => target,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
              },
              items: [
                buildItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: "Settings",
                  index: 0,
                ),
                buildItem(
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  label: "Calendar",
                  index: 1,
                ),
                buildItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: "Home",
                  index: 2,
                ),
                buildItem(
                  icon: Icons.people_outlined,
                  activeIcon: Icons.people,
                  label: "Friends",
                  index: 3,
                ),
                buildItem(
                  icon: Icons.person_outlined,
                  activeIcon: Icons.person,
                  label: "Profile",
                  index: 4,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}