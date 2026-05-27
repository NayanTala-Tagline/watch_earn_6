import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/home_module/inner_screens/spin_wheel/provider/spin_wheel_provider.dart';
import 'package:daily_cash/features/home_module/inner_screens/spin_wheel/widgets/spin_wheel_widget.dart';
import 'package:daily_cash/services/coin_service.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/ad_disclaimer_text.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../db/app_db.dart';
import '../../../../di/injector.dart';
import '../../../../gen/assets.gen.dart';

class SpinWheelScreen extends StatelessWidget {
  const SpinWheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpinWheelProvider(),
      child: const _SpinWheelContent(),
    );
  }
}

class _SpinWheelContent extends StatefulWidget {
  const _SpinWheelContent();

  @override
  State<_SpinWheelContent> createState() => _SpinWheelContentState();
}

class _SpinWheelContentState extends State<_SpinWheelContent> {
  final GlobalKey<SpinWheelWidgetState> _wheelKey =
      GlobalKey<SpinWheelWidgetState>();

  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'spin_wheel_screen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SpinWheelProvider>().updateSectors(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinWheelProvider>(
      builder: (context,provider,_) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            NavigationHelper().handleBackPress(context);
          },
          child: Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: CommonAppBar(
              title: 'Spin Wheel',
              actions: [
                _buildCoinBadge(context)
              ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppSize.h20),

                _buildHeaderBadge(context),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.w16),
                    child: Center(
                      child: SpinWheelWidget(
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
                SizedBox(height: AppSize.h24),
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
          margin: EdgeInsets.only(right: AppSize.w10),
          padding: EdgeInsets.symmetric(horizontal: AppSize.w12, vertical: AppSize.h6),
          decoration: BoxDecoration(
            color: context.themeColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppSize.r12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.tokens.svg(height: AppSize.h20, width: AppSize.w20),
              SizedBox(width: AppSize.w6),
              Text(
                '$coins',
                strutStyle: StrutStyle(fontSize: AppSize.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp20,
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
      margin: EdgeInsets.symmetric(horizontal: AppSize.w24),
      decoration: BoxDecoration(
        gradient: tc.primaryGradient,
        borderRadius: BorderRadius.circular(AppSize.r14 + 1.2),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSize.w16, vertical: AppSize.h12),
        decoration: BoxDecoration(
          color: tc.backgroundColor,
          borderRadius: BorderRadius.circular(AppSize.r14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spin to Earn!',
              strutStyle: StrutStyle(
                fontSize: AppSize.sp16,
                height: 1.1,
                forceStrutHeight: true,
              ),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppSize.sp16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.w16, vertical: AppSize.h8),
              decoration: BoxDecoration(
                color: context.themeTextColors.blueTextColor,
                borderRadius: BorderRadius.circular(AppSize.r10),
              ),
              child: Text(
                'Free',
                strutStyle: StrutStyle(
                  fontSize: AppSize.sp14,
                  height: 1.1,
                  forceStrutHeight: true,
                ),
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontSize: AppSize.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SpinWheelProvider provider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.w24),
          child: GradientButton(
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
        SizedBox(height: AppSize.h16),
        Text(
          'Spin daily to earn more coins!',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            fontSize: AppSize.sp14,
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
            Assets.icons.tokens.svg(width: AppSize.w28, height: AppSize.h28),
            SizedBox(width: AppSize.w8),
            Text(
              '+$winValue Coins',
              strutStyle: StrutStyle(
                fontSize: AppSize.sp22,
                height: 1.1,
                forceStrutHeight: true,
              ),
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontWeight: FontWeight.w700,
                fontSize: AppSize.sp22,
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
                fontSize: AppSize.sp15,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            spacing: AppSize.h2,
            children: [
              AdDisclaimerText(show: RewardAdService.isSpinWheelAdEnabled),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(AppSize.w12, 0, AppSize.w12, AppSize.h12),
                  child: GradientButton(
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
