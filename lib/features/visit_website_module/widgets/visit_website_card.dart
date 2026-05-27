import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';

class VisitWebsiteCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final int reward;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  const VisitWebsiteCard({
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
          borderRadius: BorderRadius.circular(AppSize.r14),
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
          padding: EdgeInsets.symmetric(horizontal: AppSize.w16, vertical: AppSize.h16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSize.r14),
          ),
          child: Row(
            children: [
              Container(
                width: AppSize.w54,
                height: AppSize.w54,
                padding: EdgeInsets.all(AppSize.w10),
                decoration: BoxDecoration(
                  color: startColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSize.r12),
                ),
                child: icon,
              ),
              SizedBox(width: AppSize.w16),

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
                        fontSize: AppSize.sp18,
                      ),
                    ),
                    SizedBox(height: AppSize.h8),
                    Row(
                      spacing: AppSize.w5,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSize.w8, vertical: AppSize.h4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppSize.r20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.coins.svg(width: AppSize.w14, height: AppSize.w14),
                              SizedBox(width: AppSize.w6),
                              Text(
                                '+$reward',
                                strutStyle: StrutStyle(
                                  fontSize: AppSize.sp14,
                                  height: 1.1,
                                  forceStrutHeight: true,
                                ),
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.themeTextColors.greenTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppSize.sp14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Coins',
                          strutStyle: StrutStyle(
                            fontSize: AppSize.sp16,
                            height: 1.1,
                            forceStrutHeight: true,
                          ),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.themeTextColors.descriptionColor,
                            fontWeight: FontWeight.w400,
                            fontSize: AppSize.sp16,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              
             Assets.icons.openArrow.svg(
               height: AppSize.h25,
               width: AppSize.w24
             )
            ],
          ),
        ),
      ),
    );
  }
}
