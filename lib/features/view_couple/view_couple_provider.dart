
import 'package:flutter/widgets.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/models/post.dart';
import 'package:loverfly/features/view_couple/api/view_couple_api.dart';

class ViewCoupleProvider extends ChangeNotifier {

  bool pageLoading = true;
  bool isAdmired = false;
  bool errorOccured = false;

  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String partnerOneUsername = "";
  String partnerTwoUsername = "";
  String anniversary = "";

  List<Post> couplePosts = [];

  int coupleId;

  late Couple couple;

  ViewCoupleProvider({required this.coupleId}) {
    initialize();
  }

  void initialize() async {
    try{
      couple = await getViewedCouple(coupleId);
      partnerOnePicture = couple.partnerOne!.profilePicture;
      partnerTwoPicture = couple.partnerTwo!.profilePicture;
      partnerOneUsername = couple.partnerOne!.username;
      partnerTwoUsername = couple.partnerTwo!.username;
      Map response = await getCouplePosts(couple.id);
      couplePosts = createPostObjects(response);
      pageLoading = false;
      notifyListeners();
    } catch (error) {
      errorOccured = true;
      pageLoading = false;
      notifyListeners();
    }
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

  Future<Couple> getViewedCouple(int coupleId) async {
    var (successful, couple, isAdmired) = await getCouple(coupleId);
    if(successful){
      this.isAdmired = isAdmired;
      return couple;
    } else {
      Exception exception = couple;
      throw exception;
    }
  }

}
