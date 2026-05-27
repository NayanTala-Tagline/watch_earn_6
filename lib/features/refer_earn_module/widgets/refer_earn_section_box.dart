import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class ReferEarnSectionBox extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget child;

  const ReferEarnSectionBox({
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
      margin: EdgeInsets.only(bottom: AppSize.h20),
      padding: EdgeInsets.all(AppSize.w16),
      decoration: BoxDecoration(
        color: themeColors.surfaceColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSize.r16),
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
            spacing: AppSize.w12,
            children: [
              Container(
                width: AppSize.w48,
                height: AppSize.w48,
                decoration: BoxDecoration(
                  color: themeColors.secondaryGradient2.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSize.r12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSize.w8),
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
                        fontSize: AppSize.sp18,
                      ),
                    ),
                    SizedBox(height: AppSize.h2),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontWeight: FontWeight.w400,
                        fontSize: AppSize.sp16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppSize.h20),
          
          child,
        ],
      ),
    );
  }
}
