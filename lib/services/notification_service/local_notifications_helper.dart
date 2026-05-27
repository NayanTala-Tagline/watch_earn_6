import 'dart:convert';

import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/services/notification_service/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Local notification helper class
class LocalNotificationHelper {
  LocalNotificationHelper._();

  /// instance of LocalNotificationHelper
  static final instance = LocalNotificationHelper._();

  /// FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// android channel
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel',
    'Default Channel',
    importance: Importance.high,
  );

  /// android initialization
  static const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  /// ios initialization
  static const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

  /// Android Notification Details
  static AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    visibility: NotificationVisibility.public,
    importance: Importance.high,
    enableLights: true,
  );

  /// iOS Notification Details
  static DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(presentSound: true);

  /// initialize
  Future<void> initialize() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await flutterLocalNotificationsPlugin.initialize(
      onDidReceiveNotificationResponse: (details) {
        NotificationHelper.notificationOnTapHandler(localData: details, isLocal: true);
      },
      settings: const InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// show Notification
  Future<void> showNotification(RemoteMessage remoteMessage) async {
    await flutterLocalNotificationsPlugin.show(
      id: remoteMessage.notification.hashCode,
      title: remoteMessage.notification?.title,
      body: remoteMessage.notification?.body,
      notificationDetails: NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails),
      payload: remoteMessage.data.isNotEmpty ? jsonEncode(remoteMessage.data) : null,
    );
  }

  Future<void> scheduleDailySameTimeNotification() async {
    final String? lastVisitString = Injector.instance<AppDB>().lastOpendDate;

    if (lastVisitString == null) return;

    final DateTime lastVisit = DateTime.parse(lastVisitString);
    final currentTime = tz.TZDateTime.now(tz.local);

    final int targetHour = lastVisit.hour;
    final int targetMinute = lastVisit.minute;

    // 📅 Today’s scheduled time
    final todaySchedule = tz.TZDateTime(tz.local, currentTime.year, currentTime.month, currentTime.day, targetHour, targetMinute);

    // 📅 First trigger (today or tomorrow)
    final firstSchedule = todaySchedule.isAfter(currentTime) ? todaySchedule : todaySchedule.add(const Duration(days: 1));

    // 🔄 Schedule repeating daily
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Daily Rewards are here...!',
      body: 'Come back and collect rewards!',
      scheduledDate: firstSchedule,
      notificationDetails: NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // 🔥 repeats daily
    );

    // 🚫 If user opened BEFORE today's scheduled time → cancel today's trigger only
    if (todaySchedule.isAfter(currentTime)) {
      // Cancel and reschedule starting tomorrow
      await flutterLocalNotificationsPlugin.cancel(id: 0);

      final tomorrow = todaySchedule.add(const Duration(days: 1));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: 0,
        title: 'Daily Rewards are here...!',
        body: 'Come back and collect rewards!',
        scheduledDate: tomorrow,
        notificationDetails: NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // 🔥 repeats daily
      );
    }
  }
}
