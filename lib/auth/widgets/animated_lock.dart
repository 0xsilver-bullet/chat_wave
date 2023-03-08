import 'package:flutter/material.dart';

class AnimatedLock extends StatefulWidget {
  const AnimatedLock({
    super.key,
    required this.color,
    required this.onClick,
  });

  final Color color;
  final VoidCallback onClick;

  @override
  State<AnimatedLock> createState() => _AnimatedLockState();
}

class _AnimatedLockState extends State<AnimatedLock>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    Tween<double> scaleTween = Tween(begin: 1.0, end: 0.0);
    animation = scaleTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(seconds: 2), () {
      controller.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: InkWell(
        onTap: widget.onClick,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: CustomPaint(
          painter: LockPainter(
            lockScale: animation.value,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class LockPainter extends CustomPainter {
  LockPainter({
    required this.lockScale,
    required this.color,
  });

  final Color color;
  final double lockScale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 18, 32.0, 24),
        const Radius.circular(2),
      ),
      paint,
    );

    canvas.drawCircle(
      const Offset(24.0, 30.0),
      4.0,
      Paint()..color = color,
    );

    final boltPath = Path();
    boltPath.moveTo(32.0, 16.0);
    boltPath.lineTo(32.0, 12.0);
    boltPath.arcTo(
      Rect.fromCircle(center: const Offset(26.0, 12), radius: 6),
      0,
      -1.57,
      false,
    );
    boltPath.lineTo(22.0, 6.0);
    boltPath.arcTo(
      Rect.fromCircle(center: const Offset(22.0, 12), radius: 6),
      -1.57,
      -1.57,
      false,
    );
    boltPath.lineTo(16.0, 12.0 + (4.0 * lockScale));

    canvas.drawPath(boltPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
