import 'dart:math';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/inner_screens/spin_wheel/model/spin_wheel_model.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:flutter/material.dart';

class SpinWheelPainter extends CustomPainter {
  final List<SpinWheelSector> sectors;

  final Color tealColor;    // #45C1FD
  final Color blueColor;    // #3345FF
  final Color purpleLight;  // #66166D
  final Color purpleDark;   // #B619FF (30% alpha)
  final Color bgColor;      // #080A1B

  const SpinWheelPainter({
    required this.sectors,
    required this.tealColor,
    required this.blueColor,
    required this.purpleLight,
    required this.purpleDark,
    required this.bgColor,
  });

  // ── Ring geometry ────────────────────────────────────────────────────
  static const double _innerRingW  = 8.0;   // pink-teal ring stroke width
  static const double _ringGap     = 10.0;  // dark gap between the two rings
  static const double _outerRingW  = 3.0;   // blue-purple ring stroke width
  static const double _outerPad    = 12.0;  // dark space outside the outer ring

  // Exposed so SpinWheelWidget can compute canvas size & arrow position
  static const double outerPad    = _outerPad;
  static const double outerRingW  = _outerRingW;
  static const double ringGap     = _ringGap;
  static const double innerRingW  = _innerRingW;

  // Total extra radius beyond the wheel body
  static const double extraRadius =
      _innerRingW + _ringGap + _outerRingW + _outerPad;

  static const double _bandFraction = 0.18; // outer band as fraction of wheel radius
  static const double _hubRadius    = 36.0;
  static const double _hubRingR     = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    // R is the wheel body radius (inner area + band), rings sit outside it
    final double totalR = size.width / 2;
    final double R      = totalR - extraRadius;   // wheel body radius
    final Offset center = Offset(totalR, totalR);
    final double innerR = R * (1 - _bandFraction);

    final int    n          = sectors.length;
    final double sweepAngle = (2 * pi) / n;
    final double startOff   = -pi / 2; // 12 o'clock

    // 1. Ambient glow
    _drawAmbientGlow(canvas, center, totalR);

    // 2. Outer decorative band
    _drawOuterBand(canvas, center, R, innerR);

    // 3. Inner sectors
    for (int i = 0; i < n; i++) {
      _drawSector(canvas, center, innerR, startOff + i * sweepAngle, sweepAngle, i, n);
    }

    // 4. Separator lines
    for (int i = 0; i < n; i++) {
      _drawSeparator(canvas, center, innerR, startOff + i * sweepAngle);
    }

    // 5. Labels
    for (int i = 0; i < n; i++) {
      _drawLabel(canvas, center, innerR,
          startOff + i * sweepAngle + sweepAngle / 2,
          sectors[i].value.toString());
    }

    // 6. Bloom dots
    for (int i = 0; i < n; i++) {
      _drawBloomDot(canvas, center, innerR, R,
          startOff + i * sweepAngle + sweepAngle / 2, i, n);
    }

    // 7. Pink-teal inner ring (just outside wheel body)
    _drawInnerRing(canvas, center, R);

    // 8. Blue-purple outer ring (with dark gap)
    _drawOuterRing(canvas, center, R);

    // 9. Hub
    _drawHub(canvas, center);
  }

  // ── Layer helpers ────────────────────────────────────────────────────

  void _drawAmbientGlow(Canvas canvas, Offset center, double totalR) {
    canvas.drawCircle(
      center,
      totalR + 10,
      Paint()
        ..shader = SweepGradient(
          colors: [
            tealColor.withValues(alpha: 0.15),
            purpleLight.withValues(alpha: 0.15),
            tealColor.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.5, 1.0],
          transform: const GradientRotation(-pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: totalR + 10))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );
  }

  void _drawOuterBand(Canvas canvas, Offset center, double R, double innerR) {
    final Rect rect = Rect.fromCircle(center: center, radius: R);
    final Paint p = Paint()
      ..shader = SweepGradient(
        colors: const [
          Color(0xFF0D3040),
          Color(0xFF5C1A2A),
          Color(0xFF6B1E2E),
          Color(0xFF3D1040),
          Color(0xFF0D3040),
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);

    canvas.drawPath(
      Path()
        ..addOval(Rect.fromCircle(center: center, radius: R))
        ..addOval(Rect.fromCircle(center: center, radius: innerR))
        ..fillType = PathFillType.evenOdd,
      p,
    );
  }

  void _drawSector(Canvas canvas, Offset center, double innerR,
      double startAngle, double sweepAngle, int index, int total) {
    final bool isTop = index <= 1 || index >= total - 2;
    final Rect rect  = Rect.fromCircle(center: center, radius: innerR);

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      true,
      Paint()
        ..shader = RadialGradient(
          colors: [
            isTop
                ? tealColor.withValues(alpha: 0.55)
                : blueColor.withValues(alpha: 0.25),
            isTop ? const Color(0xFF063040) : const Color(0xFF060A20),
          ],
          center: Alignment.center,
          radius: 1.1,
        ).createShader(rect)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawSeparator(Canvas canvas, Offset center, double innerR, double angle) {
    canvas.drawLine(
      center,
      Offset(center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawLabel(Canvas canvas, Offset center, double innerR,
      double midAngle, String text) {
    final double r = innerR * 0.56;
    final double x = center.dx + r * cos(midAngle);
    final double y = center.dy + r * sin(midAngle);

    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: rootNavKey.currentContext!.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          fontFamily: 'Manjari',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(midAngle + pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _drawBloomDot(Canvas canvas, Offset center, double innerR, double R,
      double midAngle, int index, int total) {
    final double dotR = innerR + (R - innerR) * 0.5;
    final Offset pos  = Offset(
      center.dx + dotR * cos(midAngle),
      center.dy + dotR * sin(midAngle),
    );
    final bool isTop    = index <= 1 || index >= total - 2;
    final Color dotColor = isTop ? tealColor : purpleLight;

    canvas.drawCircle(pos, 14,
        Paint()
          ..color = dotColor.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    canvas.drawCircle(pos, 9,
        Paint()..color = const Color(0xFF0A0E22));
    canvas.drawCircle(pos, 7,
        Paint()..color = dotColor.withValues(alpha: 0.85));
    canvas.drawCircle(pos, 3,
        Paint()..color = Colors.white);
  }

  void _drawInnerRing(Canvas canvas, Offset center, double R) {
    // Pink-teal ring sits right outside the wheel body (R)
    final double ringR = R + _innerRingW / 2;
    canvas.drawCircle(
      center,
      ringR,
      Paint()
        ..shader = SweepGradient(
          colors: const [
            Color(0xFF45C1FD), // teal — top
            Color(0xFFB94FBF), // pink-purple — right
            Color(0xFFE040A0), // hot pink — bottom
            Color(0xFFB94FBF), // pink-purple — left
            Color(0xFF45C1FD), // teal — back to top
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          transform: const GradientRotation(-pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: ringR))
        ..style = PaintingStyle.stroke
        ..strokeWidth = _innerRingW,
    );
  }

  void _drawOuterRing(Canvas canvas, Offset center, double R) {
    // Fill the gap between inner ring and outer ring with the bg color
    // so it looks like a clear dark padding
    final double gapInnerR = R + _innerRingW;
    final double gapOuterR = R + _innerRingW + _ringGap;
    canvas.drawPath(
      Path()
        ..addOval(Rect.fromCircle(center: center, radius: gapOuterR))
        ..addOval(Rect.fromCircle(center: center, radius: gapInnerR))
        ..fillType = PathFillType.evenOdd,
      Paint()..color = const Color(0xFF080A1B),
    );

    // Blue-purple outer ring
    final double ringR = R + _innerRingW + _ringGap + _outerRingW / 2;
    canvas.drawCircle(
      center,
      ringR,
      Paint()
        ..shader = SweepGradient(
          colors: [
            tealColor,
            blueColor,
            purpleLight,
            blueColor,
            tealColor,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
          transform: const GradientRotation(-pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: ringR))
        ..style = PaintingStyle.stroke
        ..strokeWidth = _outerRingW,
    );
  }

  void _drawHub(Canvas canvas, Offset center) {
    canvas.drawCircle(center, _hubRadius,
        Paint()..color = const Color(0xFF080A1B));
    canvas.drawCircle(center, _hubRingR,
        Paint()
          ..color = tealColor.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0);
    canvas.drawCircle(center, 10,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.85)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    canvas.drawCircle(center, 6,
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant SpinWheelPainter old) =>
      old.sectors != sectors || old.tealColor != tealColor;
}
