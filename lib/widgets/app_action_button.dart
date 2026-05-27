import 'dart:async';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:flutter/material.dart';

import '../utils/app_dimens.dart';

/// Global app button [FilledButton]
class AppActionButton extends StatefulWidget {
  const AppActionButton({
    required this.text,
    super.key,
    this.isLoading = false,
    this.isInactive = false,
    this.iconOnly = false,
    this.isSolidButton = true,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.buttonStyle,
    this.icon,
    this.visualDensity,
    this.textStyle,
    this.buttonColor,
    this.primary,
    this.horizontalPad,
    this.borderRadius,
    this.gradient,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isInactive;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonStyle? buttonStyle;
  final VisualDensity? visualDensity;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool iconOnly;
  final bool isSolidButton;
  final Color? buttonColor;
  final Color? primary;
  final Gradient? gradient;
  final double? horizontalPad;
  final double? borderRadius;

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton> {
  bool _isHandling = false;
  Timer? _throttleTimer;

  void _handleTap() {
    if (_isHandling) return;

    _isHandling = true;
    widget.onPressed?.call();

    _throttleTimer = Timer(
      const Duration(milliseconds: 500),
      () => _isHandling = false,
    );
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool usesCustomColor = widget.buttonColor != null;
    final bool isOutlineStyle = usesCustomColor;

    final BoxDecoration boxDeco = BoxDecoration(
      color: widget.isSolidButton
          ? widget.buttonColor ?? context.themeColors.primary
          : context.themeColors.primary,
      gradient: widget.gradient,
      borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r10),
      border: Border.all(
        width: 1,
        color: widget.isSolidButton
            ? context.themeColors.primary
            : context.themeColors.primary,
      ),
    );

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.isInactive
              ? null
              : widget.isLoading
              ? () {}
              : _handleTap,
          child: Container(
            height: AppDimens.h48,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: boxDeco,
            child: widget.isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h4),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : _buildButtonContent(context, isOutlineStyle),
          ),
        ),
        Positioned(
          top: 1,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
             
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFFFFF).withValues(alpha: 0),
                  offset: const Offset(0, 6),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context, bool isOutlineStyle) {
    final labelColor = context.themeTextColors.textColor;

    final labelWidget = Text(
      widget.text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          widget.textStyle ??
          context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: labelColor,
            fontSize: AppDimens.sp16,
          ),
    );

    if (widget.icon != null && widget.iconOnly) {
      return widget.icon!;
    } else if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppDimens.w6,
        children: [widget.icon!, labelWidget],
      );
    } else {
      return labelWidget;
    }
  }
}
