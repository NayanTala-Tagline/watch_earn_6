import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlowBox extends StatefulWidget {
  final Widget child;
  final Color highlight;
  final double borderRadius;
  final double strokeWith;
  final EdgeInsetsGeometry padding;

  const GlowBox({
    super.key,
    required this.child,
    this.highlight = Colors.white,
    this.borderRadius = 12,
    this.strokeWith = 2,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<GlowBox> createState() => _GlowBoxState();
}

class _GlowBoxState extends State<GlowBox> with SingleTickerProviderStateMixin {
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
        painter: _GlowEdgePainter(
          strokeWidth: widget.strokeWith,
          progress: _animController.value, highlight: widget.highlight, radius: widget.borderRadius),
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius - 0.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(Colors.black, widget.highlight, 0.09)!, const Color(0xFF040E1B)],
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
                    gradient: RadialGradient(colors: [widget.highlight.withValues(alpha: 0.18), Colors.transparent]),
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
                      colors: [Colors.transparent, widget.highlight.withValues(alpha: 0.55), Colors.transparent],
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

class _GlowEdgePainter extends CustomPainter {
  final double progress;
  final Color highlight;
  final double radius;
  final double strokeWidth;

  _GlowEdgePainter({required this.progress, required this.highlight, required this.radius, required this.strokeWidth});

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
        ..color = highlight.withValues(alpha: 0.18),
    );

    // outer blur glow
    canvas.drawRRect(
      roundedRect,
      Paint()
        ..color = highlight.withValues(alpha: 0.15)
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
          ..color = highlight.withValues(alpha: opacity * 0.95),
      );
    }
  }

  @override
  bool shouldRepaint(_GlowEdgePainter o) => o.progress != progress;
}
