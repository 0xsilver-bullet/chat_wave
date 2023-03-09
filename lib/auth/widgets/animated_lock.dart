import 'package:flutter/material.dart';

class AnimatedLock extends StatefulWidget {
  const AnimatedLock({
    super.key,
    required this.color,
    required this.onClick,
    this.lockEnabled = false,
    this.locked = true,
    this.onLockOpenCallback,
  });

  final Color color;
  final VoidCallback onClick;
  final bool lockEnabled;
  final bool locked;
  final VoidCallback? onLockOpenCallback;

  @override
  State<AnimatedLock> createState() => _AnimatedLockState();
}

class _AnimatedLockState extends State<AnimatedLock>
    with TickerProviderStateMixin {
  late Animation<double> boltAnimation;
  late Animation<double> scaleAnimation;
  late AnimationController boltAnimationController;
  late AnimationController scaleAnimationController;

  @override
  void initState() {
    boltAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    Tween<double> boltTween = Tween(begin: 1.0, end: 0.0);
    boltAnimation = boltTween.animate(boltAnimationController)
      ..addListener(() {
        setState(() {});
      });
    Tween<double> scaleTween = Tween(begin: 0.8, end: 1.2);
    scaleAnimation = scaleTween.animate(scaleAnimationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedLock oldWidget) {
    if (widget.lockEnabled && !scaleAnimationController.isCompleted) {
      scaleAnimationController.forward();
    }
    if (!widget.lockEnabled && scaleAnimationController.isCompleted) {
      scaleAnimationController.reverse();
    }
    if (!widget.locked && !boltAnimationController.isCompleted) {
      boltAnimationController.forward().whenComplete(
        () {
          if (widget.onLockOpenCallback != null) {
            widget.onLockOpenCallback!();
          }
        },
      );
    } else if (widget.locked && boltAnimationController.isCompleted) {
      boltAnimationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    boltAnimationController.dispose();
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: SizedBox(
        height: 48,
        width: 48,
        child: InkWell(
          onTap: widget.onClick,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: CustomPaint(
            painter: LockPainter(
              lockScale: boltAnimation.value,
              color: widget.color,
            ),
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
