
import 'package:loverfly/environmentconfig/envconfig.dart';

class UserProfile {

  int id = 0;
  String profilePicture = EnvConfig.defaultProfilePicture;
  bool isActive = true;
  bool isStraight = true;
  String username = "";
  String email = "";
  String accountLinkageCode = "";
  int numberOfAdmiredCouples = 0;
  int numberOfLikedPosts = 0;

  UserProfile.createFromJson(Map json){
    id = json["id"];
    profilePicture = json["profile_picture"]["image"];
    isActive = json["is_active"];
    isStraight = json["is_straight"];
    username = json["username"];
    email = json["email"];
    accountLinkageCode = json["account_linkage_code"] ?? "";
    numberOfAdmiredCouples = json["number_of_admired_couples"];
    numberOfLikedPosts = json["number_of_liked_posts"];
  }

}