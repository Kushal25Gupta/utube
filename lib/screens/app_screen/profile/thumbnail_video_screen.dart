import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/widgets/circleanimation.dart';
import 'package:utube/controllers/thumbnail_video_controller.dart';
import 'package:utube/screens/app_screen/home/comment_screen.dart';
import 'package:utube/screens/app_screen/home/video_player_item.dart';
import 'package:utube/components/widgets/profile_photo.dart';
import 'package:utube/screens/app_screen/profile/profile_screen.dart';

class ThumbailVideoScreen extends StatefulWidget {
  final String videoUrl;
  const ThumbailVideoScreen({required this.videoUrl, super.key});

  @override
  State<ThumbailVideoScreen> createState() => _ThumbailVideoScreenState();
}

class _ThumbailVideoScreenState extends State<ThumbailVideoScreen> {
  late ThumbnailVideoController videoController =
      Get.put(ThumbnailVideoController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController.setVideoUrl(widget.videoUrl);
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        if (videoController.videoList.isEmpty) {
          return const Center(
            child: Text(
              'No Videos Available',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                InkWell(
                  onDoubleTap: () => videoController.likeVideos(data.id),
                  child: VideoPlayerItem(videoUrl: data.videoUrl),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.username,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    data.caption,
                                    maxLines: 5,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_sharp,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      Text(
                                        data.cityname ?? 'Unknown City',
                                        maxLines: 5,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      Text(
                                        data.songname,
                                        maxLines: 5,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                            phoneNumber: data.phonenumber,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProfilePhoto(
                                        profilePhoto: data.profilephoto)),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          videoController.likeVideos(data.id),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color:
                                            data.likes.contains(userPhoneNumber)
                                                ? Colors.red
                                                : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                              id: data.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.commentcount.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.sharecount.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicAlbum(data.profilephoto),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }
}
