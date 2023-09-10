import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/models/video.dart';
import 'package:utube/components/global.dart';

class ThumbnailVideoController extends GetxController {
  late String videoUrl = "";
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  setVideoUrl(String videoUrl) {
    videoUrl = videoUrl;
    _videoList.bindStream(fireStore
        .collection('videos')
        .where('videoUrl', isEqualTo: videoUrl)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }

  likeVideos(String id) async {
    DocumentSnapshot doc = await fireStore.collection('videos').doc(id).get();
    try {
      if ((doc.data()! as dynamic)['likes'].contains(userPhoneNumber)) {
        await fireStore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayRemove([userPhoneNumber]),
        });
      } else {
        await fireStore.collection('videos').doc(id).update({
          'likes': FieldValue.arrayUnion([userPhoneNumber]),
        });
      }
    } catch (e) {
      Utils().toastMessage("Liking failed due to server");
    }
  }
}
