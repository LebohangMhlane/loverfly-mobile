import 'dart:convert';

import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> signUp() async {
  // get the required data for sign up:
  // prepare the url:
  // make the sign up request:
  // if it is 201 then save the returned userprofile to cache:
  // return true:
  try {
    SharedPreferences db = await SharedPreferences.getInstance();
    if (db.containsKey("username") &&
        db.containsKey("email") &&
        db.containsKey("password")) {
      String? username = db.getString("username");
      String? email = db.getString("email");
      String? password = db.getString("password");
      Uri url = Uri.parse(EnvConfig().baseUrl + '/sign-up/');
      var response = await http.post(
        url,
        body: {"username": username, "email": email, "password": password},
      );
      if (response.statusCode == 201) {
        await db.setString("user_profile", jsonEncode(response.body));
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
