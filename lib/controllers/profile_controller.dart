import 'package:utube/components/global.dart';
import 'package:get/get.dart';
import 'package:utube/components/utils/utils.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userData = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userData => _userData.value;

  Rx<String> _phoneNumber = "".obs;

  updateUserPhoneNumber(String phoneNumber) {
    _phoneNumber.value = phoneNumber;
    getUserData();
  }

  getUserData() async {
    try {
      final myVideos = await fireStore
          .collection('videos')
          .where('phonenumber', isEqualTo: _phoneNumber.value)
          .get();
      final thumbnails =
          myVideos.docs.map((doc) => doc['thumbnail'] as String).toList();
      final videoUrls =
          myVideos.docs.map((doc) => doc['videoUrl'] as String).toList();

      final userDoc =
          await fireStore.collection('users').doc(_phoneNumber.value).get();
      final userData = userDoc.data()! as dynamic;
      final username = userData['userName'];
      final profilePhoto = userData['profilePhoto'];
      int likes = 0;
      int followers = 0;
      int following = 0;
      bool isfollowing = false;

      for (var item in myVideos.docs) {
        likes += (item.data()['likes'] as List).length;
      }

      var followerDoc = await fireStore
          .collection('users')
          .doc(_phoneNumber.value)
          .collection('followers')
          .get();

      var followingDoc = await fireStore
          .collection('users')
          .doc(_phoneNumber.value)
          .collection('following')
          .get();

      followers = followerDoc.docs.length;
      following = followingDoc.docs.length;

      await fireStore
          .collection('users')
          .doc(_phoneNumber.value)
          .collection('followers')
          .doc(userPhoneNumber)
          .get()
          .then((value) {
        if (value.exists) {
          isfollowing = true;
        } else {
          isfollowing = false;
        }
      });

      _userData.value = {
        'username': username,
        'profilePhoto': profilePhoto,
        'thumbnail': thumbnails,
        'likes': likes.toString(),
        'followers': followers.toString(),
        'following': following.toString(),
        'isfollowing': isfollowing,
        'videoUrl': videoUrls,
      };
    } catch (e) {
      print('Error fetching user data: $e');
    }
    update();
  }

  followUser() async {
    var doc = await fireStore
        .collection('users')
        .doc(_phoneNumber.value)
        .collection('followers')
        .doc(userPhoneNumber)
        .get();

    if (!doc.exists) {
      await fireStore
          .collection('users')
          .doc(_phoneNumber.value)
          .collection('followers')
          .doc(userPhoneNumber)
          .set({});
      await fireStore
          .collection('users')
          .doc(userPhoneNumber)
          .collection('following')
          .doc(_phoneNumber.value)
          .set({});
      _userData.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await fireStore
          .collection('users')
          .doc(_phoneNumber.value)
          .collection('followers')
          .doc(userPhoneNumber)
          .delete();
      await fireStore
          .collection('users')
          .doc(userPhoneNumber)
          .collection('following')
          .doc(_phoneNumber.value)
          .delete();
      _userData.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _userData.value.update('isfollowing', (value) => !value);
    update();
  }

  updateUserName(String newUserName) async {
    try {
      if (newUserName == "") {
        newUserName = userPhoneNumber;
      }
      await fireStore.collection('users').doc(userPhoneNumber).update({
        'userName': newUserName,
      });
      var myVideos = await fireStore
          .collection('videos')
          .where('phonenumber', isEqualTo: userPhoneNumber)
          .get();
      for (var element in myVideos.docs) {
        await fireStore.collection('videos').doc(element.id).update(
          {
            'username': newUserName,
          },
        );
      }
      var allVideos = await fireStore.collection('videos').get();

      for (var videos in allVideos.docs) {
        var myComments = await fireStore
            .collection('videos')
            .doc(videos.id)
            .collection('comments')
            .where('phoneNumber', isEqualTo: userPhoneNumber)
            .get();
        for (var comments in myComments.docs) {
          await fireStore
              .collection('videos')
              .doc(videos.id)
              .collection('comments')
              .doc(comments.id)
              .update({
            'userName': newUserName,
          });
        }
      }

      _userData.value.update(
        'username',
        (value) => newUserName,
      );
      update();
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
    update();
  }
}
