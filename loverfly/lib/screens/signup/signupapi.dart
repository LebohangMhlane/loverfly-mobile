import 'dart:convert';

import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> createAccountAPI() async {
  try {
    SharedPreferences db = await SharedPreferences.getInstance();
    // make sure shared preferences has everything we need:
    if (db.containsKey("username") &&
        db.containsKey("email") &&
        db.containsKey("password")) {
      // if it does, get everything we need:
      String? username = db.getString("username");
      String? email = db.getString("email");
      String? password = db.getString("password");
      // make the request:
      Uri url = Uri.parse(EnvConfig().baseUrl + '/sign-up/');
      var response = await http.post(
        url,
        body: {"username": username, "email": email, "password": password},
      );
      if (response.statusCode == 201) {
        await db.setString("userprofile", jsonEncode(response.body));
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

// Future<bool> createFirebaseAccount() async {
//     SharedPreferences db = await SharedPreferences.getInstance();
// }
