import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Top Earning Opportunities section with Invite Friends & Web Visits cards
class TopEarningSection extends StatelessWidget {
  const TopEarningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final items = provider.topEarningItems(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.topEarningOpportunities,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppSize.sp18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.h12),
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.h10),
                child: _TopEarningCard(item: item),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopEarningCard extends StatelessWidget {
  final TopEarningItem item;

  const _TopEarningCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: GlowContainer(
              accent: item.color.withValues(alpha: 0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSize.w16, vertical: AppSize.h14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppSize.r10),
                  border: Border.all(color: item.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      width: AppSize.w48,
                      height: AppSize.h48,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppSize.r12),
                      ),
                      child: item.icon.svg(),
                    ),
                    SizedBox(width: AppSize.w14),
              
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppSize.sp18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppSize.h4),
                          Text(
                            item.subtitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.themeTextColors.descriptionColor,
                              fontSize: AppSize.sp16,
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
            top: AppSize.h6,
            right: AppSize.w6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h6),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${item.reward}',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppSize.sp12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
