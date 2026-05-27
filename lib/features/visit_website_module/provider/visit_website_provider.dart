import 'dart:async';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/services/coin_service.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:flutter/cupertino.dart';
import '../../../utils/anaytics_manager.dart';
import '../../../utils/remote_config.dart';
import '../../../utils/rewarded_ad_helper.dart';

class VisitWebsiteProvider extends ChangeNotifier {
  int get _missionSeconds => RemoteConfigService.instance.websiteVisitTimer;
  static int lockMinutes = RemoteConfigService.instance.websiteLockMinutes;
  int get _rewardCoins => RemoteConfigService.instance.websiteRewardCoins;

  final _db = Injector.instance<AppDB>();

  final Map<int, int> _remaining = {};
  final Map<int, Timer> _timers = {};
  final Map<int, bool> _completed = {};
  final Map<int, bool> _claimed = {};

  /// Returns a user-scoped Hive key so locks are per-user, not global.
  String _lockKey(int index) {
    final uid = _db.userModel?.userId ?? 'guest';
    return 'vw_lock_${uid}_$index';
  }


  int remaining(int index) => _remaining[index] ?? _missionSeconds;
  bool isRunning(int index) => _timers.containsKey(index);
  bool isCompleted(int index) => _completed[index] ?? false;
  bool isClaimed(int index) => _claimed[index] ?? false;

  bool isLocked(int index) {
    final expiry = _db.getValue<int?>(_lockKey(index));
    if (expiry == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expiry;
  }

  String lockCountdown(int index) {
    final expiry = _db.getValue<int?>(_lockKey(index));
    if (expiry == null) return '';
    final diff = expiry - DateTime.now().millisecondsSinceEpoch;
    if (diff <= 0) return '';
    final total = (diff / 1000).ceil();
    final m = total ~/ 60;
    final s = total % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void startMission(int index) {
    if (isRunning(index) || isLocked(index)) return;
    _remaining[index] = _missionSeconds;
    _completed[index] = false;
    _claimed[index] = false;

    // Add timer BEFORE notifyListeners so isRunning() returns true
    // when listeners check state
    _timers[index] = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = (_remaining[index] ?? 1) - 1;
      _remaining[index] = left;
      if (left <= 0) {
        t.cancel();
        _timers.remove(index);
        _completed[index] = true;
      }
      notifyListeners();
    });

    notifyListeners();
  }


  Future<void> onAppResumed({void Function(int index)? onCompleted}) async {
    final running = _timers.keys.toList();

    for (final index in running) {
      _timers[index]?.cancel();
      _timers.remove(index);

      final timeLeft = _remaining[index] ?? _missionSeconds;

      if (timeLeft <= 0) {
        _completed[index] = true;
        final expiry = DateTime.now()
            .add(Duration(minutes: lockMinutes))
            .millisecondsSinceEpoch;
        await _db.setValue(_lockKey(index), expiry);
        onCompleted?.call(index);
      } else {
        // Came back early → just reset, no dialog
        _remaining[index] = _missionSeconds;
        _completed[index] = false;
      }
    }

    // Timer may have already fired and removed itself before app resumed —
    // check for completed-but-unclaimed missions and surface the dialog.
    for (final i in _completed.keys) {
      if ((_completed[i] ?? false) && !(_claimed[i] ?? false) && !_timers.containsKey(i)) {
        onCompleted?.call(i);
      }
    }
    notifyListeners();
  }

  void cancelMission(int index) {
    _timers[index]?.cancel();
    _timers.remove(index);
    _remaining[index] = _missionSeconds;
    _completed[index] = false;
    notifyListeners();
  }

  Future<bool> claimReward(int index, BuildContext context) async {
    if (!isCompleted(index) || isClaimed(index)) return false;

    // Show rewarded ad (Support Us bottom sheet) — cancel = no reward
    final earnedCoins = await RewardAdService.showWebsiteReward(context, defaultCoins: _rewardCoins);
    if (earnedCoins == null) return false; // cancelled — caller should close dialog

    _claimed[index] = true;
    notifyListeners();

    await CoinService.addCoins(earnedCoins);

    final expiry = DateTime.now()
        .add(Duration(minutes: lockMinutes))
        .millisecondsSinceEpoch;
    await _db.setValue(_lockKey(index), expiry);
    notifyListeners();
    return true; // success
  }

  // Future<void> loadWebsiteClaimRewardedAd(BuildContext context) async {
  //   try {
  //     LoadingOverlay.instance().show(context: context);
  //
  //     final rewardAd = RewardedAdManager(
  //       adData: RemoteConfigService.instance.websiteReward,
  //       listener: RewardedAdLoadCallback(
  //         onAdFailedToLoad: (_) {},
  //         onAdLoaded: (_) {},
  //       ),
  //     );
  //
  //     rewardAd.load();
  //     await rewardAd.future();
  //     await rewardAd.show(onUserEarnedReward: (_, _) {});
  //     await Future.delayed(Duration(milliseconds: 400), () {});
  //   } finally {
  //     LoadingOverlay.instance().hide();
  //   }
  // }

  Future<void> loadWebsiteClaimRewardedAd(BuildContext context) async {
    await RewardAdHelper.showRewardAdWithBottomSheet(
      context: context,
      adData: RemoteConfigService.instance.websiteReward,
      defaultCoins: _rewardCoins,
      onAdCompleted: (_) {},
      onAdCancelled: () {
        AnalyticsManager.instance.logEvent(name: "cancel_website_visit_claim");
      },
    );
  }


  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
