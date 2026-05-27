import 'dart:convert';

import 'package:ad_manager/models/ad_data.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'logger.dart';

class RemoteConfigService {
  static final RemoteConfigService _singleton = RemoteConfigService._internal();

  factory RemoteConfigService() => _singleton;

  static RemoteConfigService get instance => _singleton;

  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  Map<String, dynamic> _appConfig = {};
  Map<String, dynamic> _visitSites = {};

  RemoteConfigService._internal();

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    await _firebaseRemoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(minutes: 1)),
    );

    try {
      await _firebaseRemoteConfig.fetchAndActivate();
    } catch (e) {
      '⚠️ Remote config fetch failed: $e'.logD;
      return;
    }

    final appDataJson = _firebaseRemoteConfig.getString('app_data');
    final websitesJson = _firebaseRemoteConfig.getString('visit_websites_games');

    if (appDataJson.isEmpty) {
      '⚠️ app_data key is empty in Remote Config'.logD;
      return;
    }
    if (websitesJson.isEmpty) {
      '⚠️ visit_websites key is empty in Remote Config'.logD;
      return;
    }

    try {
      _appConfig = jsonDecode(appDataJson) as Map<String, dynamic>;
      _visitSites = jsonDecode(websitesJson) as Map<String, dynamic>;
      '✅ Remote config loaded successfully'.logD;
    } catch (e) {
      _appConfig = {};
      _visitSites = {};
      '❌ Failed to decode remote config JSON: $e'.logD;
    }
  }

  // ---------------------------------------------------------------------------
  // INTERNAL HELPERS
  // ---------------------------------------------------------------------------

  AdData _getAdData(String key) {
    try {
      final rawEntry = _appConfig[key];

      if (rawEntry == null || rawEntry is! Map<String, dynamic>) {
        '⚠️ $key missing or invalid'.logD;
        return AdData.fromJson(_emptyAd());
      }

      final Map<String, dynamic> normalized = {
        'ad_id': rawEntry['ad_id'] ?? '',
        'enabled': rawEntry['enabled'] ?? false,
        'template_type': rawEntry['template_type'] ?? 'small',
        'is_custom_ad': rawEntry['is_custom_ad'] ?? false,

        // 🔥 INT → DOUBLE FIX
        'custom_ad_height': (rawEntry['custom_ad_height'] is num) ? (rawEntry['custom_ad_height'] as num).toDouble() : 0.0,

        'custom_ad_view_url': rawEntry['custom_ad_view_url'] ?? '',
        'custom_ad_url': rawEntry['custom_ad_url'] ?? '',
      };

      return AdData.fromJson(normalized);
    } catch (e, stackTrace) {
      '❌ Failed to parse AdData for $key: $e'.logD;
      stackTrace.toString().logD;
      return AdData.fromJson(_emptyAd());
    }
  }

  Map<String, dynamic> _emptyAd() => {
    'ad_id': '',
    'enabled': false,
    'template_type': 'small',
    'is_custom_ad': false,
    'custom_ad_height': 0.0,
    'custom_ad_view_url': '',
    'custom_ad_url': '',
  };

  dynamic _get(String key, [dynamic defaultValue]) {
    return _appConfig[key] ?? defaultValue;
  }

  dynamic _getWebsites(String key, [dynamic defaultValue]) {
    return _visitSites[key] ?? defaultValue;
  }

  // ---------------------------------------------------------------------------
  // ADS
  // ---------------------------------------------------------------------------

  AdData get applicationAppOpen => _getAdData('application_app_open');

  AdData get languageNative => _getAdData('language_native');

  AdData get onboardingNative1 => _getAdData('onboarding_native_1');

  AdData get onboardingNative2 => _getAdData('onboarding_native_2');

  AdData get onboardingNative3 => _getAdData('onboarding_native_3');

  AdData get onboardingInter1 => _getAdData('onboarding_inter_1');

  AdData get onboardingInter2 => _getAdData('onboarding_inter_2');

  AdData get onboardingInter3 => _getAdData('onboarding_inter_3');

  AdData get appNative => _getAdData('app_native');

  AdData get appInter => _getAdData('app_inter');

  AdData get homeNative => _getAdData('home_native');

  AdData get settingNative => _getAdData('setting_native');

  AdData get websiteReward => _getAdData('website_reward');

  AdData get dailyClaimReward => _getAdData('daily_claim_reward');

  AdData get mathQuizClaimReward => _getAdData('math_quiz_claim_reward');

  AdData get scratchCardClaimReward => _getAdData('scratch_card_claim_reward');

  AdData get spinWheelClaimReward => _getAdData('spin_wheel_claim_reward');

  int get appClickCounter => _get('app_click_counter', 15);

  String get privacyPolicyUrl => _get('privacy_policy_url', '');

  String get termsAndConditions => _get('terms_and_conditions', '');

  // ---------------------------------------------------------------------------
  // OTHER CONFIG
  // ---------------------------------------------------------------------------
  String get techNewsUrl => _getWebsites('tech_news_daily');
  String get viralGadgetUrl => _getWebsites('viral_gadgets');
  String get lifestyleBlogUrl => _getWebsites('lifestyle_blog');
  String get travelDailiesUrl => _getWebsites('travel_dailies');
  String get financeTipsUrl => _getWebsites('finance_tips');
  int get websiteLockMinutes => _getWebsites('website_lock_minutes');
  int get websiteVisitTimer => _getWebsites('website_visit_timer_in_second');
  int get websiteRewardCoins => _getWebsites('website_reward_coins', 50);

  bool get showInCustomWebview => _getWebsites('show_in_custom_webview');
  int get minWithdrawAmount => _getWebsites('min_withdraw_amount', 1000);
  int get coinToDollarDivider => _getWebsites('coin_to_dollar_divider', 1000);
  int get quizPerQuestionReward => _getWebsites('quiz_per_question_reward', 5);
  int get scrachMinReward => _getWebsites('scrach_min_reward', 20);
  int get scrachMaxReward => _getWebsites('scrach_max_reward', 30);
  int get inviteFriendReward => _getWebsites('invite_friend_reward', 1000);
  List<int> get spinBoardRewardValues =>
      List<int>.from(_getWebsites('spin_board_reward_values', [20, 22, 24, 26, 27, 29]));

  /// games

  String get bubbleShooter1 => _getWebsites('bubble_shooter_1');
  String get bubbleShooter2 => _getWebsites('bubble_shooter_2');
  String get bubbleShooter3 => _getWebsites('bubble_shooter_3');
  String get bubbleShooter4 => _getWebsites('bubble_shooter_4');
  String get bubbleShooter5 => _getWebsites('bubble_shooter_5');

  int get playGameVisitTimer => _getWebsites('play_game_visit_timer_in_second');
  int get playGameLockMinutes => _getWebsites('play_game_lock_minutes');
  int get playGameRewardCoins => _getWebsites('play_game_reward_coins', 50);
  bool get showGameInCustomWebview => _getWebsites('show_game_in_custom_webview');
  AdData get playGameReward => _getAdData('play_game_reward');
}
