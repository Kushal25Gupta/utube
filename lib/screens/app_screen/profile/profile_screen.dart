// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/controllers/profile_controller.dart';
import 'package:utube/components/widgets/dialog.dart';
import 'package:utube/screens/app_screen/profile/thumbnail_video_screen.dart';
import 'package:utube/screens/authentication/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfileScreen extends StatefulWidget {
  final String phoneNumber;
  const ProfileScreen({required this.phoneNumber, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController profileController = Get.put(ProfileController());
  final TextEditingController userNameTextEditingController =
      TextEditingController();
  bool _showSpinner = false;
  bool isChangingUserName = false;

  @override
  void initState() {
    super.initState();
    profileController.updateUserPhoneNumber(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final userData = profileController.userData;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: GetBuilder<ProfileController>(
        init: profileController,
        builder: (controller) {
          if (controller.userData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: isChangingUserName == true
                ? AppBar(
                    leading: const Icon(Icons.person_add_alt_1_outlined),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (!userNameTextEditingController.text.isEmpty) {
                            controller.updateUserName(
                                userNameTextEditingController.text);
                            setState(() {
                              isChangingUserName = false;
                            });
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    title: TextFormField(
                      controller: userNameTextEditingController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Enter New User Name',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onChanged: (value) {
                        userNameTextEditingController.text = value;
                      },
                    ),
                  )
                : AppBar(
                    leading: const Icon(Icons.person_add_alt_1_outlined),
                    actions: const [
                      Icon(Icons.more_horiz_outlined),
                    ],
                    title: InkWell(
                      onTap: () {
                        if (widget.phoneNumber == userPhoneNumber) {
                          setState(() {
                            isChangingUserName = true;
                          });
                        }
                      },
                      child: Text(
                        controller.userData['username'] ?? 'Default Username',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        Center(
                          child: ClipOval(
                            child: InkWell(
                              onTap: () async {
                                if (widget.phoneNumber == userPhoneNumber) {
                                  await DialogPopUp(
                                    onProfileImageUpdated: (imageUrl) {
                                      // Update the profile image URL in the ProfileScreen
                                      profileController
                                          .userData['profilePhoto'] = imageUrl;
                                      // Notify listeners that the data has changed
                                      profileController.update();
                                    },
                                  ).displayDialogBox(context, false);

                                  await profileController.updateUserPhoneNumber(
                                      widget.phoneNumber);
                                }
                              },
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.userData['profilePhoto'] ??
                                    "Default profilephoto",
                                height: 100,
                                width: 100,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  controller.userData['following'] ?? "Error",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              children: [
                                Text(
                                  controller.userData['followers'] ?? "Error",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              children: [
                                Text(
                                  controller.userData['likes'] ?? "Error",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white24,
                        ),
                        onPressed: () async {
                          if (widget.phoneNumber == userPhoneNumber) {
                            try {
                              await firebaseAuth.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            } catch (e) {
                              Utils().toastMessage("Error signing out: $e");
                            }
                          } else {
                            controller.followUser();
                          }
                        },
                        child: Text(
                          widget.phoneNumber == userPhoneNumber
                              ? 'Sign Out'
                              : controller.userData['isfollowing']
                                  ? 'Unfollow'
                                  : 'Follow',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Visibility(
                      visible: controller.userData['thumbnail'] != null &&
                          controller.userData['thumbnail'] is List,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.userData['thumbnail'].length ?? 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.5,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          final thumbnail =
                              controller.userData['thumbnail'][index];
                          if (thumbnail != null) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ThumbailVideoScreen(
                                      videoUrl: controller.userData['videoUrl']
                                              [index] ??
                                          "error",
                                    ),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: thumbnail,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
