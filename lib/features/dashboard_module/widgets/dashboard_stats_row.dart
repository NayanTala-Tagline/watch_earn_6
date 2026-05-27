import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Three quick-stat cards: Level | Today | XP
/// Matches the gradient-based design in the provided image.
class DashboardStatsRow extends StatelessWidget {
  const DashboardStatsRow({super.key, this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // ─── Level ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GlowBox(
                  borderRadius: 14,
                  highlight: context.themeColors.secondaryGradient4,
                  child: _MetricCard(
                    icon: Assets.icons.tier.svg(width: AppDimens.w22, height: AppDimens.h22),
                    value: '${user?.level.toStringAsFixed(0)}',
                    label: context.l10n.level,
                    gradient: LinearGradient(
                      colors: [context.themeColors.secondaryGradient4, Color(0xff48B2ED), context.themeColors.secondaryGradient5],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderColor: context.themeColors.secondaryGradient2,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimens.w10),

            // ─── Today ───────────────────────────────────
            // Expanded(
            //   child: _MetricCard(
            //     icon: Assets.icons.fire.svg(
            //       width: AppDimens.w22,
            //       height: AppDimens.h22,
            //     ),
            //     value: '${provider.todayEarnings}',
            //     label: 'Today',
            //     gradient: const LinearGradient(
            //       colors: [Color(0xFF38BDF8), Color(0xFF10B981)],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     borderColor:  context.themeColors.secondaryGradient2
            //   ),
            // ),
            // SizedBox(width: AppDimens.w10),

            // ─── XP ──────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: GlowBox(
                  borderRadius: 14,
                  highlight: context.themeColors.secondaryGradient4,

                  child: _MetricCard(
                    icon: Assets.icons.experience.svg(width: AppDimens.w22, height: AppDimens.h22),
                    value: '${user?.xp.toStringAsFixed(0)}',
                    label: context.l10n.xp,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38BDF8), Color(0xFFA855F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderColor: context.themeColors.secondaryGradient4,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Individual Card for Quick Stats
class _MetricCard extends StatelessWidget {
  final Widget icon;
  final String value;
  final String label;
  final Gradient gradient;
  final Color borderColor;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.w10),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDimens.r14),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Icon Container (Semi-transparent dark box as per image)
          Container(
            padding: EdgeInsets.all(AppDimens.w8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimens.r10),
            ),
            child: Center(child: icon),
          ),
          SizedBox(width: AppDimens.w10),
          // Value & Label Column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontSize: AppDimens.sp20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.textColor.withValues(alpha: 0.8),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
