import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

/// Gradient button widget matching Figma design
/// Primary button with gradient background and glow effect.
class GradientActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final Widget? tailIcon;
  final double? height;
  final double? borderRadius;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const GradientActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.tailIcon,
    this.height,
    this.borderRadius,
    this.gradient,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppDimens.h48;
    final primaryGradient = gradient ?? context.themeColors.primaryGradient;
    final double br = borderRadius ?? 10;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: effectiveHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: primaryGradient,
          borderRadius: BorderRadius.circular(br),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GlowFillPainter(borderRadius: br),
              ),
            ),
            Center(
              child: Padding(
                padding: padding ?? EdgeInsets.symmetric(horizontal: AppDimens.w16),
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.themeTextColors.textColor,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            SizedBox(width: AppDimens.w8),
                          ],
                          Flexible(
                            child: Text(
                              text,
                              // StrutStyle is the professional way to force vertical centering
                              // by defining a consistent line-height box for the text.
                              strutStyle: StrutStyle(
                                fontSize: AppDimens.sp15,
                                height: 1.1,
                                forceStrutHeight: true,
                              ),
                              style: textStyle ??
                                  context.textTheme.bodyLarge?.copyWith(
                                    color: context.themeTextColors.textColor,
                                    fontSize: AppDimens.sp15,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tailIcon != null) ...[
                            SizedBox(width: AppDimens.w5),
                            tailIcon!,
                          ],
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Specialized painter for the top glow effect only
class _GlowFillPainter extends CustomPainter {
  final double borderRadius;

  _GlowFillPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // Top highlight glow (centered horizontal pulse)
    const glowHeight = 1.8;
    final glowRect = Rect.fromCenter(
      center: Offset(size.width / 2, glowHeight / 2 + 0.5),
      width: size.width * 0.85,
      height: glowHeight,
    );

    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.45),
          Colors.white.withValues(alpha: 0.6),
          Colors.white.withValues(alpha: 0.45),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ).createShader(glowRect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(glowRect, const Radius.circular(1)),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowFillPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius;
  }
}
