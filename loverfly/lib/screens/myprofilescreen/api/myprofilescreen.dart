import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getAdmiredCouples(username) async {
  var admiredCouples = {};
  var url = Uri.parse(EnvConfig().baseUrl + '/get-admired-couples/');
  var db = await SharedPreferences.getInstance();

  try {
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
    );

    if (response.statusCode == 200) {
      admiredCouples = jsonDecode(response.body);
      print('get admired couples: Successful');
    } else {
      print('get admired couples: Fail');
      print(response.body);
    }
  } on SocketException {
    print('No internet connection');
  } catch (e) {
    print(e);
  }

  return admiredCouples;
}

Future<Map> deletePost(postId) async {
  var responseData = {};
  var url = Uri.parse(
      EnvConfig().baseUrl + '/delete-post/' + postId.toString() + '/');
  var db = await SharedPreferences.getInstance();

  try {
    var response = await http.post(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
    );

    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
    } else {
      return {"error": "Failed to delete the post"};
    }
  } on SocketException {
    print('No internet connection');
  } catch (e) {
    print(e);
  }
  return responseData;
}
