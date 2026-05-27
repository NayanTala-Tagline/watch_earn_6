// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs

import 'package:logger/logger.dart';

final _appLogger = Logger(filter: _LogSieve());
bool isLogEnable = true;

/// logger extension
extension LoggerEx on Object? {
  /// to print message with debug level
  void get logD => isLogEnable ? _appLogger.d(this) : null;

  /// to print message with info level
  void get logI => isLogEnable ? _appLogger.i(this) : null;

  /// to print message with verbose level
  void get logV => isLogEnable ? _appLogger.w(this) : null;

  /// to print message with error level
  void get logE => isLogEnable ? _appLogger.e(this) : null;

  /// to print message with warning level
  void get logW => isLogEnable ? _appLogger.w(this) : null;

  /// to print message with timestamp
  void get logTime => isLogEnable
      ? _appLogger.d('${DateTime.now().toUtc().toIso8601String()} $this')
      : null;

  /// to print message with wtf level
  void get logFatal => isLogEnable ? _appLogger.w(this) : null;
}

class _LogSieve extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return switch (event.level) {
      Level.debug ||
      Level.info ||
      Level.trace ||
      Level.warning ||
      Level.error =>
        true,
      Level.fatal => true,
      _ => true,
    };
  }
}
