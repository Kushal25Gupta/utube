import 'package:flutter/material.dart';
import 'package:utube/screens/app_screen/library/library_screen.dart';
import 'package:utube/screens/app_screen/profile/profile_screen.dart';
import 'package:utube/screens/app_screen/search/search_screen.dart';
import 'package:utube/components/widgets/upload_icon.dart';
import 'package:utube/screens/app_screen/add_video/upload_video_screen.dart';
import 'package:utube/screens/app_screen/home/video_screen.dart';
import 'package:utube/components/global.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'ViewScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenindex = 0;
  List screenList = [
    VideoScreen(),
    SearchScreen(),
    UploadVideoScreen(),
    LibraryScreen(),
    ProfileScreen(phoneNumber: userPhoneNumber),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              screenindex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black38,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white38,
          currentIndex: screenindex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: UploadCustomIcon(),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.video_library_rounded,
                size: 30,
              ),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: "Profile",
            ),
          ],
        ),
        body: screenList[screenindex],
      ),
    );
  }
}
