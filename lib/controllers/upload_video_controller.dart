import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("Videos").child(id);
    UploadTask uploadTask = ref.putFile(File(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File> _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("Thumbnails").child(id);
    final File thumbnailFile = await _getThumbnail(videoPath);
    UploadTask uploadTask = ref.putFile(thumbnailFile);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      // Iterate through placemarks to find the city name, as it may be available in different indexes.
      String? cityName;
      for (Placemark placemark in placemarks) {
        cityName = placemark.locality;
        if (cityName != null) {
          break; // Exit the loop if a valid city name is found.
        }
      }

      // Provide a default value if no city name is found.
      if (cityName != null && cityName.isNotEmpty) {
        return cityName;
      } else {
        return 'Unknown City';
      }
    } catch (e) {
      return 'Error getting city name';
    }
  }

  uploadVideo(String songName, String caption, String videoPath,
      Position position, BuildContext context) async {
    try {
      var allDocs = await fireStore.collection('videos').get();
      DocumentSnapshot userDoc =
          await fireStore.collection('users').doc(userPhoneNumber).get();
      var userDetails = userDoc.data()! as Map<String, dynamic>;
      int len = allDocs.docs.length;
      String userName = userDetails['userName'];
      String profilePhoto = userDetails['profilePhoto'];
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);
      String cityname = 'Unknown City'; // Provide a default value
      try {
        cityname = await getCityName(position.latitude, position.longitude);
      } catch (e) {
        Utils().toastMessage(e.toString());
      }

      Video video = Video(
        username: userName,
        phonenumber: userPhoneNumber,
        id: "Video $len",
        likes: [],
        commentcount: 0,
        sharecount: 0,
        profilephoto: profilePhoto,
        songname: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        cityname: cityname,
      );
      await fireStore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      loading = false;
      Navigator.pop(context);
      Utils().showMessage("Video Uploaded Successfully");
    } catch (e) {
      loading = false;
      Utils().toastMessage(e.toString());
    }
  }
}
