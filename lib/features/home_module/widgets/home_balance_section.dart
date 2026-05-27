import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../db/app_db.dart';
import '../../../di/injector.dart';

/// Total Balance card with coin/XP info, money bag image,
/// and Withdraw + Rewards action buttons
class HomeBalanceSection extends StatelessWidget {
  final bool showMinWithdrawalTxt;
  final String rightBtnLabel;
  final String leftBtnLabel;
  final VoidCallback? rightOnTap;
  final VoidCallback? leftOnTap;
  final bool leftBtnVisible;
  final bool rightBtnVisible;

  const HomeBalanceSection({
    super.key,
    required this.showMinWithdrawalTxt,
    required this.rightBtnLabel,
    required this.leftBtnLabel,
    required this.rightOnTap,
    required this.leftOnTap,
    required this.leftBtnVisible,
    required this.rightBtnVisible,
  });

  @override
  Widget build(BuildContext context) {
    final result = RemoteConfigService.instance.minWithdrawAmount / RemoteConfigService.instance.coinToDollarDivider;
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return GradientCard(
          border: Border.all(color: context.themeColors.secondaryGradient2.withValues(alpha: 0.5)),
          padding: EdgeInsets.all(AppSize.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: Injector.instance<AppDB>().userListenable(),
                      builder: (context, asyncSnapshot) {
                        final user = Injector.instance<AppDB>().userModel;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.l10n.totalBalance,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.themeTextColors.descriptionColor,
                                    fontSize: AppSize.sp14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: AppSize.w10),
                                // Coin + XP capsule badge
                                Flexible(
                                  child: (user == null)
                                      ? const SizedBox.shrink()
                                      : _CoinXpBadge(
                                          coins: user.coin.toStringAsFixed(0),
                                          xp: user.xp.toStringAsFixed(0),
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSize.h10),
                            // Large balance amount
                            Text(
                              '\$${(user?.coin ?? 0) / RemoteConfigService.instance.coinToDollarDivider}',
                              style: context.textTheme.displayLarge?.copyWith(
                                fontSize: AppSize.sp34,
                                fontWeight: FontWeight.w700,
                                color: context.themeTextColors.textColor,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Money bag image
                  Assets.images.spinPrize.image(width: AppSize.w100, height: AppSize.h100, fit: BoxFit.contain),
                ],
              ),
              SizedBox(height: AppSize.h20),
              Row(
                children: [
                  if (leftBtnVisible)
                    Expanded(
                      child: _BalanceActionButton(
                        label: leftBtnLabel,
                        icon: Assets.icons.cashout.svg(
                          width: AppSize.w20,
                          height: AppSize.h20,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF523B), Color(0xFFFF7E5F)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        onTap: leftOnTap,
                      ),
                    ),

                  /// 👇 spacing only if left button exists
                  if (leftBtnVisible) SizedBox(width: AppSize.w12),

                  if (rightBtnVisible)
                    Expanded(
                      child: _BalanceActionButton(
                        label: rightBtnLabel,
                        icon: Assets.icons.award.svg(width: AppSize.w20, height: AppSize.h20),
                        gradient: LinearGradient(
                          colors: [
                            context.themeColors.primaryGradient2.withValues(alpha: 0.7),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                        border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
                        backgroundColor: const Color(0xFF0F172A),
                        onTap: rightOnTap,
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showMinWithdrawalTxt) ...[
                    const SizedBox(height: 15),
                    Text(
                      context.l10n.minWithdrawal(result),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0x90CFD9EE),
                        fontSize: AppSize.sp14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Green capsule badge for Coins + XP
class _CoinXpBadge extends StatelessWidget {
  final String coins;
  final String xp;

  const _CoinXpBadge({required this.coins, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.themeColors.primary, Color(0xFF1E1E1E)],
          begin: AlignmentGeometry.centerLeft,
          end: AlignmentGeometry.centerEnd,
        ),
        borderRadius: BorderRadius.circular(AppSize.r6),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h2),
        child: Text(
          '$coins Coins • ${xp}XP',
          strutStyle: StrutStyle(fontSize: AppSize.sp12, height: 1.1, forceStrutHeight: true),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.themeTextColors.textColor,
            fontSize: AppSize.sp12,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Styled Action Button with support for Gradient or Bordered styles
class _BalanceActionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final Gradient? gradient;
  final Border? border;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const _BalanceActionButton({
    required this.label,
    required this.icon,
    this.gradient,
    this.border,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(AppSize.r14),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h15),
          child: Center(
            // Wrap Row in Center
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: AppSize.w10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(fontSize: AppSize.sp15, height: 1.1, forceStrutHeight: true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontSize: AppSize.sp16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
