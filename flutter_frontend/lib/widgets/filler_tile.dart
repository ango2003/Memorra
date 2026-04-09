import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class FillerTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool inMiddle;

  const FillerTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.inMiddle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;
    
    final double tileHeight = height * 0.1;
    final double fontSize = base * 0.05;
    final FontWeight fontWeight = FontWeight.w600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: inMiddle ? tileHeight / 1.5 : tileHeight,
        decoration: BoxDecoration(
          color: AppColors.homeTile,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}