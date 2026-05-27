import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

/// Coin/XP badge widget matching Figma design
class TokenBadge extends StatelessWidget {
  final String value;
  final String label;
  final Color? backgroundColor;
  final Widget? icon;

  const TokenBadge({
    super.key,
    required this.value,
    required this.label,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w12,
        vertical: AppDimens.h6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFF1A1D3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: AppDimens.w4)],
          Text(
            '$value $label',
            style: context.textTheme.labelMedium?.copyWith(
              fontSize: AppDimens.sp12,
              color: context.themeTextColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
