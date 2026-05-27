import 'package:ad_manager/ad_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/math_trivia/provider/math_trivia_provider.dart';
import 'package:daily_cash/features/dashboard_module/model/dashboard_models.dart';
import 'package:daily_cash/features/dashboard_module/widgets/daily_login_dialog.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/notification_service/notification_helper.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/logger_ex.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_router.dart';
import '../../../routes/app_routes.dart';

export 'package:daily_cash/features/dashboard_module/model/dashboard_models.dart';

class DashboardProvider extends ChangeNotifier {
  final _db = Injector.instance<AppDB>();
  final _fireStore = FirebaseFirestore.instance;

  OpenAppAdManager? _openAppAd;
  AppLifecycleListener? _lifecycleListener;
  bool _wentToBackground = false;

  DashboardProvider() {
    _showCheckinDialogIfNeeded();
    NotificationHelper.initializeNotification();
    _saveToken();
    _initOpenAppAd();
  }

  Future<void> _initOpenAppAd() async {
    _openAppAd = OpenAppAdManager(
      adData: RemoteSettingsService.instance.applicationAppOpen,
      fullScreenContentCallback: FullScreenContentCallback(
        onAdDismissedFullScreenContent: (_) => _openAppAd?.reload(),
        onAdFailedToShowFullScreenContent: (_, _) => _openAppAd?.reload(),
      ),
    );
    await _openAppAd?.load();
    _startLifecycleListener();
  }

  void _startLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      // onHide fires only when the app is truly backgrounded (home button / app switcher).
      // onInactive (notification bar, ad overlays) does NOT trigger onHide, so those
      // resume events are naturally ignored via the _wentToBackground guard.
      onHide: () => _wentToBackground = true,
      onResume: () async {
        if (!_wentToBackground) return;
        _wentToBackground = false;

        // Another full-screen ad (rewarded/interstitial) was showing when the user
        // went home — skip this resume to avoid stacking ads.
        if (ignoreNextEvent) {
          ignoreNextEvent = false;
          return;
        }

        await _openAppAd?.show();
      },
    );
  }

  Future<void> _saveToken() async {
    (await FirebaseMessaging.instance.getToken()).logD;
    await _fireStore.collection('users').doc(_db.userModel?.userId).update({
      'token': await FirebaseMessaging.instance.getToken(),
    });
  }

  void _showCheckinDialogIfNeeded() {
    // Post-frame callback so the widget tree is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavKey.currentContext;
      if (ctx == null) return;
      if (isRewardClaimed) return;

      showDialog(
        context: ctx,
        builder: (_) => DailyLoginDialog(
          currentDay: currentCheckInDay,
          rewardCoins: dailyRewardCoins,
          onClaim: () {
            Navigator.of(ctx).pop(); // close dialog first
            claimReward(ctx);
          },
        ),
      );
    });
  }

  /// The day slot the user is currently on (1–7).
  /// Resets to 1 if they missed a day or completed the full 7-day cycle.
  int get currentCheckInDay {
    final user = _db.userModel;
    if (user == null || user.lastCheckInDate == null) return 1;

    final today = _dateOnly(DateTime.now());
    final last = _dateOnly(user.lastCheckInDate!);
    final diff = today.difference(last).inDays;

    if (diff == 0) return user.checkInStreak; // already claimed today
    if (diff == 1) return user.checkInStreak == 7 ? 1 : user.checkInStreak + 1; // next day
    return 1; // missed ≥ 1 day → reset
  }

  bool get isRewardClaimed {
    final lastDate = _db.userModel?.lastCheckInDate;
    if (lastDate == null) return false;
    return _dateOnly(DateTime.now()) == _dateOnly(lastDate);
  }

  int get dailyRewardCoins => currentCheckInDay * 10;

  int totalMissions = 10;
  List<DailyQuest> missions = const [
    DailyQuest(title: 'Take 5 quizzes', isCompleted: true),
    DailyQuest(title: 'Spin the wheel', isCompleted: true),
    DailyQuest(title: 'Play 10 mini games', isCompleted: true),
  ];

  int get completedMissions => missions.where((m) => m.isCompleted).length;

  List<EarnPrizeItem> get earnRewards => [
    EarnPrizeItem(
      title: 'Quiz',
      subtitle: '& Earn',
      reward: RemoteSettingsService.instance.quizPerQuestionReward * MathTriviaProvider.totalQuestions,
      icon: Assets.icons.quizChampion,
    ),
    EarnPrizeItem(
      title: 'Games',
      subtitle: 'Play Games',
      reward: RemoteSettingsService.instance.playGameRewardCoins,
      icon: Assets.icons.gameArena,
    ),
    EarnPrizeItem(
      title: 'Scratch',
      subtitle: '& Reveal',
      reward: RemoteSettingsService.instance.scrachMaxReward,
      icon: Assets.icons.scratchTicket,
    ),
    EarnPrizeItem(
      title: 'Spin',
      subtitle: 'Spin & Win',
      reward: RemoteSettingsService.instance.spinBoardRewardValues.reduce((a, b) => a > b ? a : b),
      icon: Assets.icons.rotatingWheel,
    ),
  ];

  List<TopEarnerItem> topEarningItems(BuildContext context) {
    final themeColors = context.themeColors;
    return [
      TopEarnerItem(
        title: 'Invite Friends',
        subtitle: 'Get ${RemoteSettingsService.instance.inviteFriendReward} Coins per Friend',
        reward: RemoteSettingsService.instance.inviteFriendReward,
        icon: Assets.icons.inviteEarn,
        color: themeColors.primaryGradient1,
        colors: [themeColors.primaryGradient2, themeColors.primary],
        onTap: () {
          final ctx = rootNavKey.currentContext!;
          RoutingHelper().navigateWithAdCheck(ctx, () => ctx.goNamed(AppRoutes.referEarn));
        },
      ),
      TopEarnerItem(
        title: 'Web Visits',
        subtitle: 'Visit to Earn ${RemoteSettingsService.instance.websiteRewardCoins} Coins',
        reward: RemoteSettingsService.instance.websiteRewardCoins,
        icon: Assets.icons.browseWeb,
        color: themeColors.secondaryGradient4,
        onTap: () {
          final ctx = rootNavKey.currentContext!;
          RoutingHelper().navigateWithAdCheck(ctx, () => ctx.pushNamed(AppRoutes.visitWebsite));
        },
        colors: [themeColors.primaryGradient2, themeColors.primaryGradient1],
      ),
    ];
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  bool _adWatched = false;
  bool get adWatched => _adWatched;

  Future<void> claimReward(BuildContext context) async {
    if (isRewardClaimed) return;

    final user = _db.userModel;
    if (user == null) return;

    final day = currentCheckInDay;
    final defaultCoins = day * 10;

    final earnedCoins = await RewardAdService.showDailyCheckin(context, defaultCoins: defaultCoins);
    if (earnedCoins == null) return;
    _adWatched = true;

    final updated = user.copyWith(coin: user.coin + earnedCoins, checkInStreak: day, lastCheckInDate: DateTime.now());

    _db.userModel = updated;

    await _fireStore.collection('users').doc(user.userId).update({
      'coin': updated.coin,
      'check_in_streak': updated.checkInStreak,
      'last_check_in_date': Timestamp.fromDate(updated.lastCheckInDate!),
    });

    notifyListeners();
  }

  void onWithdraw() {
    notifyListeners();
  }

  void onRewards() {
    notifyListeners();
  }

  void onLeaderboard() {}

  void onAchievement() {}

  void onHowItWorks() {}

  void onViewGuide() {}

  void onEarnRewardTap(EarnPrizeItem item) {}

  void onTopEarningTap(TopEarnerItem item) {}

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    _openAppAd?.dispose();
    super.dispose();
  }
}
