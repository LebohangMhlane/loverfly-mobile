
import 'package:flutter/widgets.dart';
import 'package:loverfly/features/models/couple.dart';

class ViewCoupleProvider extends ChangeNotifier {
  bool pageLoading = true;
  Couple couple = Couple.createFromJson({});

  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String partnerOneUsername = "";
  String partnerTwoUsername = "";

  String anniversary = "";

  List coupleMemories = [];

  ViewCoupleProvider({required this.couple}) {
    partnerOnePicture = couple.partnerOne!.profilePicture;
    partnerTwoPicture = couple.partnerTwo!.profilePicture;

    partnerOneUsername = couple.partnerOne!.username;
    partnerTwoUsername = couple.partnerTwo!.username;
    pageLoading = false;
    notifyListeners();
  }
}
