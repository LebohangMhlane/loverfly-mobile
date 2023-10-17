import 'package:flutter/material.dart';
import 'package:loverfly/components/customappbar.dart';

class EditProfilePictureScreen extends StatelessWidget {
  const EditProfilePictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Edit Profile Picture"),
    );
  }
}
