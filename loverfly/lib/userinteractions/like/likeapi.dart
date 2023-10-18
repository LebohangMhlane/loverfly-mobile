import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future likePost(postid, postliked) async {
  var url = Uri.parse(EnvConfig().baseUrl +
      '/like-post/' +
      postid.toString() +
      '/' +
      postliked.toString());
  var cache = GetStorage();
  try {
    var response = await http.get(url,
        headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()});
    if (response.statusCode == 200) {
      var apiResponse = jsonDecode(response.body);
      if (apiResponse["api_response"] == "Success") {
        bool responseBool = apiResponse["post_liked"];
        return responseBool;
      }
    } else {
      return postliked;
    }
  } on SocketException {
    return {"error": "No connection could be made"};
  } catch (e) {
    return {"error": "An error has occured", "error_info": e.toString()};
  }
}
