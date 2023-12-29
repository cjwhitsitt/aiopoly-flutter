import 'package:aiopoly/create_response.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Service {
  Future<bool> create(String theme) async {
    var json = await FirebaseFunctions.instance.httpsCallable('create').call({
      'theme': theme,
    });
    var response = CreateResponse.fromJson(json.data);

    // Placeholder to just return success value
    if (response.success) return true;
    return false;
  }
}