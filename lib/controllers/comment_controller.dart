import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = "";
  updatePostId(String id) {
    _postId = id;
    getComments();
  }

  getComments() async {
    _comments.bindStream(
      fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retVal = [];
          for (var element in query.docs) {
            retVal.add(Comment.fromSnap(element));
          }
          return retVal;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc =
            await fireStore.collection('users').doc(userPhoneNumber).get();
        var userData = userDoc.data()! as dynamic;
        var allDocs = await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
          userName: userData['userName'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: userData['profilePhoto'],
          phoneNumber: userPhoneNumber,
          id: 'Comment $len',
        );

        await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());
      }

      DocumentSnapshot doc =
          await fireStore.collection('videos').doc(_postId).get();
      await fireStore.collection('videos').doc(_postId).update({
        'commentcount': (doc.data()! as dynamic)['commentcount'] + 1,
      });
      Utils().showMessage("Comment Added Successfully");
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  likeComments(String id) async {
    DocumentSnapshot snapshot = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
    var commentData = (snapshot.data()! as dynamic);
    if (commentData['likes'].contains(userPhoneNumber)) {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([userPhoneNumber]),
      });
    } else {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([userPhoneNumber]),
      });
    }
  }
}
