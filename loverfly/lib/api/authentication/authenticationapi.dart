import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../environment_configurations/envconfig.dart';

class AuthenticationAPI {
  // =========================================================================
  // handles authentication throughout the app
  // =========================================================================
  final cache = GetStorage();

  Future<Map> getAndCacheAPIToken({username, password}) async {
    Map token = {};
    try {
      var url = Uri.parse(EnvConfig.baseUrl + '/api-token-auth/');
      var response = await http
          .post(
            url,
            headers: {'content-type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var serverResponse = jsonDecode(response.body);
        cache.write('token', serverResponse['token']);
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
  Future<Map> getUserProfileAndCoupleData(token) async {
    Map userProfileAndCoupleData = {};
    var url = Uri.parse(EnvConfig.baseUrl + '/get-user-profile-and-couple-data/');
    try {
      var response = await http.post(
        url,
        headers: {'Authorization': 'TOKEN ' + token.toString()},
      );
      if (response.statusCode == 200) {
        userProfileAndCoupleData = jsonDecode(response.body);
      } else {
        userProfileAndCoupleData = {};
      }
    } on SocketException {
      return {};
    } catch (e) {
      return {};
    }
    return userProfileAndCoupleData;
  }
}
