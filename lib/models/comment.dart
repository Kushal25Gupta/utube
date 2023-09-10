import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String userName;
  String comment;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  List likes;
  String profilePhoto;
  String phoneNumber;
  String id;

  Comment({
    required this.userName,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.phoneNumber,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'profilePhoto': profilePhoto,
        'phoneNumber': phoneNumber,
        'id': id,
      };

  static Comment fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Comment(
      userName: snap['userName'],
      comment: snap['comment'],
      datePublished: snap['datePublished'],
      likes: snap['likes'],
      profilePhoto: snap['profilePhoto'],
      phoneNumber: snap['phoneNumber'],
      id: snap['id'],
    );
  }
}
