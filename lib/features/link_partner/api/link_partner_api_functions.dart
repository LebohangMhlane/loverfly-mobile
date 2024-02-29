import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environment_configurations/envconfig.dart';

Future<Map> generateLinkCode() async {
  var code = {};
  try {
    var cache = GetStorage();
    var url = Uri.parse(EnvConfig.baseUrl + '/generate-code/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    code = jsonDecode(response.body);
    return code;
  } catch (e) {
    return {"error": "Failed to generate code"};
  }
}

Future<Map> inputLinkCode(code) async {
  Map finalresponse = {};
  try {
    var cache = GetStorage();
    var url = Uri.parse(EnvConfig.baseUrl + '/input-code/' + code + '/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + cache.read('token')!.toString()},
    );
    finalresponse = jsonDecode(response.body);
    return finalresponse;
  } catch (e) {
    return {"error": "Failed to link accounts"};
  }
}
