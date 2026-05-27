import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlowContainer extends StatefulWidget {
  final Widget child;
  final Color accent;
  final double borderRadius;
  final double strokeWith;
  final EdgeInsetsGeometry padding;

  const GlowContainer({
    super.key,
    required this.child,
    this.accent = Colors.white,
    this.borderRadius = 12,
    this.strokeWith = 2,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<GlowContainer> createState() => _GlowContainerState();
}

class _GlowContainerState extends State<GlowContainer> with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(vsync: this, value: math.Random().nextDouble(), duration: const Duration(seconds: 4))
    ..repeat();

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (_, child) => CustomPaint(
        painter: _GlowBorderPainter(
          strokeWidth: widget.strokeWith,
          progress: _animController.value, accent: widget.accent, radius: widget.borderRadius),
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius - 0.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(Colors.black, widget.accent, 0.09)!, const Color(0xFF040E1B)],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius - 0.5),
          child: Stack(
            children: [
              // top-right radial glow
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [widget.accent.withValues(alpha: 0.18), Colors.transparent]),
                  ),
                ),
              ),
              // bottom center line
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, widget.accent.withValues(alpha: 0.55), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // your content
              Padding(padding: widget.padding, child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBorderPainter extends CustomPainter {
  final double progress;
  final Color accent;
  final double radius;
  final double strokeWidth;

  _GlowBorderPainter({required this.progress, required this.accent, required this.radius, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final boundsRect = Offset.zero & size;
    final roundedRect = RRect.fromRectAndRadius(boundsRect, Radius.circular(radius));

    // faint base border
    canvas.drawRRect(
      roundedRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = accent.withValues(alpha: 0.18),
    );

    // outer blur glow
    canvas.drawRRect(
      roundedRect,
      Paint()
        ..color = accent.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8),
    );

    // ── spinning arc fix: PathMetrics (no seam glitch) ──
    final borderPath = Path()..addRRect(roundedRect);
    final pathMetric = borderPath.computeMetrics().first;
    final perimeter = pathMetric.length;

    const arcFraction = 0.22; // arc covers 22% of perimeter
    final arcLength = perimeter * arcFraction;
    final startOffset = progress * perimeter;

    const segmentCount = 24; // segments — more = smoother gradient
    for (int i = 0; i < segmentCount; i++) {
      final tStart = i / segmentCount;
      final tEnd = (i + 1) / segmentCount;

      final dStart = (startOffset + tStart * arcLength) % perimeter;
      final dEnd = (startOffset + tEnd * arcLength) % perimeter;

      // Bell-curve opacity: fades at tail, peaks at middle, fades at head
      final tMid = (tStart + tEnd) / 2;
      final opacity = math.sin(tMid * math.pi);

      Path segment;
      if (dEnd >= dStart) {
        segment = pathMetric.extractPath(dStart, dEnd);
      } else {
        // Handle wrap-around: stitch the two pieces together
        segment = pathMetric.extractPath(dStart, perimeter);
        segment.addPath(pathMetric.extractPath(0, dEnd), Offset.zero);
      }

      canvas.drawPath(
        segment,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 2
          ..strokeCap = StrokeCap.round
          ..color = accent.withValues(alpha: opacity * 0.95),
      );
    }
  }

  @override
  bool shouldRepaint(_GlowBorderPainter o) => o.progress != progress;
}
