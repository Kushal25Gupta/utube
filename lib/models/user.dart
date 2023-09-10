import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userName;
  String phoneNumber;
  String profilePhoto;
  String uid;

  User(
      {required this.userName,
      required this.phoneNumber,
      required this.profilePhoto,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'profilePhoto': profilePhoto,
        'uid': uid,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
      userName: snap['userName'],
      phoneNumber: snap['phoneNumber'],
      profilePhoto: snap['profilePhoto'],
      uid: snap['uid'],
    );
  }
}
