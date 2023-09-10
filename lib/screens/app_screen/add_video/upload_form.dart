import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:utube/components/widgets/input_text_widget.dart';
import 'package:utube/controllers/upload_video_controller.dart';
import 'package:geolocator/geolocator.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const UploadForm(
      {required this.videoFile, required this.videoPath, super.key});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  late VideoPlayerController playerController;
  late Position position;
  TextEditingController artistSongTextEditingController =
      TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true; // Permission granted
    } else {
      return false; // Permission denied
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = false;
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController.initialize();
    playerController.play();
    playerController.setVolume(1);
    playerController.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        setState(() {
          loading = false;
        });
        return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: VideoPlayer(playerController),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: [
                    //artist-song
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: InputTextWidget(
                        textEditingController: artistSongTextEditingController,
                        labelString: "Song",
                        iconData: Icons.music_note,
                        isObscure: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: InputTextWidget(
                        textEditingController: descriptionTextEditingController,
                        labelString: "Caption",
                        iconData: Icons.closed_caption,
                        isObscure: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 38,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final permissionGranted =
                              await requestLocationPermission();
                          if (permissionGranted) {
                            try {
                              setState(() {
                                loading = true;
                              });
                              position = await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.medium);

                              try {
                                await uploadVideoController.uploadVideo(
                                    artistSongTextEditingController.text,
                                    descriptionTextEditingController.text,
                                    widget.videoPath,
                                    position,
                                    context);
                                setState(() {
                                  loading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                  Utils().toastMessage(
                                      "Upload Failed - try again later");
                                });
                              }
                            } catch (e) {
                              setState(() {
                                loading = false;
                              });
                              Utils().toastMessage("Can't Access Location");
                            }
                          } else {
                            setState(() {
                              loading = false;
                            });
                            Utils().toastMessage("Location permission denied");
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Upload Now",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    playerController.dispose();
    super.dispose();
  }
}
