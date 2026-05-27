import 'package:ad_manager/ad_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/intro_module/intro_screen/model/intro_data.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:flutter/cupertino.dart';

/// Onboarding provider with data from Figma design
/// Data extracted from figma_ui.json
class IntroProvider extends ChangeNotifier {
  IntroProvider({required int onboardingIndex}) {
    switch (onboardingIndex) {
      case 1:
        loadOnboarding1Ads();
      case 2:
        loadOnboarding2Ads();
      case 3:
        loadOnboarding3Ads();
    }
  }
  List<IntroData> onboardingList = [
    // Page 1 - Node ID: 3:3
    IntroData(
      image: Assets.images.intro1.image(height: AppDimens.h240),
      title: rootNavKey.currentContext!.l10n.onboardingOneTitle,
      description: rootNavKey.currentContext!.l10n.onboardingOneDesc,
      buttonText: rootNavKey.currentContext!.l10n.next,
    ),
    // Page 2 - Node ID: 3:76
    IntroData(
      image: Assets.images.intro2.image(height: AppDimens.h240),
      title: rootNavKey.currentContext!.l10n.onboardingTwoTitle,
      description: rootNavKey.currentContext!.l10n.onboardingTwoDesc,
      buttonText: rootNavKey.currentContext!.l10n.next,
    ),
    // Page 3 - Node ID: 3:127
    IntroData(
      image: Assets.images.intro3.image(height: AppDimens.h240),
      title: rootNavKey.currentContext!.l10n.onboardingThreeTitle,
      description: rootNavKey.currentContext!.l10n.onboardingThreeDesc,
      buttonText: rootNavKey.currentContext!.l10n.getStarted,
    ),
  ];

  bool isLoading = false;

  NativeAdManager? nativeAd1;
  NativeAdManager? nativeAd2;
  NativeAdManager? nativeAd3;

  InterstitialAdManager? interAd1;
  InterstitialAdManager? interAd2;
  InterstitialAdManager? interAd3;

  Future<void> loadOnboarding1Ads() async {
    nativeAd1 = NativeAdManager(adData: RemoteSettingsService.instance.onboardingNative1);
    interAd1 = InterstitialAdManager(adData: RemoteSettingsService.instance.onboardingInter1);
    await Future.wait([nativeAd1!.load(), interAd1!.load()]);
    await Future.wait([nativeAd1!.future(), interAd1!.future()]);
    notifyListeners();
  }

  Future<void> loadOnboarding2Ads() async {
    nativeAd2 = NativeAdManager(adData: RemoteSettingsService.instance.onboardingNative2);
    interAd2 = InterstitialAdManager(adData: RemoteSettingsService.instance.onboardingInter2);
    await Future.wait([nativeAd2!.load(), interAd2!.load()]);
    await Future.wait([nativeAd2!.future(), interAd2!.future()]);
    notifyListeners();
  }

  Future<void> loadOnboarding3Ads() async {
    nativeAd3 = NativeAdManager(adData: RemoteSettingsService.instance.onboardingNative3);
    interAd3 = InterstitialAdManager(adData: RemoteSettingsService.instance.onboardingInter3);
    await Future.wait([nativeAd3!.load(), interAd3!.load()]);
    await Future.wait([nativeAd3!.future(), interAd3!.future()]);
    notifyListeners();
  }

  Future<void> wait(NativeAdManager nativeAd, InterstitialAdManager interAd) async {
    isLoading = true;
    notifyListeners();
    await Future.wait([nativeAd.future(), interAd.future()]);
    isLoading = false;
    notifyListeners();
  }
}
