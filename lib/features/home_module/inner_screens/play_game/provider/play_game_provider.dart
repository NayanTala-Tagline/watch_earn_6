import 'dart:async';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/model/game_model.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/coin_service.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:flutter/material.dart';

class PlayGameProvider extends ChangeNotifier {
  int get _missionSeconds => RemoteConfigService.instance.playGameVisitTimer;
  static int get lockMinutes => RemoteConfigService.instance.playGameLockMinutes;
  int get _rewardCoins => RemoteConfigService.instance.playGameRewardCoins;

  final _db = Injector.instance<AppDB>();

  final Map<int, int> _remaining = {};
  final Map<int, Timer> _timers = {};
  final Map<int, bool> _completed = {};
  final Map<int, bool> _claimed = {};

  String _lockKey(int index) {
    final uid = _db.userModel?.userId ?? 'guest';
    return 'pg_lock_${uid}_$index';
  }

  final List<GameItem> games = [
    GameItem(
      title: 'Running Ninja',
      reward: RemoteConfigService.instance.playGameRewardCoins,
      gradientColors: [const Color(0xFFB116FF), const Color(0xFF66166D)],
      icon: Assets.playGameIcons.spaceIntruder.image(
        height: AppSize.h40,
        width: AppSize.w40
      ),
    ),
    GameItem(
      title: 'Go Panda',
      reward: RemoteConfigService.instance.playGameRewardCoins,
      gradientColors: [const Color(0xFF246FB4), const Color(0xFF1B2C8E)],
      icon: Assets.playGameIcons.bubbleBlaster.image(
          height: AppSize.h40,
          width: AppSize.w40
      ),
    ),
    GameItem(
      title: 'Slope Run',
      reward: RemoteConfigService.instance.playGameRewardCoins,
      gradientColors: [const Color(0xFF00C6A5), const Color(0xFF003D3D)],
      icon: Assets.playGameIcons.pileTower.image(
          height: AppSize.h40,
          width: AppSize.w40
      ),
    ),
    GameItem(
      title: 'Archer Hero',
      reward: RemoteConfigService.instance.playGameRewardCoins,
      gradientColors: [const Color(0xFFFFB900), const Color(0xFF5D3F00)],
      icon: Assets.playGameIcons.riddleGame.image(
          height: AppSize.h40,
          width: AppSize.w40
      ),
    ),
    GameItem(
      title: 'Multitrack Drifting',
      reward: RemoteConfigService.instance.playGameRewardCoins,
      gradientColors: [const Color(0xFFFF1D1D), const Color(0xFF5D0000)],
      icon: Assets.playGameIcons.autoRacing.image(
          height: AppSize.h40,
          width: AppSize.w40
      ),
    ),
  ];

  final List<String> gamesUrl = [
    RemoteConfigService.instance.bubbleShooter1,
    RemoteConfigService.instance.bubbleShooter2,
    RemoteConfigService.instance.bubbleShooter3,
    RemoteConfigService.instance.bubbleShooter4,
    RemoteConfigService.instance.bubbleShooter5,
  ];

  // ── State accessors ────────────────────────────────────────────────────────

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

  // ── Mission control ────────────────────────────────────────────────────────

  void startMission(int index) {
    if (isRunning(index) || isLocked(index)) return;
    _remaining[index] = _missionSeconds;
    _completed[index] = false;
    _claimed[index] = false;

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

  void cancelMission(int index) {
    _timers[index]?.cancel();
    _timers.remove(index);
    _remaining[index] = _missionSeconds;
    _completed[index] = false;
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
        _remaining[index] = _missionSeconds;
        _completed[index] = false;
      }
    }

    for (final i in _completed.keys) {
      if ((_completed[i] ?? false) && !(_claimed[i] ?? false) && !_timers.containsKey(i)) {
        onCompleted?.call(i);
      }
    }

    notifyListeners();
  }

  Future<bool> claimReward(int index, BuildContext context) async {
    if (!isCompleted(index) || isClaimed(index)) return false;

    final earnedCoins = await RewardAdService.showPlayGameReward(context, defaultCoins: _rewardCoins);
    if (earnedCoins == null) return false;

    _claimed[index] = true;
    notifyListeners();

    await CoinService.addCoins(earnedCoins);

    final expiry = DateTime.now()
        .add(Duration(minutes: lockMinutes))
        .millisecondsSinceEpoch;
    await _db.setValue(_lockKey(index), expiry);
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
