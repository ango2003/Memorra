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
    final screen_width = MediaQuery.of(context).size.width;
    final screen_height = MediaQuery.of(context).size.height;

    final base = screen_width < screen_height ? screen_width : screen_height;

    final icon_size = base * 0.055;
    final bar_height = screen_height * 0.09;

    final double outer_curve = 20;
    final double nav_spacing = 4;
    final FontWeight unchosen_icon = FontWeight.w400;
    final FontWeight chosen_icon = FontWeight.w600;

    Color nav_bar_bg_color = isDark 
      ? AppColors.buttonBackgroundDark.withValues(alpha: 0.4) 
      : AppColors.buttonBackgroundLight.withValues(alpha: 0.15);
    
    Color icon_selected = isDark
      ? AppColors.navSelectedDark
      : AppColors.navSelectedLight;
    Color icon_unselected = isDark
      ? AppColors.navUnselectedDark
      : AppColors.navUnselectedLight;

    return SizedBox(
      height: bar_height,
      child: Padding(
        padding: EdgeInsets.only(left: nav_spacing/2, right: nav_spacing/2, bottom: nav_spacing),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(outer_curve),
            topRight: Radius.circular(outer_curve),
            bottomLeft: Radius.circular(outer_curve),
            bottomRight: Radius.circular(outer_curve),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              backgroundColor: nav_bar_bg_color,
              elevation: 0,
              currentIndex: currentIndex == -1 ? 0 : currentIndex,
              selectedItemColor: currentIndex == -1
              ? icon_unselected
              : icon_selected,
              unselectedItemColor: icon_unselected,
              selectedIconTheme: IconThemeData(
                color: currentIndex == -1
                ? icon_unselected
                : icon_selected,
                size: icon_size,
              ),
              selectedLabelStyle: TextStyle(
                color: icon_selected,
                fontWeight: currentIndex == -1 ? unchosen_icon : chosen_icon,
              ),
              unselectedLabelStyle: TextStyle(
                color: icon_unselected,
                fontWeight: unchosen_icon,
              ),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme: IconThemeData(size: icon_size),
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