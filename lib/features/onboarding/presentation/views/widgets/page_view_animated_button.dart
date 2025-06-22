import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';

class PageViewAnimatedButton extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;

  const PageViewAnimatedButton({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (currentPage + 1) / totalPages;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 67,
              height: 67,
              child: CustomPaint(
                painter: _DashedCirclePainter(
                  progress: value,
                  strokeWidth: 3,
                  color: Colors.green,
                  dashCount: totalPages,
                  gapRatio: 0.2,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
                backgroundColor: AppColors.primaryAppColor,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final int dashCount;
  final double gapRatio;

  _DashedCirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.dashCount,
    this.gapRatio = 0.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final radius = (size.width / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const totalAngle = 2 * 3.141592653589793;
    final dashAngle = totalAngle / dashCount;
    final gapAngle = dashAngle * gapRatio;
    final drawAngle = dashAngle - gapAngle;

    for (int i = 0; i < dashCount; i++) {
      double startProgress = i / dashCount;
      double endProgress = (i + 1) / dashCount;
      double dashProgress;

      if (progress >= endProgress) {
        dashProgress = 1.0;
      } else if (progress <= startProgress) {
        dashProgress = 0.0;
      } else {
        dashProgress = (progress - startProgress) * dashCount;
        dashProgress = dashProgress.clamp(0.0, 1.0);
      }

      if (dashProgress > 0) {
        double angleToDraw = drawAngle * dashProgress;
        final startAngle = -3.141592653589793 / 2 + i * dashAngle;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          angleToDraw,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.gapRatio != gapRatio;
  }
}
