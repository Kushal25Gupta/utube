import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:utube/models/user.dart';

class SearchControllerClass extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final Rx<List<User>> _searchedVideo = Rx<List<User>>([]);
  List<User> get searchedVideo => _searchedVideo.value;

  searchVideo(String typedUser) async {
    _searchedVideo.bindStream(firestore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> retVal = [];
      for (var elements in query.docs) {
        retVal.add(User.fromSnap(elements));
      }
      return retVal;
    }));
  }
}
