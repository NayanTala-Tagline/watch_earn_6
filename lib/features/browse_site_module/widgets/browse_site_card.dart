import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';

class BrowseSiteCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final int reward;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  const BrowseSiteCard({
    super.key,
    required this.icon,
    required this.title,
    required this.reward,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.r14),
          gradient: LinearGradient(
            colors: [
              startColor.withValues(alpha: 0.6),
              endColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppDimens.r14),
          ),
          child: Row(
            children: [
              Container(
                width: AppDimens.w54,
                height: AppDimens.w54,
                padding: EdgeInsets.all(AppDimens.w10),
                decoration: BoxDecoration(
                  color: startColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                ),
                child: icon,
              ),
              SizedBox(width: AppDimens.w16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.themeTextColors.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.sp18,
                      ),
                    ),
                    SizedBox(height: AppDimens.h8),
                    Row(
                      spacing: AppDimens.w5,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppDimens.w8, vertical: AppDimens.h4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppDimens.r20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.tokens.svg(width: AppDimens.w14, height: AppDimens.w14),
                              SizedBox(width: AppDimens.w6),
                              Text(
                                '+$reward',
                                strutStyle: StrutStyle(
                                  fontSize: AppDimens.sp14,
                                  height: 1.1,
                                  forceStrutHeight: true,
                                ),
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.themeTextColors.greenTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppDimens.sp14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Coins',
                          strutStyle: StrutStyle(
                            fontSize: AppDimens.sp16,
                            height: 1.1,
                            forceStrutHeight: true,
                          ),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.themeTextColors.descriptionColor,
                            fontWeight: FontWeight.w400,
                            fontSize: AppDimens.sp16,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              
             Assets.icons.expandArrow.svg(
               height: AppDimens.h25,
               width: AppDimens.w24
             )
            ],
          ),
        ),
      ),
    );
  }
}
