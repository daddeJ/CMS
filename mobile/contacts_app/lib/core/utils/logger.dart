import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      colors: true,
      printEmojis: true,
    ),
  );

  // Corrected methods with proper parameter handling
  void debug(String message) => _logger.d(message);

  void info(String message) => _logger.i(message);

  void warning(String message) => _logger.w(message);

  void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null && stackTrace != null) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    } else if (error != null) {
      _logger.e(message, error: error);
    } else {
      _logger.e(message);
    }
  }
}