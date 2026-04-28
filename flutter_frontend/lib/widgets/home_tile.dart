import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool inMiddle;
  final CrossAxisAlignment alignment;
  final Widget? child;

  const HomeTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.inMiddle,
    required this.alignment,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;
    
    final sizeBoxSize = base * 0.05;
    final double tileHeight = height * 0.22;
    final double fontSize = base * 0.05;
    final FontWeight fontWeight = FontWeight.w600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: inMiddle ? tileHeight / 1.5 : tileHeight,
        ),
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
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),

            if (child != null) ...[
              SizedBox(height: sizeBoxSize * 0.05),
              Expanded(
                child: SizedBox.expand(
                  child: child!
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}