import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utube/components/global.dart';
import 'package:utube/screens/authentication/login_screen.dart';
import 'package:utube/screens/app_screen/viewscreen.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = Get.find();
  late Rx<File?> _pickedFile;
  late Rx<User?> _currentUser;
  File? get profileImage => _pickedFile.value;

  void chooseImageWithGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar(
        "Profile Image",
        "You have Sucessfully picked your Profile Image",
      );
      _pickedFile = Rx<File?>(File(pickedImageFile.path));
    } else {
      Utils().toastMessage("Please choose the image");
    }
  }

  void captureImageFromCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImageFile != null) {
      Get.snackbar(
        "Profile Image",
        "You have Sucessfully picked your Profile Image",
      );
      _pickedFile = Rx<File?>(File(pickedImageFile.path));
    } else {
      Utils().toastMessage("Please choose the image again");
    }
  }

  void userNameImage(File imagefile, String username) async {
    String imagedownloadurl = await uploadImageToStorage(imagefile);
  }

  void defaultProfileAvatar() async {}

  Future<String> uploadImageToStorage(File imagefile) async {
    Reference reference = firebaseStorage
        .ref()
        .child("Profile Image")
        .child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(imagefile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrlOfUploadImage = await taskSnapshot.ref.getDownloadURL();
    return downloadUrlOfUploadImage;
  }

  goToScreen(User? currentUser) {
    if (currentUser == null) {
      Get.offAll(const LoginPage());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

  @override
  void onReady() {
    super.onReady();
    _currentUser = Rx<User?>(firebaseAuth.currentUser);
    _currentUser.bindStream(firebaseAuth.authStateChanges());
    ever(_currentUser, goToScreen);
  }
}
