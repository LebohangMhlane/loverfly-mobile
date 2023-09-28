import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> createAPost(caption, imageurl) async {
  var responseData = {};
  var url = Uri.parse(EnvConfig().baseUrl + '/create-a-post/');
  var db = await SharedPreferences.getInstance();
  try {
    var response = await http.post(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
      body: {'caption': caption, 'image_url': imageurl},
    );
    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
    } else {
      return {"error": "Failed to create the post"};
    }
  } on SocketException {
    print('No internet connection');
  } catch (e) {
    print(e);
  }
  return responseData;
}
