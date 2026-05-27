/*
import 'package:btc_cloud_mining/utils/ad_click_manager.dart';
import 'package:btc_cloud_mining/utils/app_dimens.dart';
import 'package:btc_cloud_mining/utils/interstitial_ad_manager.dart';
import 'package:btc_cloud_mining/utils/logger_ex.dart';
import 'package:flutter/material.dart';

class AppAdLoadingView extends StatefulWidget {
  const AppAdLoadingView({super.key});

  @override
  State<AppAdLoadingView> createState() => _AppAdLoadingViewState();
}

class _AppAdLoadingViewState extends State<AppAdLoadingView> {
  InterstitialAdManager? adManager;

  @override
  void initState() {
    super.initState();

    adManager = AdClickManager().interstitialAdManager;

    if (adManager == null) {
      safePop(context);
      return;
    }

    // Attach UI callbacks dynamically
    adManager!.onAdReadyForUI = () {
      '✅ Ad ready callback received, showing ad.'.logD;
      if (mounted) adManager!.showAdIfAvailable();
    };
    adManager!.onAdFailedForUI = () {
      '/// tapCount failed'.logD;
      safePop(context);
      AdClickManager().adjustTapCountAfterAd(true);
    };

    // If ad is already loaded when screen opens, show it instantly
    if (adManager!.isLoaded) {
      adManager!.showAdIfAvailable();
    }
  }

  @override
  void dispose() {
    // Clean up callbacks to avoid memory leaks
    adManager?.onAdReadyForUI = null;
    adManager?.onAdFailedForUI = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: AppDimens.h16),
            const Text('Loading Ad...'),
          ],
        ),
      ),
    );
  }
}

void safePop(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  });
}

void safePush(BuildContext context, Widget page) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page),
      );
    }
  });
}*/
