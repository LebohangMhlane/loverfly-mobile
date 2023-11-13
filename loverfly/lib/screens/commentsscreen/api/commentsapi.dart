import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../environmentconfig/envconfig.dart';

Future<Map> getComments(postId, nextPageLink) async {
  try {
    var cache = GetStorage();
    Uri url = Uri.parse(
        EnvConfig().baseUrl + '/get-comments/' + postId.toString() + '/');
    var apiResponse = await http.get(
      url,
      headers: {
        'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
      },
    );
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {"apiResponse": "Local Error"};
  }
}

Future<Map> getCommentsWithPagination(postId, nextPageLink) async {
  try {
    var db = GetStorage();
    Uri url = Uri.parse(nextPageLink);
    var apiResponse = await http.get(
      url,
      headers: {
        'Authorization': 'TOKEN ' + db.read('token')!.toString(),
      },
    );
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {"apiResponse": "Local Error"};
  }
}

Future<Map> postComment(postId, commentData) async {
  try {
    var cache = GetStorage();
    var url = Uri.parse(
        EnvConfig().baseUrl + '/post-comment/' + postId.toString() + '/');
    var apiResponse = await http.post(url, headers: {
      'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
    }, body: {
      "comment": commentData["comment"]
    });
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {"apiResponse": "Local Error"};
  }
}

Future<Map> replyToCommentServer(commentId, commentData) async {
  try {
    var cache = GetStorage();
    var url = Uri.parse(EnvConfig().baseUrl +
        '/reply-to-comment/' +
        commentId.toString() +
        "/");
    var apiResponse = await http
        .post(
          url,
          headers: {
            'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
          },
          body: commentData,
        )
        .timeout(const Duration(seconds: 1000));
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {
      "error": error.toString(),
    };
  }
}

Future<Map> getCommentRepliesFromServer(commentId) async {
  try {
    var cache = GetStorage();
    var url = Uri.parse(EnvConfig().baseUrl +
        '/get-comment-replies/' +
        commentId.toString() +
        "/");
    var apiResponse = await http.get(
      url,
      headers: {
        'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
      },
    ).timeout(const Duration(seconds: 10));
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {
      "error": error.toString(),
    };
  }
}

Future<Map> likeComment(commentId, commentLiked) async {
  try {
    var cache = GetStorage();
    var url = Uri.parse(EnvConfig().baseUrl + '/like-comment/');
    var apiResponse = await http.post(url, headers: {
      'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
    }, body: {
      "comment_id": commentId.toString(),
      "comment_liked": commentLiked.toString()
    });
    Map response = jsonDecode(apiResponse.body);
    return response;
  } catch (error) {
    return {"apiResponse": "Local Error"};
  }
}

Future<Map> deleteCommentService(commentId) async {
  try {
    var cache = GetStorage();
    var url = Uri.parse(
        EnvConfig().baseUrl + '/delete-comment/' + commentId.toString() + '/');
    var apiResponse = await http.post(url, headers: {
      'Authorization': 'TOKEN ' + cache.read('token')!.toString(),
    });
    return jsonDecode(apiResponse.body);
  } catch (error) {
    return {"api_response": "Local Error"};
  }
}
