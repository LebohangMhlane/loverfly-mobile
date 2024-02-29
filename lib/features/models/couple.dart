
import 'package:loverfly/features/models/userprofile.dart';
import 'package:loverfly/utils/utils.dart';

class Couple {

  String id = "";
  UserProfile? partnerOne;
  UserProfile? partnerTwo;
  String startedDating = "";
  int anniversaries = 0;
  int admirers = 0;
  String lastAnniversary = "";
  String nextAnniversary = "";
  String relationshipStatus = "";
  bool isStraightCouple = true;
  bool limbo = false;
  String limboDate = "";
  bool isActive = true;
  bool isVerified = false;
  bool hasPosts = false;

  Couple();

  Couple.createFromJson(Map json){
    id = json["id"].toString();
    partnerOne = UserProfile.createFromJson(json["partner_one"]);
    partnerTwo = UserProfile.createFromJson(json["partner_two"]);
    startedDating = DateFunctions().convertdate(json["started_dating"])["normalized"] as String;
    anniversaries = json["anniversaries"];
    admirers = json["admirers"];
    lastAnniversary = DateFunctions().convertdate(json["last_anniversary"])["normalized"] as String;
    nextAnniversary = DateFunctions().convertdate(json["next_anniversary"])["normalized"] as String;
    relationshipStatus = json["relationship_status"];
    isStraightCouple = json["is_straight_couple"];
    limbo = json["limbo"];
    limboDate = json["limbo_date"];
    isActive = json["is_active"];
    isVerified = json["is_verified"];
    hasPosts = json["has_posts"];
  }

}

