import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

/// StudyMatch logo widget matching the brand logo design
class StudyMatchLogo extends StatelessWidget {
  const StudyMatchLogo({
    super.key,
    this.size = 80,
    this.showText = false,
  });

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Heart logo with book and magnifying glass
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Heart shape split in two colors
              CustomPaint(
                size: Size(size, size),
                painter: _HeartPainter(),
              ),
              // Book icon in center
              Icon(
                Icons.menu_book_rounded,
                size: size * 0.35,
                color: Colors.white,
              ),
              // Magnifying glass overlay
              Positioned(
                right: size * 0.15,
                top: size * 0.2,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amber,
                      width: 2.5,
                    ),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(size * 0.05),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              // Handle of magnifying glass
              Positioned(
                right: size * 0.05,
                top: size * 0.35,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Container(
                    width: size * 0.15,
                    height: size * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // Sparkles/stars
              Positioned(
                left: size * 0.1,
                bottom: size * 0.15,
                child: Icon(
                  Icons.star_rounded,
                  size: size * 0.12,
                  color: AppColors.primaryBlue,
                ),
              ),
              Positioned(
                right: size * 0.15,
                top: size * 0.1,
                child: Icon(
                  Icons.star_rounded,
                  size: size * 0.12,
                  color: AppColors.secondaryPink,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          // Text with split colors
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Study',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Match',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryPink,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Custom painter for the heart shape split in two colors
class _HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;

    final paintPink = Paint()
      ..color = AppColors.secondaryPink
      ..style = PaintingStyle.fill;

    final outlineBlue = Paint()
      ..color = AppColors.primaryBlueDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final outlinePink = Paint()
      ..color = AppColors.secondaryPinkDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final heartSize = size.width * 0.75;

    // Create heart path using Bezier curves
    final path = Path();
    
    // Start from bottom point
    path.moveTo(centerX, centerY + heartSize * 0.25);
    
    // Left lobe (blue side)
    path.cubicTo(
      centerX - heartSize * 0.25,
      centerY + heartSize * 0.1,
      centerX - heartSize * 0.5,
      centerY - heartSize * 0.15,
      centerX - heartSize * 0.3,
      centerY - heartSize * 0.4,
    );
    path.cubicTo(
      centerX - heartSize * 0.15,
      centerY - heartSize * 0.55,
      centerX - heartSize * 0.05,
      centerY - heartSize * 0.5,
      centerX,
      centerY - heartSize * 0.4,
    );
    
    // Right lobe (pink side)
    path.cubicTo(
      centerX + heartSize * 0.05,
      centerY - heartSize * 0.5,
      centerX + heartSize * 0.15,
      centerY - heartSize * 0.55,
      centerX + heartSize * 0.3,
      centerY - heartSize * 0.4,
    );
    path.cubicTo(
      centerX + heartSize * 0.5,
      centerY - heartSize * 0.15,
      centerX + heartSize * 0.25,
      centerY + heartSize * 0.1,
      centerX,
      centerY + heartSize * 0.25,
    );
    
    path.close();

    // Create clipping paths for left and right halves
    final leftClipPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, centerX, size.height));
    
    final rightClipPath = Path()
      ..addRect(Rect.fromLTWH(centerX, 0, centerX, size.height));

    // Draw left half (blue) with clipping
    canvas.save();
    canvas.clipPath(leftClipPath);
    canvas.drawPath(path, paintBlue);
    canvas.restore();
    
    // Draw right half (pink) with clipping
    canvas.save();
    canvas.clipPath(rightClipPath);
    canvas.drawPath(path, paintPink);
    canvas.restore();

    // Draw outlines
    canvas.drawPath(path, outlineBlue);
    
    // Draw center divider line
    final dividerPath = Path()
      ..moveTo(centerX, centerY + heartSize * 0.25)
      ..lineTo(centerX, centerY - heartSize * 0.55);
    canvas.drawPath(dividerPath, outlineBlue);
    canvas.drawPath(dividerPath, outlinePink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

