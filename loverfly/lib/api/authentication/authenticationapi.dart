// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../environmentconfig/envconfig.dart';

class AuthenticationAPI {
  // =========================================================================
  // generates an authentication token and userprofile for the registered user
  // =========================================================================
  late SharedPreferences db;

  AuthenticationAPI() {
    SharedPreferences.getInstance().then((value) {
      db = value;
    });
  }

  Future<Map> getAndCacheAPIToken({username, email, password}) async {
    Map tokenMap = {};
    try {
      var url = Uri.parse(EnvConfig().baseUrl + '/api-token-auth/');
      var response = await http
          .post(
            url,
            headers: {'content-type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        // cache and return the token:
        var responseAsJson = jsonDecode(response.body);
        db.clear();
        db.setString('token', responseAsJson['token']);
        tokenMap["token"] = responseAsJson['token'];
        return tokenMap;
      } else {
        var responseBody = jsonDecode(response.body);
        if (responseBody['non_field_errors'][0] ==
            "Unable to log in with provided credentials.") {
          tokenMap["error_info"] = "Incorrect username or password";
        } else {
          tokenMap["error_info"] =
              "Something went wrong on our end. We will fix it soon";
        }

        return tokenMap;
      }
    } catch (e) {
      String error = e.toString();
      if (error.contains("TimeoutException")) {
        tokenMap["error_info"] =
            "No connection to server: Please check internet connection";
      }
      throw Exception();
    }
  }

  // get a user profile and couple data from the database:
  Future<Map> getUserProfileAndCoupleData(token) async {
    Map userProfileAndCoupleData = {};
    var url =
        Uri.parse(EnvConfig().baseUrl + '/get-user-profile-and-couple-data/');
    try {
      // get the user profile and couple data from the server:
      var response = await http.post(
        url,
        headers: {'Authorization': 'TOKEN ' + token.toString()},
      );

      // decode everything into a useable map object:
      if (response.statusCode == 200) {
        userProfileAndCoupleData = jsonDecode(response.body);
      } else {
        userProfileAndCoupleData = {'error': true};
      }
    } on SocketException {
      print('No connection made');
    } catch (e) {
      print(e);
    }
    return userProfileAndCoupleData;
  }
}
