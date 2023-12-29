import 'dart:convert';

import 'package:flutter/foundation.dart';

void dLogJson(Map object) {
  if (kDebugMode) {
    var encoder = const JsonEncoder.withIndent('  ');
    var prettyString = encoder.convert(object);
    dLog(prettyString);
  }
}

void dLog(Object object) {
  if (kDebugMode) {
    print(object);
  }
}