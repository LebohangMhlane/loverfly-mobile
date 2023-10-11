import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loverfly/utils/pageutils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../environmentconfig/envconfig.dart';

class AuthenticationAPI {
  // =========================================================================
  // handles authentication throughout the app
  // =========================================================================
  late SharedPreferences db;

  AuthenticationAPI() {
    SharedPreferences.getInstance().then((value) {
      db = value;
    });
  }

  Future<Map> getAndCacheAPIToken({username, password}) async {
    Map token = {};
    try {
      var url = Uri.parse(EnvConfig().baseUrl + '/api-token-auth/');
      var response = await http
          .post(
            url,
            headers: {'content-type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var serverResponse = jsonDecode(response.body);
        db.clear();
        db.setString('token', serverResponse['token']);
        token["token"] = serverResponse['token'];
        return token;
      } else {
        var responseBody = jsonDecode(response.body);
        if (responseBody['non_field_errors'][0] ==
            "Unable to log in with provided credentials.") {
          token["error_info"] = "Incorrect username or password";
        } else {
          token["error_info"] =
              "Something went wrong on our end. We will fix it soon";
        }
        return token;
      }
    } catch (e) {
      String error = e.toString();
      if (error.split(" ").contains("TimeoutException")) {
        token["error_info"] =
            "No connection to server: Please check internet connection";
      }
      return token;
    }
  }

  // gets and returns a user profile and couple data from the database:
  Future<Map> getUserProfileAndCoupleData(token, context) async {
    Map userProfileAndCoupleData = {};
    var url =
        Uri.parse(EnvConfig().baseUrl + '/get-user-profile-and-couple-data/');
    try {
      var response = await http.post(
        url,
        headers: {'Authorization': 'TOKEN ' + token.toString()},
      );

      if (response.statusCode == 200) {
        userProfileAndCoupleData = jsonDecode(response.body);
      } else {
        userProfileAndCoupleData = {'error': true};
      }
    } on SocketException {
      SnackBars()
          .displaySnackBar("Failed to connect to server", () => null, context);
    } catch (e) {
      SnackBars().displaySnackBar(
          "Something went wrong. We're looking into it.", () => null, context);
    }
    return userProfileAndCoupleData;
  }
}
