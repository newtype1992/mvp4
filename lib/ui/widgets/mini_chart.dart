import 'package:flutter/material.dart';

class MiniChart extends StatelessWidget {
  const MiniChart({super.key, required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 48),
      painter: _SparklinePainter(points: points, color: Theme.of(context).colorScheme.secondary),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.points, required this.color});

  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final path = Path();
    final maxPoint = points.reduce((a, b) => a > b ? a : b);
    final minPoint = points.reduce((a, b) => a < b ? a : b);
    final range = (maxPoint - minPoint).abs() < 0.001 ? 1 : maxPoint - minPoint;
    for (var i = 0; i < points.length; i++) {
      final x = i / (points.length - 1) * size.width;
      final normalized = (points[i] - minPoint) / range;
      final y = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
