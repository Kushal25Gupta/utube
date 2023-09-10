import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoPlayerItem extends StatefulWidget {
  VideoPlayerItem({required this.videoUrl, super.key});
  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool isplaying = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    videoPlayerController.initialize().then((_) {
      // Ensure the first frame is shown before playing
      setState(() {});
      videoPlayerController.play();
      videoPlayerController.setVolume(1);
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying && !isplaying) {
          Future.delayed(Duration(milliseconds: 100), () {
            videoPlayerController.play();
            isplaying = true;
          });
        }
      });
      videoPlayerController.setLooping(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if (!videoPlayerController.value.isPlaying) {
          setState(() {
            videoPlayerController.play();
            isplaying = true;
          });
        }
      },
      onLongPress: () {
        if (videoPlayerController.value.isPlaying) {
          setState(() {
            videoPlayerController.pause();
            isplaying = false;
          });
        } else {
          setState(() {
            videoPlayerController.play();
            isplaying = true;
          });
        }
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }

  @override
  void dispose() {
    // Stop the video and release resources when the page is disposed.
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
  }
}
