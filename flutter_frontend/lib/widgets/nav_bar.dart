import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';
import '../screens/list_collection.dart';
import '../screens/filler_page.dart';
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
    icon: Icon(isSelected ? activeIcon : icon),
    label: label,
  );
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final iconSize = screenWidth * 0.05; // 7% of screen width

    return SizedBox(
      height: screenHeight * 0.07, // 8% of screen height
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF0A8C7A).withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.05),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentIndex == -1 ? 0 : currentIndex,
              selectedItemColor: currentIndex == -1
              ? Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Color(0xFF3A3A3A)
              : Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Color(0xFF3A3A3A),
              unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Color(0xFF3A3A3A),
              selectedIconTheme: IconThemeData(
                color: currentIndex == -1
                ? Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF3A3A3A)
                : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF3A3A3A),
                size: iconSize,
              ),
              selectedLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF3A3A3A),
                  fontWeight: currentIndex == -1 ? FontWeight.w400 : FontWeight.w600,
                ),
              unselectedLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF3A3A3A),
                  fontWeight: FontWeight.w400,
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
                  target = FillerPage(userId: ' ',);
                }
                else if (index == 2) {
                  target = HomePage(userId: ' ',);
                }
                else if (index == 3) {
                  target = ListCollectionPage();
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