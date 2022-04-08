import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';
import "package:stack_trace/stack_trace.dart";
import 'package:sumgo_crawller_flutter/MySetting.dart';

class LogUtil {
  static const bool _showLogLevel = false;
  static const bool _showAppName = false;
  static const bool _showMethodName = true;
  static final _filter = DevelopmentFilter();
  static final Logger _logger = Logger(
    filter: _filter,
    level: MySetting.isRelease?Level.warning:Level.debug,
    printer: PrettyPrinter(printTime: true, colors: true, methodCount: 10),
    output: LogConsole.wrap(innerOutput: ConsoleOutput()),
    // printer: new PrettyPrinter(
    //     methodCount: 0,
    //     // // number of method calls to be displayed
    //     // errorMethodCount: 8,
    //     // // number of method calls if stacktrace is provided
    //     // lineLength: 600,
    //     // // width of the output
    //     colors: true,
    //     // // Colorful log messages
    //     // printEmojis: true,
    //     // // Print an emoji for each log message
    //     // printTime: true // Should each log print contain a timestamp
    //     ),
  );

  static void setDebugLevel() {
    _filter.level = Level.debug;
  }

  static void info(String msg) {
    _logger.i(makeLogString(msg));
  }

  static void debug(String msg) {
    _logger.d(makeLogString(msg));
  }

  static void warn(String msg) {
    _logger.w(makeLogString(msg));
  }

  static void error(String msg) {
    _logger.e(makeLogString(msg));
  }

  static String makeLogString(String msg) {
    String logStr = "";

    if (_showLogLevel) {
      String? logLevel = Trace?.current().frames[1].member;
      logLevel = logLevel != null ? logLevel.split(".")[1] : null;
      logStr += "[$logLevel] ";
    }

    if (_showAppName) {
      logStr += "[${MySetting.appName}_APP] ";
    }

    if (_showMethodName) {
      String? methodName = Trace?.current().frames[2].member;
      logStr += "[$methodName] ";
    }

    logStr += msg;
    return logStr;
  }
}
