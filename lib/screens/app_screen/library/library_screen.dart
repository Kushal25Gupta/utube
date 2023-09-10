import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utube/controllers/library_video_controller.dart';
import 'package:utube/screens/app_screen/home/video_player_item.dart';
import 'package:utube/components/widgets/profile_photo.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({super.key});
  final LibraryVideoController videoController =
      Get.put(LibraryVideoController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Videos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        body: Obx(
          () {
            if (videoController.videoList.isEmpty) {
              return const Center(
                child: Text(
                  'No Videos Uploaded',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return PageView.builder(
                itemCount: videoController.videoList.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final data = videoController.videoList[index];
                  return Stack(
                    children: [
                      VideoPlayerItem(videoUrl: data.videoUrl),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ProfilePhoto(
                                                profilePhoto:
                                                    data.profilephoto),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Text(
                                                data.username,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          data.caption,
                                          maxLines: 5,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
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
                                        const SizedBox(
                                          height: 5.0,
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
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
