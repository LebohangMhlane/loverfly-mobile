import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> favourite(coupleid, favourited) async {
  var url = Uri.parse(EnvConfig().baseUrl +
      '/favourite/' +
      coupleid.toString() +
      '/' +
      favourited.toString() +
      '/');
  var db = await SharedPreferences.getInstance();
  try {
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
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
