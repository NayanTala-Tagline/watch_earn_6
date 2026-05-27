import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:daily_cash/widgets/gradient_panel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';

class GuidelineCard extends StatelessWidget {
  const GuidelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => RoutingHelper().navigateWithAdCheck(
            context, () => context.pushNamed(AppRoutes.howItWorks)),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: GlowBox(
              highlight: context.themeColors.primaryGradient2,
              child: GradientPanel(
                gradient: LinearGradient(
                  colors: [
                    context.themeColors.primaryGradient2,
                    context.themeColors.primaryGradient1
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: context.themeColors.primaryGradient2
                ),
                padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h16),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(AppDimens.r10),
                      decoration: BoxDecoration(
                        color: Color(0xff080A1B).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppDimens.r10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimens.w5),
                        child: Assets.icons.profileIcons.help.svg(
                          height: AppDimens.h25,
                          width: AppDimens.w24
                        ),
                      )
                    ),
                    SizedBox(width: AppDimens.w16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.howItWork,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppDimens.sp16,
                            ),
                          ),
                          SizedBox(height: AppDimens.h4),
                          Text(
                            context.l10n.learnToEarn,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.themeTextColors.descriptionColor,
                              fontSize: AppDimens.sp13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right Arrow
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.themeTextColors.descriptionColor,
                      size: AppDimens.r24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
