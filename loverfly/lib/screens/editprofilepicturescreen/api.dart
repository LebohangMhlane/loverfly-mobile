import 'dart:convert';
import 'dart:io';

import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> uploadProfilePicture(imageFile) async {
  var db = await SharedPreferences.getInstance();
  try {
    // prepare the request:
    var url = Uri.parse(EnvConfig().baseUrl + '/update-profile-picture');
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    request.headers["Authorization"] =
        "TOKEN " + db.getString('token')!.toString();
    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );
    request.files.add(multipartFile);
    var response = await request.send().timeout(const Duration(seconds: 10));

    // update the profile picture in cache:
    response.stream.listen((value) {
      final dataChunk = String.fromCharCodes(value);
      Map newProfilePicture = jsonDecode(dataChunk);
      Map userProfile = jsonDecode(db.getString("user_profile")!);
      userProfile["profile_picture"] = newProfilePicture["profile_picture"];
      db.setString("user_profile", jsonEncode(userProfile));
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on SocketException {
    return false;
  } catch (e) {
    return false;
  }
}
