import 'dart:math';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/spin_disc/provider/spin_disc_provider.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/spin_disc/widgets/spin_disc_painter.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpinDiscWidget extends StatefulWidget {
  final void Function(int winValue)? onAnimationComplete;

  const SpinDiscWidget({super.key, this.onAnimationComplete});

  @override
  State<SpinDiscWidget> createState() => SpinDiscWidgetState();
}

class SpinDiscWidgetState extends State<SpinDiscWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final double finalAngle = _animation.value;
        final provider = context.read<SpinDiscProvider>();
        final int winValue = provider.computeWinFromAngle(finalAngle);
        widget.onAnimationComplete?.call(winValue);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spin(double targetRotationDegrees) {
    final double endValue = targetRotationDegrees * (pi / 180);
    // Always start from the current live angle so there's no jump
    final double currentAngle = _animation.value;
    _animation = Tween<double>(
      begin: currentAngle,
      end: endValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const _SpinArc(),
    ));
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpinDiscProvider>();
    final colors   = context.themeColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Square canvas — fits the smaller dimension
        final double canvasSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        // Arrow dimensions
        final double arrowW = AppDimens.w32;
        final double arrowH = AppDimens.h44;

        // Arrow tip Y = midpoint of the pink-teal ring from canvas top.
        // outerPad + outerRingW + ringGap = outer edge of pink-teal ring
        // + innerRingW/2 = midpoint of the ring  ← tip sits here
        const double arrowTipY =
            SpinDiscPainter.outerPad +
            SpinDiscPainter.outerRingW +
            SpinDiscPainter.ringGap +
            SpinDiscPainter.innerRingW / 2;

        // Top of the arrow widget (tip is at the bottom of the widget)
        final double arrowTop  = arrowTipY - arrowH;
        final double arrowLeft = (canvasSize - arrowW) / 2;

        return SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) => Transform.rotate(
                  angle: _animation.value,
                  child: CustomPaint(
                    size: Size(canvasSize, canvasSize),
                    painter: SpinDiscPainter(
                      sectors:     provider.sectors,
                      tealColor:   colors.secondaryGradient4,
                      blueColor:   colors.secondaryGradient3,
                      purpleLight: colors.primaryGradient1,
                      purpleDark:  colors.primaryGradient2,
                      bgColor:     colors.backgroundColor,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: arrowTop,
                left: arrowLeft,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(arrowW, arrowH),
                    painter: _ArrowMarkerPainter(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom spin curve: quick ramp-up (first 20%) then long smooth deceleration.
/// Gives the feel of a real spinning wheel — fast start, gradual stop.
class _SpinArc extends Curve {
  const _SpinArc();

  @override
  double transformInternal(double t) {
    if (t < 0.2) {
      // Fast acceleration phase (0 → 0.2 maps to 0 → 0.45)
      return Curves.easeIn.transform(t / 0.2) * 0.45;
    } else {
      // Long deceleration phase (0.2 → 1.0 maps to 0.45 → 1.0)
      return 0.45 + Curves.easeOut.transform((t - 0.2) / 0.8) * 0.55;
    }
  }
}

/// Downward-pointing white triangle — tip points into the pink-teal ring.
class _ArrowMarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(size.width / 2, size.height) // tip — bottom center
      ..lineTo(0, 0)                         // top-left
      ..lineTo(size.width, 0)                // top-right
      ..close();

    // Drop shadow
    canvas.drawPath(
      path.shift(const Offset(0, 4)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // White fill
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
