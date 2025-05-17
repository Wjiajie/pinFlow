import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // For kReleaseMode

/// 应用的日志服务类。
///
/// 提供不同级别的日志记录方法。
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,       // 每个日志输出的方法调用堆栈数量
      errorMethodCount: 8,  // 错误日志的方法调用堆栈数量
      lineLength: 100,      // 每行日志的宽度
      colors: true,         // 是否使用颜色
      printEmojis: true,     // 是否打印 Emoji
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,      // 是否打印时间戳
    ),
    // 设置全局日志级别。在开发模式下可以设置为 trace，在发布模式下设置为 warning。
    // 可以在 main.dart 中根据 kReleaseMode 进行设置。
    level: kReleaseMode ? Level.warning : Level.trace,
  );

  /// 记录 trace 级别的日志。
  static void trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// 记录 Debug 级别的日志。
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// 记录 Info 级别的日志。
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// 记录 Warning 级别的日志。
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// 记录 Error 级别的日志。
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// 记录 "What a Terrible Failure" (Fatal) 级别的日志。
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}