import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DashboardBottomActions extends StatelessWidget {
  const DashboardBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: GlowBox(
                  highlight: context.themeColors.primary,
                  child: _DeedCard(
                    title: context.l10n.leaderboard,
                    icon: Assets.icons.rankings,
                    onTap: () =>
                        RoutingHelper().navigateWithAdCheck(context, () => context.goNamed(AppRoutes.leaderboard)),
                    color: context.themeColors.primary,
                    borderColor: context.themeColors.primary,
                  ),
                ),
              ),
            ),
            // SizedBox(width: AppDimens.w10),
            // Expanded(
            //   child: _DeedCard(
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

class _DeedCard extends StatelessWidget {
  final String title;
  final SvgGenImage icon;
  final VoidCallback? onTap;
  final Color color;
  final Color borderColor;

  const _DeedCard({
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
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.r10),
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
              padding: EdgeInsets.all(AppDimens.w8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimens.r10),
              ),
              child: icon.svg(width: AppDimens.w20, height: AppDimens.h20),
            ),
            SizedBox(width: AppDimens.w10),
            Expanded(
              child: Text(
                title,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppDimens.sp16,
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
