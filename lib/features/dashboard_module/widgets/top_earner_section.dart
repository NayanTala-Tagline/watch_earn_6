import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Top Earning Opportunities section with Invite Friends & Web Visits cards
class TopEarnerSection extends StatelessWidget {
  const TopEarnerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final items = provider.topEarningItems(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.topEarningOpportunities,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppDimens.h12),
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: AppDimens.h10),
                child: _TopEarnerCard(item: item),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopEarnerCard extends StatelessWidget {
  final TopEarnerItem item;

  const _TopEarnerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: GlowBox(
              highlight: item.color.withValues(alpha: 0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppDimens.r10),
                  border: Border.all(color: item.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      width: AppDimens.w48,
                      height: AppDimens.h48,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                      child: item.icon.svg(),
                    ),
                    SizedBox(width: AppDimens.w14),
              
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppDimens.sp18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppDimens.h4),
                          Text(
                            item.subtitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.themeTextColors.descriptionColor,
                              fontSize: AppDimens.sp16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: AppDimens.h6,
            right: AppDimens.w6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w10, vertical: AppDimens.h6),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${item.reward}',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppDimens.sp12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
