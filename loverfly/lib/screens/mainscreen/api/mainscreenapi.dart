import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getPostsForFeed(nextLink) async {
  Map apiResponse = {};
  var cache = GetStorage();
  // determine if we are triggering pagination:
  Uri url;
  if (nextLink != null) {
    url = Uri.parse(nextLink);
  } else {
    url = Uri.parse(EnvConfig().baseUrl + '/get-posts-for-feed/');
  }
  // make the request:
  try {
    var response = await http
        .get(url, headers: {'Authorization': 'TOKEN ' + cache.read('token')!});
    if (response.statusCode == 200) {
      apiResponse = jsonDecode(response.body);
    } else {
      return {"error": "An error has occured on the server"};
    }
  } on SocketException {
    return {"error": "No connection could be made"};
  }
  return apiResponse;
}
