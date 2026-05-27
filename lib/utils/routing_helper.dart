import 'dart:async';

import 'package:ad_manager/ad_manager.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:daily_cash/widgets/loading_shade/loading_shade.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../routes/app_router.dart';
import 'logger_ex.dart';

/// Navigation gate that shows a full-screen ad every N taps.
///
/// Routing is delegated to [FullScreenAdManager] so Firebase Remote Config
/// can flip the `app_inter` slot between `interstatial`, `openApp`, and
/// `custom` (a browser URL redirect) without code changes.
class RoutingHelper {
  static final RoutingHelper _singleton = RoutingHelper._internal();
  factory RoutingHelper() => _singleton;
  RoutingHelper._internal();

  int _pressCount = 0;

  /// Read fresh on every tap so Remote Config updates take effect without
  /// rebuilding the singleton.
  int get _tapThreshold => RemoteSettingsService.instance.appClickCounter;

  FullScreenAdManager? _fullScreenAdManager;

  /// True when the slot is configured to show any kind of ad.

  // ---------------------------------------------------------------------------
  // PUBLIC ENTRY POINTS
  // ---------------------------------------------------------------------------
  void handleBackPress(BuildContext context) {
    navigateWithAdCheck(context, () {
      context.pop();
    });
  }

  void addBackTap(BuildContext context) {
    navigateWithAdCheck(context, () {});
  }

  /// Main entry — increments the tap counter and shows an ad once the
  /// threshold is reached, otherwise navigates immediately.
  void navigateWithAdCheck(BuildContext context, VoidCallback onNavigate) {
    '/// taped...$_pressCount'.logV;

    // Slot is disabled → straight navigation.
    if (_fullScreenAdManager?.adData.enabled == false) {
      onNavigate();
      return;
    }

    _pressCount++;
    '/// tapCount: $_pressCount / $_tapThreshold'.logD;

    if (_pressCount >= _tapThreshold) {
      '/// go to load'.logD;
      _pressCount = 0;
      _handleAdSequence(context, onNavigate);
    } else {
      onNavigate();
    }
  }

  // ---------------------------------------------------------------------------
  // AD SEQUENCE
  // ---------------------------------------------------------------------------
  Future<void> _handleAdSequence(
      BuildContext context,
      VoidCallback onNavigate,
      ) async {
    final overlayCtx =
    context.mounted ? context : rootNavKey.currentContext;
    if (overlayCtx == null) {
      onNavigate();
      return;
    }

    final adData = RemoteSettingsService.instance.appInter;
    bool overlayVisible = false;

    try {
      // Custom creative → launch URL in an in-app browser, wait briefly, then
      // run the app-level navigation behind it.
      if (adData.adType == AdType.custom) {
        ignoreNextEvent = true;
        '/// launchURL'.logD;
        unawaited(
          launchUrlString(
            adData.customAdUrl,
            mode: LaunchMode.inAppBrowserView,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 800));
        return;
      }

      // Real full-screen ad — FullScreenAdManager picks interstitial/openApp
      // based on adType. Callbacks are wired for both.
      if (adData.enabled) {
        ignoreNextEvent = true;
        LoadingShade.instance().show(context: context);
        overlayVisible = true;

        _fullScreenAdManager?.dispose();
        _fullScreenAdManager = FullScreenAdManager(
          adData: adData,
          interstitialCallback: FullScreenContentCallback<InterstitialAd>(
            onAdShowedFullScreenContent: (_) => 'Ad Shown'.logI,
            onAdDismissedFullScreenContent: (_) => 'Ad Dismissed'.logI,
            onAdFailedToShowFullScreenContent: (_, _) => 'Ad Failed Show'.logI,
          ),
          openAppCallback: FullScreenContentCallback<AppOpenAd>(
            onAdShowedFullScreenContent: (_) => 'Ad Shown'.logI,
            onAdDismissedFullScreenContent: (_) => 'Ad Dismissed'.logI,
            onAdFailedToShowFullScreenContent: (_, _) => 'Ad Failed Show'.logI,
          ),
        );

        // 6s budget for the loader-visible phase — if the ad doesn't
        // load/ready in time, drop the loader and continue navigation
        // instead of trapping the user.
        try {
          await _fullScreenAdManager!.load().timeout(const Duration(seconds: 6));
          await _fullScreenAdManager!.future().timeout(const Duration(seconds: 6));
        } on TimeoutException {
          '/// ad load timeout'.logW;
        }
        // Loader's job is done once the ad is ready (or timed out).
        if (overlayVisible) {
          LoadingShade.instance().hide();
          overlayVisible = false;
        }
        if (_fullScreenAdManager!.isLoaded) {
          await _fullScreenAdManager!.show();
        }
      }
    } catch (e) {
      debugPrint('Ad Logic Exception: $e');
    } finally {
      if (overlayVisible) LoadingShade.instance().hide();

      // Runs after ad dismiss / URL launch.
      onNavigate();
    }
  }

  /// Call this to reset counter if needed.
  void resetCounter() {
    _pressCount = 0;
  }
}
