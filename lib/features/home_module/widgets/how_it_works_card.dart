import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:daily_cash/widgets/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';

class HowItWorksCard extends StatelessWidget {
  const HowItWorksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => NavigationHelper().navigateWithAdCheck(
            context, () => context.pushNamed(AppRoutes.howItWorks)),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: GlowContainer(
              accent: context.themeColors.primaryGradient2,
              child: GradientCard(
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
                padding: EdgeInsets.symmetric(horizontal: AppSize.w16, vertical: AppSize.h16),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(AppSize.r10),
                      decoration: BoxDecoration(
                        color: Color(0xff080A1B).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppSize.r10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSize.w5),
                        child: Assets.icons.profileIcons.help.svg(
                          height: AppSize.h25,
                          width: AppSize.w24
                        ),
                      )
                    ),
                    SizedBox(width: AppSize.w16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.howItWork,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppSize.sp16,
                            ),
                          ),
                          SizedBox(height: AppSize.h4),
                          Text(
                            context.l10n.learnToEarn,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.themeTextColors.descriptionColor,
                              fontSize: AppSize.sp13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right Arrow
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.themeTextColors.descriptionColor,
                      size: AppSize.r24,
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
