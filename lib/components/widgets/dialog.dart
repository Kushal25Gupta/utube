// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/screens/app_screen/add_video/upload_form.dart';

class DialogPopUp {
  final void Function(String imageUrl) onProfileImageUpdated;
  DialogPopUp({required this.onProfileImageUpdated});

  bool _isLoading = false;

  // Add a function to update the loading state
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  _getVideoFile(ImageSource sourceImg, BuildContext context) async {
    final videofile = await ImagePicker().pickVideo(source: sourceImg);
    if (videofile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadForm(
            videoFile: File(videofile.path),
            videoPath: videofile.path,
          ),
        ),
      );
    }
  }

  Future<void> _getProfileImage(
      ImageSource sourceImg, BuildContext context) async {
    final imageFile = await ImagePicker().pickImage(source: sourceImg);

    if (imageFile != null) {
      await updateProfileImage(imageFile.path, context);
      Utils().showMessage("Profile Image Changed Successfully");
    }
  }

  Future<void> updateProfileImage(
      String imagePath, BuildContext context) async {
    try {
      setLoading(true);
      String profileUrl = await uploadProfileImage(imagePath);
      await fireStore.collection('users').doc(userPhoneNumber).update({
        'profilePhoto': profileUrl,
      });
      onProfileImageUpdated(profileUrl);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils().toastMessage(e.toString());
    }
  }

  Future<String> uploadProfileImage(String imagepath) async {
    Reference ref =
        firebaseStorage.ref().child('profileimages').child(userPhoneNumber);
    UploadTask uploadTask = ref.putFile(File(imagepath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  displayDialogBox(BuildContext context, bool isUploadScreen) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //for add video
    if (isUploadScreen == true) {
      return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            DialogList(
                ontap: () {
                  _getVideoFile(ImageSource.gallery, context);
                },
                text: 'Gallery',
                iconData: Icons.image),
            DialogList(
                ontap: () {
                  _getVideoFile(ImageSource.camera, context);
                },
                text: 'Camera',
                iconData: Icons.camera_alt),
            DialogList(
                ontap: () {
                  Navigator.pop(context);
                },
                text: 'Cancel',
                iconData: Icons.cancel),
          ],
        ),
      );
    }
    // for profile screen
    else {
      return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            DialogList(
                ontap: () {
                  _getProfileImage(ImageSource.gallery, context);
                },
                text: 'Gallery',
                iconData: Icons.image),
            DialogList(
                ontap: () {
                  _getProfileImage(ImageSource.camera, context);
                },
                text: 'Camera',
                iconData: Icons.camera_alt),
            DialogList(
                ontap: () {
                  Navigator.pop(context);
                },
                text: 'Cancel',
                iconData: Icons.cancel),
          ],
        ),
      );
    }
  }
}

class DialogList extends StatelessWidget {
  const DialogList(
      {required this.ontap,
      required this.text,
      required this.iconData,
      super.key});

  final Function ontap;
  final String text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        ontap();
      },
      child: Row(
        children: [
          Icon(iconData),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
