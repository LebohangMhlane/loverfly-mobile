import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loverfly/environmentconfig/envconfig.dart';

Future<Map> createAPost(caption, imageFile) async {
  var url = Uri.parse(EnvConfig().baseUrl + '/create-a-post/');
  var cache = GetStorage();
  try {
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );
    request.headers["Authorization"] =
        "TOKEN " + cache.read('token')!.toString();
    request.files.add(multipartFile);
    request.fields["caption"] = caption;
    var response = await request.send();
    if (response.statusCode == 201) {
      return {"post_created": true};
    } else {
      return {"error": "An error has occured on the server"};
    }
  } on SocketException {
    return {"error": "No connection could be made"};
  } catch (e) {
    return {
      "error": "An error has occured",
      "error_info": e.toString(),
    };
  }
}
