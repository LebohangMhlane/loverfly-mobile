import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environment_configurations/envconfig.dart';

Future<Map> admire(coupleid, admired) async {
  var url = Uri.parse(EnvConfig.baseUrl +
      '/admire/' +
      coupleid.toString() +
      '/' +
      admired.toString() +
      '/');
  var cache = GetStorage();
  try {
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    if (response.statusCode == 200) {
      var apiResponse = jsonDecode(response.body);
      if (apiResponse["api_response"] != 'failed') {
        return apiResponse;
      } else {
        return {"error_info": apiResponse["error_info"]};
      }
    } else {
      return {"error_info": "Server error:" + response.statusCode.toString()};
    }
  } on SocketException {
    return {"error_info": "Socket Exception occured"};
  } catch (e) {
    return {"error_info": "Something else went horribly wrong"};
  }
}
