import 'package:flutter/material.dart';

class LargerPreviewProvider extends ChangeNotifier {
  String image = "";
  bool showDeleteModal = false;
  bool isMyPost = false;
  int postId = 000;

  LargerPreviewProvider({
    required this.image, 
    required this.isMyPost, 
    required this.postId});

  void toggleShowDeleteModal() {
    showDeleteModal = !showDeleteModal;
  }
}
