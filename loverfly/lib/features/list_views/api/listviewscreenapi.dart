import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../environmentconfig/envconfig.dart';

// requests and returns a list of followers from the server:
Future<Map> getAdmirersFromServer(nextPageLink) async {
  var cache = GetStorage();
  var url = Uri.parse(EnvConfig.baseUrl + '/get-all-admirers/');
  if (nextPageLink != "") {
    url = Uri.parse(nextPageLink);
  }
  try {
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    if (response.statusCode == 200) {
      Map responseData = jsonDecode(response.body);
      return responseData;
    } else {
      return {
        "error": "failed to get admirers",
        "error_message": "server error"
      };
    }
  } on SocketException {
    return {"error": "No connection made"};
  } catch (e) {
    return {"error": e.toString()};
  }
}
