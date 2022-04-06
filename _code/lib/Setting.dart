
import 'dart:ui';

import 'package:logger/logger.dart';

class Setting {
  //Lang
  static const Locale defaultLocale = Locale('ko','kr');

  // DateTime
  static const int timeZoneOffset = 9;

  // App
  static const String appName = "TRY_IT";

  // Log
  static const Level LogLevel = Level.info;
  static bool showLog = true;

  // 중복 클릭 방지 시간
  static int milliSecondsForPreventingMultipleClicks = 300;

  static bool isRelease = false ; // kReleaseMode;

// static String appVersion = "";
//
// static String appBuildNumber = "";
}
