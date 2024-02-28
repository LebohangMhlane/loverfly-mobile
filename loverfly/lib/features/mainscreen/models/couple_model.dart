

class CoupleModel {

  String? id = "";
  UserProfileModel? partnerOne = UserProfileModel.createFromJson({});
  UserProfileModel? partnerTwo = UserProfileModel.createFromJson({});
  Map? coupleData = {};
  String? startedDating = "";
  int? anniversaries = 0;
  int? admirers = 0;
  String? lastAnniversary = "";
  String? nextAnniversary = "";
  String? relationshipStatus = "";
  bool? isStraightCouple = true;
  bool? limbo = false;
  String? limboDate = "";
  bool? isActive = true;
  bool? isVerified = false;
  bool? hasPosts = false;

  CoupleModel.createFromJson(Map json){
    id = json["id"];
    partnerOne = json["partner_one"];
    partnerTwo = json["partner_two"];
    coupleData = json["couple_data"];
    startedDating = json["started_dating"];
    anniversaries = json["anniversaries"];
    admirers = json["admirers"];
    lastAnniversary = json["last_anniversary"];
    nextAnniversary = json["next_anniversary"];
    relationshipStatus = json["relationship_status"];
    isStraightCouple = json["is_straight_couple"];
    limbo = json["limbo"];
    limboDate = json["limbo_date"];
    isActive = json["is_active"];
    isVerified = json["is_verified"];
    hasPosts = json["has_posts"];
  }

}

class UserProfileModel {

  int? id = 0;
  String? profilePicture = "";
  bool? isActive = true;
  bool? isStraight = true;
  String? username = "";
  String? email = "";
  String? accountLinkageCode = "";
  int? numberOfAdmiredCouples = 0;
  int? numberOfLikedPosts = 0;
  UserProfileModel? myPartner = UserProfileModel.createFromJson({});

  UserProfileModel.createFromJson(Map json){
    id = json["id"];
    profilePicture = json["profile_picture"];
    isActive = json["is_active"];
    isStraight = json["is_straight"];
    username = json["username"];
    email = json["email"];
    accountLinkageCode = json["account_linkage_code"];
    numberOfAdmiredCouples = json["number_of_admired_couples"];
    numberOfLikedPosts = json["number_of_liked_posts"];
    myPartner = UserProfileModel.createFromJson(json["my_partner"]);
  }


}