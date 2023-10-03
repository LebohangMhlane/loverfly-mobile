import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> createAPost(caption, imageurl) async {
  var url = Uri.parse(EnvConfig().baseUrl + '/create-a-post/');
  var db = await SharedPreferences.getInstance();
  try {
    var response = await http.post(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
      body: {'caption': caption, 'image_url': imageurl},
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData;
    } else {
      return {"error": "An error has occured on the server"};
    }
  } on SocketException {
    return {"error": "No connection could be made"};
  } catch (e) {
    return {
      "error": "An error has occured",
      "error_info": e.toString(),
    };
  }
}
