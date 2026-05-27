import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class InviteEarnSectionBox extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget child;

  const InviteEarnSectionBox({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.h20),
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        color: themeColors.surfaceColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: themeColors.primaryGradient2.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppDimens.w12,
            children: [
              Container(
                width: AppDimens.w48,
                height: AppDimens.w48,
                decoration: BoxDecoration(
                  color: themeColors.secondaryGradient2.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimens.w8),
                  child: icon,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.themeTextColors.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.sp18,
                      ),
                    ),
                    SizedBox(height: AppDimens.h2),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                        fontSize: AppDimens.sp16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppDimens.h20),
          
          child,
        ],
      ),
    );
  }
}
