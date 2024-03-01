import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environment_configurations/envconfig.dart';
import 'package:loverfly/features/models/couple.dart';

Future<(bool, dynamic)> getAllCouples() async {
  Map coupleData = {};
  var url = Uri.parse(EnvConfig.baseUrl + '/get-all-couples/');
  var cache = GetStorage();
  try {
    var response = await http.get(url, headers: {
      'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
    });
    if (response.statusCode == 200) {
      coupleData = jsonDecode(response.body);
      List coupleJsons = coupleData["couples"];
      return (true, convertCoupleInstancesToModel(coupleJsons));
    } else {
      return (false, Exception("Server error: ${response.statusCode}"));
    }
  } on SocketException {
    return (false, Exception("No internet connection"));
  } catch (e) {
    return (false, Exception("An error occurred: ${e.toString()}"));
  }
}

List<CoupleInstance> convertCoupleInstancesToModel(List coupleJson){
  List<CoupleInstance> coupleInstances = coupleJson.map((coupleJson) => 
    CoupleInstance(
      couple: Couple.createFromJson(coupleJson["couple"]), 
      isAdmired: coupleJson["isAdmired"]
    )
  ).toList();
  return coupleInstances;
}

class CoupleInstance {

  Couple couple;
  bool isAdmired;

  CoupleInstance({
    required this.couple,
    required this.isAdmired,
  });

}

Future<Map> getTrendingCouples() async {
  Map trendingCouples = {};
  var url = Uri.parse(EnvConfig.baseUrl + '/get-trending-couples/');
  var cache = GetStorage();
  try {
    var response = await http.get(url,
        headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()});
    if (response.statusCode == 200) {
      trendingCouples = jsonDecode(response.body);
    } else {
      return {
        "error": "An error has occured on the server",
        "error_info": response.body
      };
    }
  } on SocketException {
    return {
      "error": "An error has occured on the server",
      "error_info": "A connection could not be made",
    };
  } catch (e) {
    return {
      "error": "An error has occured on the server",
      "error_info": e.toString()
    };
  }
  return trendingCouples;
}
