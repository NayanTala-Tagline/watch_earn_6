import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/gradient_panel.dart';
import 'package:flutter/material.dart';

/// Balance display card matching Figma design
class FundsCard extends StatelessWidget {
  final String balance;
  final String label;
  final String? subtitle;
  final Widget? trailing;

  const FundsCard({super.key, required this.balance, required this.label, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GradientPanel(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w20, vertical: AppDimens.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(balance, style: context.textTheme.displayLarge?.copyWith(fontSize: AppDimens.sp34)),
                    SizedBox(height: AppDimens.h4),
                    Text(
                      label,
                      style: context.textTheme.bodySmall?.copyWith(color: context.themeTextColors.descriptionColor),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppDimens.h12),
            Text(subtitle!, style: context.textTheme.labelMedium),
          ],
        ],
      ),
    );
  }
}
