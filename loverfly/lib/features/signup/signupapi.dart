import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:http/http.dart' as http;

Future<Map> signUp() async {
  try {
    var cache = GetStorage();
    if (cache.hasData("username") &&
        cache.hasData("email") &&
        cache.hasData("password")) {
      String? username = cache.read("username");
      String? email = cache.read("email");
      String? password = cache.read("password");
      Uri url = Uri.parse(EnvConfig().baseUrl + '/sign-up/');
      var response = await http.post(
        url,
        body: {"username": username, "email": email, "password": password},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        return {"status": true};
      } else {
        Map body = jsonDecode(response.body);
        if (body.containsKey("error")) {
          return {"status": false, "error": body["error_msg"]};
        }
      }
    } else {
      return {"status": false, "error": "Missing credentials."};
    }
  } catch (e) {
    return {"status": false, "error": "A logic error has occured."};
  }
  return {"status": false, "error": "Sign up failed."};
}
