import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  Log._();

  static late Logger _log;

  static void init() {
    if (!kDebugMode) Logger.level = Level.warning;
    _log = Logger(printer: SimplePrinter());
  }

  /// Log a message at debug Level
  static void d(dynamic log) {
    _log.d(log);
    if (log == null) return;
  }

  /// Log a message at level [Level.info].
  static void i(dynamic log) {
    _log.i(log);
  }

  /// Log a warning message.
  static void w(dynamic log) {
    _log.w(log);
    if (log == null) return;
  }

  /// Log error
  static void e(dynamic log) {
    _log.e(log);
    if (log == null) return;
  }

  /// Verbose log
  static void v(dynamic log) {
    _log.v(log);
  }
}
