import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show immutable, kReleaseMode;

/// Analytics Manager to manage FirebaseAnalytics SDK
@immutable
final class AnalyticsManager {
  // ---- Singleton setup ----
  static final AnalyticsManager _singleton = AnalyticsManager._internal();

  /// Factory constructor for direct access: `AnalyticsManager()`
  factory AnalyticsManager() => _singleton;

  /// Named getter for explicit singleton access: `AnalyticsManager.instance`
  static AnalyticsManager get instance => _singleton;

  /// Private internal constructor
  AnalyticsManager._internal();

  // ---- FirebaseAnalytics instance ----
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  /// Get FirebaseAnalytics instance
  FirebaseAnalytics get analytics => _firebaseAnalytics;

  /// Set user ID for analytics tracking
  Future<void> setUserId(String userId) async {
    // if (kReleaseMode) {
      await _firebaseAnalytics.setUserId(id: userId);
    // }
  }

  /// Set user property (e.g., user type, plan, region)
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    // if (kReleaseMode) {
      await _firebaseAnalytics.setUserProperty(name: name, value: value);
    // }
  }

  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (kReleaseMode) {
      await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    }
  }

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    // if (kReleaseMode) {
      await _firebaseAnalytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    // }
  }

  /// Enable or disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Reset analytics data (e.g., for user logout)
  Future<void> resetAnalyticsData() async {
    await _firebaseAnalytics.resetAnalyticsData();
  }
}
