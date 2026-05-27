import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterErrorDetails, immutable, kReleaseMode;

/// Crashlytics Manager to manage FirebaseCrashlytics SDK
@immutable
final class CrashlyticsManager {
  // ---- Singleton setup ----
  static final CrashlyticsManager _singleton = CrashlyticsManager._internal();

  /// Factory constructor allows calling `CrashlyticsManager()` directly
  factory CrashlyticsManager() => _singleton;

  /// Named instance getter for clarity if preferred
  static CrashlyticsManager get instance => _singleton;

  /// Private constructor
  CrashlyticsManager._internal();

  // ---- FirebaseCrashlytics setup ----
  final FirebaseCrashlytics _firebaseCrashlytics = FirebaseCrashlytics.instance;

  /// Get FirebaseCrashlytics instance
  FirebaseCrashlytics get crashlytics => _firebaseCrashlytics;

  /// Set user id
  void setUserId(String userId) {
    if (kReleaseMode) {
      _firebaseCrashlytics.setUserIdentifier(userId);
    }
  }

  /// Log FlutterErrorDetails
  void logFlutterError(FlutterErrorDetails details) {
    if (kReleaseMode) {
      _firebaseCrashlytics.recordFlutterError(details);
    }
  }

  /// Log handled Dart error
  void logHandledDartError({required Object error, StackTrace? stackTrace, String? message}) {
    if (kReleaseMode) {
      if (message != null) logCustomError(message);
      _firebaseCrashlytics.recordError(error, stackTrace ?? StackTrace.current);
    }
  }

  /// Log custom error message
  void logCustomError(String message) {
    if (kReleaseMode) {
      _firebaseCrashlytics.log(message);
    }
  }
}
