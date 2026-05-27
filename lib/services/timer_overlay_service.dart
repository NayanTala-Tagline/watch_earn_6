import 'package:flutter/services.dart';

/// Communicates with the native Android TimerOverlayService via MethodChannel.
/// The native overlay draws above the system UI (notification shade) so the
/// timer badge is always visible.
class TimerOverlayService {
  static const _channel = MethodChannel('com.daily.cash/timer_overlay');

  static Future<bool> hasPermission() async {
    try {
      return await _channel.invokeMethod<bool>('hasPermission') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestPermission');
    } catch (_) {}
  }

  static Future<bool> show({required int remaining, required int total}) async {
    try {
      return await _channel.invokeMethod<bool>(
            'showOverlay',
            {'remaining': remaining, 'total': total},
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> update({required int remaining, required int total}) async {
    try {
      await _channel.invokeMethod(
        'updateOverlay',
        {'remaining': remaining, 'total': total},
      );
    } catch (_) {}
  }

  static Future<void> hide() async {
    try {
      await _channel.invokeMethod('hideOverlay');
    } catch (_) {}
  }
}
