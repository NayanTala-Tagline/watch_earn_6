import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../shared/models/user_model.dart';
import '../utils/logger_ex.dart';

/// to store local data
class AppDB {
  AppDB._(this._box);

  static const _appDbBox = '_appDbBox';
  final Box<dynamic> _box;

  /// to get instance
  static Future<AppDB> getInstance() async {
    try {
      final box = await Hive.openBox<dynamic>(_appDbBox);
      return AppDB._(box);
    } catch (e) {
      final appDir = await getApplicationDocumentsDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
      final box = await Hive.openBox<dynamic>(_appDbBox);
      return AppDB._(box);
    }
  }

  /// save value
  T getValue<T>(String key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;

  /// save value
  Future<void> setValue<T>(String key, T value) => _box.put(key, value);

  /// Removes user session data on logout.
  /// Preserves device-level keys like visit-website locks and leaderboard timer
  /// so they persist across logout/login cycles.
  Future<void> logoutUser() async {
    try {
      // Keys to preserve across logout
      const preserved = {'leaderboardTimerExpiry', 'internetStatus'};
      final keysToDelete = _box.keys.where((k) {
        final key = k.toString();
        if (preserved.contains(key)) return false;
        if (key.startsWith('vw_lock_')) return false;
        return true;
      }).toList();
      await _box.deleteAll(keysToDelete);
    } catch (e) {
      e.logFatal;
    }
  }

  /// to set internet status
  set internetStatus(String status) => setValue('internetStatus', status);

  /// to get internet status
  String get internetStatus => getValue('internetStatus', defaultValue: 'connected');

  /// to check internet connection status is connected or not
  bool get isInternetConnected {
    return internetStatus == 'connected';
  }

  /// notifies user on value change
  Stream<BoxEvent> userListenable() {
    return _box.watch(key: 'userModel').asBroadcastStream();
  }

  UserModel? get userModel {
    final raw = getValue<Map<dynamic, dynamic>?>('userModel');
    if (raw == null) return null;
    return UserModel.fromLocalMap(Map<String, dynamic>.from(raw));
  }

  set userModel(UserModel? value) => setValue('userModel', value?.toLocalMap());

  // ── Leaderboard timer ────────────────────────────────────────────────

  /// Stores the Unix-ms timestamp when the leaderboard timer expires.
  int? get leaderboardTimerExpiry => getValue<int?>('leaderboardTimerExpiry');

  set leaderboardTimerExpiry(int? value) => setValue('leaderboardTimerExpiry', value);

  String? get selectedLangauge => getValue<String?>('selectedLangauge');

  set selectedLangauge(String? value) => setValue('selectedLangauge', value);

  String? get lastOpendDate => getValue<String?>('lastOpendDate');

  set lastOpendDate(String? value) => setValue('lastOpendDate', value);

  Future<void> handleAppOpen() async {
    final now = DateTime.now();

    final storedDate = lastOpendDate;

    if (storedDate != null) {
      final lastOpened = DateTime.parse(storedDate);

      bool isSameDay = now.year == lastOpened.year && now.month == lastOpened.month && now.day == lastOpened.day;

      if (isSameDay && now.hour < 7) {
        await FlutterLocalNotificationsPlugin().cancel(id: 0);
      }
    }

    // Update today's open
    lastOpendDate = now.toIso8601String();
  }

  Future<void> clearData() async {
    await _box.clear();
  }
}
