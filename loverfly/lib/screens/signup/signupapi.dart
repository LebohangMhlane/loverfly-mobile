import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> signUp() async {
  try {
    SharedPreferences cache = await SharedPreferences.getInstance();
    if (cache.containsKey("username") &&
        cache.containsKey("email") &&
        cache.containsKey("password")) {
      String? username = cache.getString("username");
      String? email = cache.getString("email");
      String? password = cache.getString("password");
      Uri url = Uri.parse(EnvConfig().baseUrl + '/sign-up/');
      var response = await http.post(
        url,
        body: {"username": username, "email": email, "password": password},
      );
      if (response.statusCode == 201) {
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
