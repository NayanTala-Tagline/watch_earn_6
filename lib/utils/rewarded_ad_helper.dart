import 'package:ad_manager/ad_manager.dart';
import 'package:flutter/material.dart';
import '../widgets/loading_overlay/loading_overlay.dart';
import '../widgets/rewarded_ad_bottom_sheet.dart';

class RewardAdHelper {
  static Future<void> showRewardAdWithBottomSheet({
    required BuildContext context,
    required AdData adData,
    required int defaultCoins,
    void Function(int coins)? onAdCompleted,
    VoidCallback? onAdCancelled,
  }) async {
    // Skip the bottom sheet entirely if the ad is disabled
    if (!adData.enabled) {
      onAdCompleted?.call(defaultCoins);
      return;
    }

    bool willShowAd = false;

    await showRewardAdBottomSheet(
      context: context,
      onSupportUs: () {
        willShowAd = true;
      },
      onCancel: () {
        willShowAd = false;
        onAdCancelled?.call();
      },
    );

    if (willShowAd && context.mounted) {
      final earnedCoins = await _showRewardAd(context, adData, defaultCoins);
      onAdCompleted?.call(earnedCoins);
    }
  }

  /// Shows the rewarded ad and returns the coins to grant.
  /// Coins = max(defaultCoins, floor((valueMicros / 1_000_000) * 30)).
  /// Falls back to defaultCoins if the paid event never fires.
  static Future<int> _showRewardAd(BuildContext context, AdData adData, int defaultCoins) async {
    double? recordedMicros;

    try {
      LoadingOverlay.instance().show(context: context);

      final rewardAdInstance = RewardedAdManager(
        adData: adData,
        listener: RewardedAdLoadCallback(
          onAdFailedToLoad: (_) {},
          onAdLoaded: (_) {},
        ),
      );

      rewardAdInstance.load();
      await rewardAdInstance.future();
      await rewardAdInstance.show(onUserEarnedReward: (_, _) {}, context: context);
      await Future.delayed(const Duration(milliseconds: 400));
    } finally {
      LoadingOverlay.instance().hide();
    }

    return defaultCoins;
  }
}
