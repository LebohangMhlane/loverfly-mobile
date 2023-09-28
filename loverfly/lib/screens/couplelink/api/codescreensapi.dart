import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../environmentconfig/envconfig.dart';
import 'package:http/http.dart' as http;

Future<Map> generateLinkCode() async {
  var code = {};
  try {
    var db = await SharedPreferences.getInstance();
    var url = Uri.parse(EnvConfig().baseUrl + '/generate-code/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
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
    var db = await SharedPreferences.getInstance();
    var url = Uri.parse(EnvConfig().baseUrl + '/input-code/' + code + '/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'TOKEN ' + db.getString('token')!.toString()},
    );
    finalresponse = jsonDecode(response.body);
    return finalresponse;
  } catch (e) {
    return {"error": "Failed to link accounts"};
  }
}
