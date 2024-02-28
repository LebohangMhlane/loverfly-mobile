
import 'package:flutter/widgets.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/models/post.dart';
import 'package:loverfly/features/view_couple/api/couplescreenapi.dart';

class ViewCoupleProvider extends ChangeNotifier {
  bool pageLoading = true;
  Couple? couple;

  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String partnerOneUsername = "";
  String partnerTwoUsername = "";

  String anniversary = "";

  List<Post> couplePosts = [];

  ViewCoupleProvider({required this.couple}) {
    initialize();
  }

  void initialize() async {
    partnerOnePicture = couple!.partnerOne!.profilePicture;
    partnerTwoPicture = couple!.partnerTwo!.profilePicture;
    partnerOneUsername = couple!.partnerOne!.username;
    partnerTwoUsername = couple!.partnerTwo!.username;
    Map response = await getCouplePosts(couple!.id);
    couplePosts = createPostObjects(response);
    pageLoading = false;
    notifyListeners();
  }

  List<Post> createPostObjects(Map response) {
    if (response.containsKey("error")){
      return [];
    } else {
      List posts = response["couple_posts"];
      posts = posts.map((postMap) => Post.createFromJson(postMap)).toList();
      return posts as List<Post>;
    }
  }

}
