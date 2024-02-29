import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environment_configurations/envconfig.dart';
import 'package:loverfly/features/models/couple.dart';

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

Future<(bool, dynamic, bool)> getCouple(int coupleId) async {
  var cache = GetStorage();
  try {
    var url = Uri.parse(
      EnvConfig.baseUrl + '/get-couple/' + coupleId.toString() + '/'
    );
    var response = await http.get(
      url, 
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!}
    );
    if (response.statusCode == 200) {
      Map responseMap = jsonDecode(response.body);
      Couple couple = Couple.createFromJson(responseMap["couple"]);
      bool isAdmired = responseMap["isAdmired"];
      return (true, couple, isAdmired);
    } else {
      return (false, Exception(
        "Server Error: Code ${response.statusCode}"), 
        false
      );
    }
  } on SocketException {
    return (false, Exception("No internet connection"), false);
  } catch (e) {
    return (false, Exception(e), false);
  }
}