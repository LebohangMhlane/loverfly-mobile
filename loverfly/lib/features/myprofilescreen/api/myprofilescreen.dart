import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getAdmiredCouples(username) async {
  var url = Uri.parse(EnvConfig.baseUrl + '/get-admired-couples/');
  var cache = GetStorage();

  try {
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    if (response.statusCode == 200) {
      Map admiredCouples = jsonDecode(response.body);
      return admiredCouples;
    } else {
      return {"error": "An server error has occured."};
    }
  } on SocketException {
    return {"error": "No connection could be made."};
  } catch (e) {
    return {"error": "An error has occured", "error_info": e.toString()};
  }
}

Future<Map> deletePost(postId) async {
  var responseData = {};
  var url = Uri.parse(
      EnvConfig.baseUrl + '/delete-post/' + postId.toString() + '/');
  var cache = GetStorage();

  try {
    var response = await http.post(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
    } else {
      return {"error": "A server error has occured."};
    }
  } on SocketException {
    return {"error": "No connection could be made."};
  } catch (e) {
    return {"error": "An error has a occured."};
  }
  return responseData;
}
