import 'package:daily_cash/extension/ext_context.dart';
import 'package:flutter/material.dart';

/// Gradient card widget matching Figma design
/// Used for content cards with angular gradient background
class GradientPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Gradient? gradient;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GradientPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient ?? context.themeColors.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
