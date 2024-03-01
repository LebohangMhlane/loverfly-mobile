import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loverfly/components/app_bar.dart';
import 'package:loverfly/components/custom_button.dart';
import 'package:loverfly/features/change_profile_picture/api.dart';
import 'package:loverfly/utils/pageutils.dart';

class EditProfilePictureScreen extends StatefulWidget {
  const EditProfilePictureScreen(
      {Key? key,
      required this.reloadProfilePage,
      required this.currentProfilePicture})
      : super(key: key);

  final Function reloadProfilePage;
  final String currentProfilePicture;

  @override
  State<EditProfilePictureScreen> createState() =>
      _EditProfilePictureScreenState();
}

class _EditProfilePictureScreenState extends State<EditProfilePictureScreen> {
  final ImagePicker imagepicker = ImagePicker();
  XFile? selectedImage;
  bool settingProfilePicture = false;

  void setProfilePicture() async {
    if (!settingProfilePicture) {
      setState(() {
        settingProfilePicture = true;
      });
      File imageFile = File(selectedImage!.path);
      bool uploaded = await uploadProfilePicture(imageFile);
      widget.reloadProfilePage();
      uploaded
          ? SnackBars().displaySnackBar("Uploaded successfully", () {
              Get.back();
            }, context)
          : SnackBars().displaySnackBar(
              "Something went wrong. Please try again later.",
              () => null,
              context);
      setState(() {
        settingProfilePicture = false;
      });
    } else {
      SnackBars()
          .displaySnackBar("Upload still in progress...", () => null, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.reloadProfilePage();
        return true;
      },
      child: Scaffold(
          appBar: customAppBar(context, "- Edit Profile Picture"),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // picture previewer:
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  child: Center(
                    child: Stack(children: [
                      // preview:
                      Container(
                        width: 160.0,
                        height: 160.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: selectedImage != null
                                    ? Image.file(File(selectedImage!.path))
                                        .image
                                    : widget.currentProfilePicture == ""
                                        ? const NetworkImage(
                                            "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg")
                                        : NetworkImage(
                                            widget.currentProfilePicture)),
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100.0)),
                      ),

                      // from camera:
                      Positioned(
                        top: 120.0,
                        child: GestureDetector(
                          onTap: () async {
                            var imageFromCamera = await imagepicker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              selectedImage = imageFromCamera;
                            });
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // from gallery:
                      Positioned(
                        top: 120.0,
                        right: 1.0,
                        child: GestureDetector(
                          onTap: () async {
                            var imageFromCamera = await imagepicker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              selectedImage = imageFromCamera;
                            });
                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

                // set profile picture button:
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomButton(
                      width: 200.0,
                      borderradius: 10.0,
                      leftpadding: 20.0,
                      rightpadding: 20.0,
                      leftmargin: 50.0,
                      rightmargin: 50.0,
                      buttonlabel: settingProfilePicture
                          ? "Uploading..."
                          : "Set Profile Picture",
                      buttoncolor: Colors.purple,
                      onpressedfunction: () async {
                        if (selectedImage != null) {
                          setProfilePicture();
                        } else {
                          SnackBars().displaySnackBar(
                              "No image to upload", () => null, context);
                        }
                      }),
                )
              ],
            ),
          )),
    );
  }
}
