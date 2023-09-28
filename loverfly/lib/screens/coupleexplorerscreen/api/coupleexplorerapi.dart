import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> getAllCouples() async {
  Map coupledata = {};
  var url = Uri.parse(EnvConfig().baseUrl + '/get-all-couples/');
  var db = await SharedPreferences.getInstance();
  try {
    var response = await http.get(url, headers: {
      'Authorization': 'TOKEN ' + db.getString('token')!.toString()
    });
    if (response.statusCode == 200) {
      coupledata = jsonDecode(response.body);
    } else {
      print('get all user profiles: Fail');
      print(response.body);
    }
  } on SocketException {
    print('No connection made');
  } catch (e) {
    print(e);
  }
  return coupledata;
}

Future<Map> getTrendingCouples() async {
  Map trendingCouples = {};
  var url = Uri.parse(EnvConfig().baseUrl + '/get-trending-couples/');
  var db = await SharedPreferences.getInstance();
  try {
    var response = await http.get(url, headers: {
      'Authorization': 'TOKEN ' + db.getString('token')!.toString()
    });
    if (response.statusCode == 200) {
      trendingCouples = jsonDecode(response.body);
    } else {
      print('Error during: getTrendingCouples');
      print(response.body);
    }
  } on SocketException {
    print('No connection made');
  } catch (e) {
    print(e);
  }
  return trendingCouples;
}
