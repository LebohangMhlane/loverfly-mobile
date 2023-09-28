import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getCouplePosts(coupleid) async {
  Map responseMap = {};
  // get cache:
  var db = await SharedPreferences.getInstance();
  try {
    var url = Uri.parse(
        EnvConfig().baseUrl + '/get-couple-posts/' + coupleid.toString() + '/');
    var response = await http.get(url,
        headers: {'Authorization': 'TOKEN ' + db.getString('token')!});
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

Future<bool> checkIfFavourited(coupleid) async {
  Map responseMap = {};
  var db = await SharedPreferences.getInstance();
  try {
    var url = Uri.parse(EnvConfig().baseUrl +
        '/check-if-favourited/' +
        coupleid.toString() +
        '/');
    var response = await http.get(url,
        headers: {'Authorization': 'TOKEN ' + db.getString('token')!});
    if (response.statusCode == 200) {
      responseMap = jsonDecode(response.body);
      return responseMap["favourited"];
    } else {
      return false;
    }
  } on SocketException {
    return false;
  } catch (e) {
    return false;
  }
}
