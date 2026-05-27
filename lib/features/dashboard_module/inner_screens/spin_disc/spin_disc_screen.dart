import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/spin_disc/provider/spin_disc_provider.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/spin_disc/widgets/spin_disc_widget.dart';
import 'package:daily_cash/services/coin_service.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/ad_notice_text.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../db/app_db.dart';
import '../../../../di/injector.dart';
import '../../../../gen/assets.gen.dart';

class SpinDiscScreen extends StatelessWidget {
  const SpinDiscScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpinDiscProvider(),
      child: const _SpinDiscContent(),
    );
  }
}

class _SpinDiscContent extends StatefulWidget {
  const _SpinDiscContent();

  @override
  State<_SpinDiscContent> createState() => _SpinDiscContentState();
}

class _SpinDiscContentState extends State<_SpinDiscContent> {
  final GlobalKey<SpinDiscWidgetState> _wheelKey =
      GlobalKey<SpinDiscWidgetState>();

  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'spin_wheel_screen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SpinDiscProvider>().updateSectors(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinDiscProvider>(
      builder: (context,provider,_) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            RoutingHelper().handleBackPress(context);
          },
          child: Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: SharedAppBar(
              title: 'Spin Wheel',
              actions: [
                _buildCoinBadge(context)
              ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppDimens.h20),

                _buildHeaderBadge(context),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                    child: Center(
                      child: SpinDiscWidget(
                        key: _wheelKey,
                        onAnimationComplete: (winValue) async {
                          provider.completeSpin();
                          if (context.mounted) {
                            _showClaimDialog(context, winValue);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                _buildFooter(context, provider),
                SizedBox(height: AppDimens.h24),
              ],
            ),
          ),
          ),
        );
      }
    );
  }
  Widget _buildCoinBadge(BuildContext context) {
    return StreamBuilder(
      stream: Injector.instance<AppDB>().userListenable(),
      builder: (context, _) {
        final coins = Injector.instance<AppDB>().userModel?.coin.toInt() ?? 0;
        return Container(
          margin: EdgeInsets.only(right: AppDimens.w10),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w12, vertical: AppDimens.h6),
          decoration: BoxDecoration(
            color: context.themeColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.tokens.svg(height: AppDimens.h20, width: AppDimens.w20),
              SizedBox(width: AppDimens.w6),
              Text(
                '$coins',
                strutStyle: StrutStyle(fontSize: AppDimens.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildHeaderBadge(BuildContext context) {
    final tc = context.themeColors;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.w24),
      decoration: BoxDecoration(
        gradient: tc.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimens.r14 + 1.2),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w16, vertical: AppDimens.h12),
        decoration: BoxDecoration(
          color: tc.backgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.r14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spin to Earn!',
              strutStyle: StrutStyle(
                fontSize: AppDimens.sp16,
                height: 1.1,
                forceStrutHeight: true,
              ),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w16, vertical: AppDimens.h8),
              decoration: BoxDecoration(
                color: context.themeTextColors.blueTextColor,
                borderRadius: BorderRadius.circular(AppDimens.r10),
              ),
              child: Text(
                'Free',
                strutStyle: StrutStyle(
                  fontSize: AppDimens.sp14,
                  height: 1.1,
                  forceStrutHeight: true,
                ),
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SpinDiscProvider provider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
          child: GradientActionButton(
            text: 'Spin Now',
            onPressed: provider.isSpinning
                ? null
                : () {
                    AnalyticsManager.instance.logEvent(name: 'spin_wheel_spun');
                    final double targetDeg = provider.spin();
                    _wheelKey.currentState?.spin(targetDeg);
                  },
          ),
        ),
        SizedBox(height: AppDimens.h16),
        Text(
          'Spin daily to earn more coins!',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            fontSize: AppDimens.sp14,
          ),
        ),
      ],
    );
  }

  void _showClaimDialog(BuildContext context, int winValue) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.themeColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.tokens.svg(width: AppDimens.w28, height: AppDimens.h28),
            SizedBox(width: AppDimens.w8),
            Text(
              '+$winValue Coins',
              strutStyle: StrutStyle(
                fontSize: AppDimens.sp22,
                height: 1.1,
                forceStrutHeight: true,
              ),
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontWeight: FontWeight.w700,
                fontSize: AppDimens.sp22,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You won $winValue coins! Tap below to claim.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.descriptionColor,
                fontSize: AppDimens.sp15,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            spacing: AppDimens.h2,
            children: [
              AdNoticeText(show: RewardAdService.isSpinWheelAdEnabled),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(AppDimens.w12, 0, AppDimens.w12, AppDimens.h12),
                  child: GradientActionButton(
                    text: 'Claim Reward',
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      final earnedCoins = await RewardAdService.showSpinWheel(context, defaultCoins: winValue);
                      if (earnedCoins == null) return;
                      await CoinService.addCoins(earnedCoins);
                      AnalyticsManager.instance.logEvent(
                        name: 'spin_wheel_complete',
                        parameters: {'coins_won': earnedCoins},
                      );
                      if (context.mounted) {
                        "You won $earnedCoins coins!".showSuccessAlert();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
