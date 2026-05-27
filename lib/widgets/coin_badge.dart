import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

/// Coin/XP badge widget matching Figma design
class CoinBadge extends StatelessWidget {
  final String value;
  final String label;
  final Color? backgroundColor;
  final Widget? icon;

  const CoinBadge({
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
        horizontal: AppSize.w12,
        vertical: AppSize.h6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFF1A1D3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: AppSize.w4)],
          Text(
            '$value $label',
            style: context.textTheme.labelMedium?.copyWith(
              fontSize: AppSize.sp12,
              color: context.themeTextColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
