import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getCouplePosts(coupleid) async {
  Map responseMap = {};
  var cache = GetStorage();
  try {
    var url = Uri.parse(EnvConfig.baseUrl + '/get-couple-posts/' + coupleid.toString() + '/');
    var response = await http.get(url, headers: {'Authorization': 'TOKEN ' + cache.read('token')!});
    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
    } else {
      return {
        "api_response": "failed",
        "error_info": "Server error",
      };
    }
  } on SocketException {
    return {
      "api_response": "failed",
      "error_info": "No internet connection",
    };
  } catch (e) {
    return {
      "api_response": "failed",
      "error_info": e.toString(),
    };
  }
  return responseMap;
}

Future<bool> checkIfAdmired(coupleid) async {
  Map responseMap = {};
  var cache = GetStorage();
  try {
    var url = Uri.parse(
        EnvConfig.baseUrl + '/check-if-admired/' + coupleid.toString() + '/');
    var response = await http
        .get(url, headers: {'Authorization': 'TOKEN ' + cache.read('token')!});
    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
      return responseMap["admired"];
    } else {
      return false;
    }
  } on SocketException {
    return false;
  } catch (e) {
    return false;
  }
}
