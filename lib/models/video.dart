import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String phonenumber;
  String id;
  List likes;
  int commentcount;
  int sharecount;
  String profilephoto;
  String songname;
  String caption;
  String videoUrl;
  String thumbnail;
  String cityname;

  Video(
      {required this.username,
      required this.phonenumber,
      required this.id,
      required this.likes,
      required this.commentcount,
      required this.sharecount,
      required this.profilephoto,
      required this.songname,
      required this.caption,
      required this.videoUrl,
      required this.thumbnail,
      required this.cityname});

  Map<String, dynamic> toJson() => {
        "username": username,
        "phonenumber": phonenumber,
        "id": id,
        "likes": likes,
        "commentcount": commentcount,
        "sharecount": sharecount,
        "profilephoto": profilephoto,
        "songname": songname,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "cityname": cityname,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    String cityname = snap['cityname'] ?? 'Error';
    return Video(
      username: snapshot['username'],
      phonenumber: snapshot['phonenumber'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentcount: snapshot['commentcount'],
      sharecount: snapshot['sharecount'],
      profilephoto: snapshot['profilephoto'],
      songname: snapshot['songname'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      thumbnail: snapshot['thumbnail'],
      cityname: cityname,
    );
  }
}
