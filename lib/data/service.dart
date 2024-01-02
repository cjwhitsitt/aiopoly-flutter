import 'dart:io';

import 'package:aiopoly/utils/constants.dart';
import 'package:aiopoly/data/create_response.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class Service {
  static void useEmulators() {
    if (kDebugMode) {
      String host = Platform.isAndroid ? "10.0.2.2" : "localhost";
      print('Running in debug. Host connecting to emulator at $host.');
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    }
  }

  Future<List<PropertyGroup>> create(String theme) async {
    var json = await _makeRequest('create', {
      'theme': theme,
    });
    var response = CreateResponse.fromJson(json);
    return response.groups;
  }

  Future<dynamic> _makeRequest(String name, [dynamic parameters]) async {
    dLog('Request body to \'$name\':');
    dLogJson(parameters);

    var response = await FirebaseFunctions.instance.httpsCallable(name).call(parameters);
    var data = response.data;
    dLog('Response data from \'$name\':');
    dLogJson(data);

    return data;
  }
}