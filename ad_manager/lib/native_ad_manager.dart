import 'dart:async';
import 'dart:io' show Platform;

import 'package:ad_manager/enum/ad_type.dart';
import 'package:ad_manager/models/ad_data.dart';
import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:ad_manager/utils/revenue_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'enum/ad_status.dart';

class NativeAdManager {
  final AdData adData;
  final String? factoryId;

  NativeAd? _ad;
  NativeAd? get ad => _ad;

  AdStatus adStatus = AdStatus.idle;

  bool get isLoaded => adStatus == AdStatus.loaded;
  bool get isLoading => adStatus == AdStatus.loading;
  bool get isFailed => adStatus == AdStatus.failed;

  Completer<AdStatus> _completer = Completer<AdStatus>();

  /// Optional external callbacks
  final NativeAdListener? listener;

  NativeAdManager({required this.adData, this.factoryId, this.listener});

  // -----------------------------
  // LOAD AD
  // -----------------------------
  Future<void> load() async {
    if (!adData.enabled) {
      adStatus = AdStatus.disabled;
      _completer.complete(AdStatus.disabled);
      return;
    }

    if (adData.adType == AdType.custom) {
      adStatus = AdStatus.loaded;
      _completer.complete(AdStatus.loaded);
      return;
    }

    if (isLoaded || isLoading) return;

    adStatus = AdStatus.loading;

    if (_ad != null) {
      _ad!.dispose();
      _ad = null;
    }

    // On Android we route to our custom Kotlin NativeAdFactory (registered in
    // MainActivity for "small" / "medium"). The plugin only invokes the
    // factory when `nativeTemplateStyle` is null, so we drop the built-in
    // template on Android. iOS has no custom factory registered yet, so it
    // continues to use the SDK's built-in template renderer.
    _ad = NativeAd(
      adUnitId: adData.adId,
      factoryId: factoryId ?? adData.templateType.name,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(templateType: adData.templateType),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          adStatus = AdStatus.loaded;

          listener?.onAdLoaded?.call(ad);

          if (!_completer.isCompleted) {
            _completer.complete(AdStatus.loaded);
          }
        },
        onAdFailedToLoad: (ad, error) {
          adStatus = AdStatus.failed;

          listener?.onAdFailedToLoad?.call(ad, error);

          AnalyticsManager.instance.logEvent(name: 'native_fail_to_load', parameters: {"message": error.message});

          if (!_completer.isCompleted) {
            _completer.complete(AdStatus.failed);
          }
        },
        onAdOpened: (ad) {
          listener?.onAdOpened?.call(ad);
          AnalyticsManager.instance.logEvent(name: 'native_ad_opened');
        },
        onAdClosed: (ad) {
          listener?.onAdClosed?.call(ad);
          AnalyticsManager.instance.logEvent(name: 'native_ad_closed');
        },
        onAdImpression: (ad) {
          listener?.onAdImpression?.call(ad);
          AnalyticsManager.instance.logEvent(name: 'native_ad_impression');
        },
        onAdClicked: (ad) {
          listener?.onAdClicked?.call(ad);
          AnalyticsManager.instance.logEvent(name: 'native_ad_click');
        },
        onPaidEvent: (ad, micros, precision, currency) {
          listener?.onPaidEvent?.call(ad, micros, precision, currency);

          RevenueHelper.sendAdImpressionRevenueToFirebase(
            valueMicros: micros,
            currencyCode: currency,
            precision: precision,
            adUnitId: adData.adId,
          );
        },
      ),
    );

    try {
      await _ad!.load();
    } catch (e) {
      adStatus = AdStatus.failed;
      if (!_completer.isCompleted) _completer.complete(AdStatus.failed);
      debugPrint("NativeAd load error: $e");
    }
  }

  // -----------------------------
  // RELOAD
  // -----------------------------
  Future<void> reload() async {
    if (!adData.enabled) {
      adStatus = AdStatus.disabled;
      return;
    }

    _ad?.dispose();
    _ad = null;
    _completer = Completer<AdStatus>();
    adStatus = AdStatus.idle;

    await load();
  }

  // -----------------------------
  // FUTURE (resolves on load or fail)
  // -----------------------------
  Future<AdStatus> future() => _completer.future;

  // -----------------------------
  // AD WIDGET
  // -----------------------------
  Widget adWidget() {
    if (adData.adType == AdType.custom) {
      return SizedBox(
        height: adData.height > 0 ? adData.height : null,
        child: GestureDetector(
          onTap: () {
            launchUrlString(adData.customAdUrl);
          },
          behavior: HitTestBehavior.opaque,
          child: Image.network(
            width: double.maxFinite,
            height: adData.height > 0 ? adData.height : null,
            adData.customAdViewUrl,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: SizedBox(width: double.infinity, height: adData.height > 0 ? adData.height : null),
              );
            },
          ),
        ),
      );
    }

    if (!isLoaded || _ad == null) {
      return const SizedBox.shrink();
    }

    // AdWidget hosts a platform view. When `nativeTemplateStyle` is set,
    // the plugin pins the platform-view height to the template size, so a
    // null `height` is fine. With our custom Android factory the platform
    // view's wrap_content doesn't always propagate to Flutter, leaving the
    // SizedBox unbounded and the ad invisible. Fall back to tight, content-
    // accurate defaults so the slot doesn't reserve empty space below.
    final fallbackHeight =
        adData.templateType == TemplateType.medium ? 300.0 : 100.0;
    final renderHeight = adData.height > 0 ? adData.height : fallbackHeight;

    return SizedBox(
      height: renderHeight,
      child: AdWidget(ad: _ad!),
    );
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _ad?.dispose();
    _ad = null;
    adStatus = AdStatus.idle;
  }
}
