import 'package:get_storage/get_storage.dart';
import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:http/http.dart' as http;

Future<bool> signUp() async {
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
