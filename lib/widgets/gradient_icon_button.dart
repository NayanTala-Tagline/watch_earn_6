import 'package:daily_cash/extension/ext_context.dart';
import 'package:flutter/material.dart';

/// Gradient icon button matching Figma design
/// Circular button with gradient background for icons
class GradientIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;

  const GradientIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 52,
    this.gradient,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        padding: padding ?? const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: gradient ?? context.themeColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
