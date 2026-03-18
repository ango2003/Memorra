import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool inMiddle;

  const HomeTile({
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
    
    final double tile_height = height * 0.22;
    final double font_size = base * 0.05;
    final FontWeight font_weight = FontWeight.w600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: inMiddle ? tile_height / 1.5 : tile_height,
        decoration: BoxDecoration(
          color: Colors.grey,
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
          style: TextStyle(
            fontSize: font_size,
            fontWeight: font_weight,
          ),
        ),
      ),
    );
  }
}