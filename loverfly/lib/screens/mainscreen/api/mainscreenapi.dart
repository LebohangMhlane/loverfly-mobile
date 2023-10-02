import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

// get all posts of admired couples from the database:
Future<Map> getPostsForFeed(nextLink) async {
  Map apiResponse = {};
  var db = await SharedPreferences.getInstance();

  // determine if we are triggering pagination:
  Uri url;
  if (nextLink != null) {
    url = Uri.parse(nextLink);
  } else {
    url = Uri.parse(EnvConfig().baseUrl + '/get-posts-for-feed/');
  }

  // make the request:
  try {
    var response = await http.get(url,
        headers: {'Authorization': 'TOKEN ' + db.getString('token')!});
    if (response.statusCode == 200) {
      apiResponse = jsonDecode(response.body);
    } else {
      print('An error occured while: getPostsForFeed');
    }
  } on SocketException {
    print('No connection made');
  }

  return apiResponse;
}
