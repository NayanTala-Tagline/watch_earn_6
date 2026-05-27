import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeBottomActions extends StatelessWidget {
  const HomeBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: GlowContainer(
                  accent: context.themeColors.primary,
                  child: _ActionCard(
                    title: context.l10n.leaderboard,
                    icon: Assets.icons.rankings,
                    onTap: () =>
                        NavigationHelper().navigateWithAdCheck(context, () => context.goNamed(AppRoutes.leaderboard)),
                    color: context.themeColors.primary,
                    borderColor: context.themeColors.primary,
                  ),
                ),
              ),
            ),
            // SizedBox(width: AppSize.w10),
            // Expanded(
            //   child: _ActionCard(
            //     title: 'Achievement',
            //     icon: Assets.icons.achievement,
            //     onTap: ()=> context.pushNamed(AppRoutes.achievement),
            //     color: context.themeColors.secondaryGradient4,
            //     borderColor: context.themeColors.secondaryGradient2 ,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final SvgGenImage icon;
  final VoidCallback? onTap;
  final Color color;
  final Color borderColor;

  const _ActionCard({
    required this.title,
    required this.icon,
    this.onTap,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSize.w16, vertical: AppSize.h12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.r10),
          gradient: LinearGradient(
            colors: [Color(0xff080A1B), Color(0xff100C29)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSize.w8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSize.r10),
              ),
              child: icon.svg(width: AppSize.w20, height: AppSize.h20),
            ),
            SizedBox(width: AppSize.w10),
            Expanded(
              child: Text(
                title,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppSize.sp16,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
