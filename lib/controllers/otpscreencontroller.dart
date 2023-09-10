import 'package:firebase_storage/firebase_storage.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/models/user.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';

class UploadUser {
  final String? _currentUserUid = firebaseAuth.currentUser?.uid;

  Future<String> uploadDefaultProfilePhoto(String path) async {
    userUid = _currentUserUid.toString() ?? "error";

    try {
      final ByteData data = await rootBundle.load(path);
      final List<int> bytes = data.buffer.asUint8List();
      final Uint8List uint8List = Uint8List.fromList(bytes);

      Reference ref =
          firebaseStorage.ref().child("profileimages").child(userPhoneNumber);

      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Utils().toastMessage(e.toString());
      return e.toString();
    }
  }

  Future<void> uploadUser(String phonenumber, path) async {
    userPhoneNumber = phonenumber;
    var snap = await fireStore.collection('users').doc(phonenumber).get();
    if (snap.exists) {
      //do nothing
    } else {
      String profilephoto = await uploadDefaultProfilePhoto(path);
      var currentUser = User(
        userName: phonenumber,
        phoneNumber: phonenumber,
        profilePhoto: profilephoto,
        uid: userUid,
      );
      await fireStore
          .collection("users")
          .doc(phonenumber)
          .set(currentUser.toJson());
    }
  }
}
