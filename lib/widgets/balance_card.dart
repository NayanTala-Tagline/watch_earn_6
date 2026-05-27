import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/gradient_card.dart';
import 'package:flutter/material.dart';

/// Balance display card matching Figma design
class BalanceCard extends StatelessWidget {
  final String balance;
  final String label;
  final String? subtitle;
  final Widget? trailing;

  const BalanceCard({super.key, required this.balance, required this.label, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: EdgeInsets.symmetric(horizontal: AppSize.w20, vertical: AppSize.h20),
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
                    Text(balance, style: context.textTheme.displayLarge?.copyWith(fontSize: AppSize.sp34)),
                    SizedBox(height: AppSize.h4),
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
            SizedBox(height: AppSize.h12),
            Text(subtitle!, style: context.textTheme.labelMedium),
          ],
        ],
      ),
    );
  }
}
