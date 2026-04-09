import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../widgets/filler_tile.dart';
import '../themes/app_colors.dart';

class ConnectionsPage extends StatelessWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding),
                child: Text(
                  "Connections",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),

              // Divider
              Divider(
                color: isDark ? Colors.white : Colors.black54,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),

              SizedBox(height: sizeboxSize),

              // Tiles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FillerTile(
                            title: "Connection Requests",
                            onTap: () {
                              Navigator.pushNamed(context, '/requestpage');
                            },
                            inMiddle: false,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizeboxSize),

                    Row(
                      children: [
                        Expanded(
                          child: FillerTile(
                            title: "Connection Invites",
                            onTap: () {
                              Navigator.pushNamed(context, '/invitepage');
                            },
                            inMiddle: false,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizeboxSize),
                  ],
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: NavBar(
          currentIndex: 3,
        ),
      ),
    );
  }
}
