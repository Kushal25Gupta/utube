import 'package:flutter/material.dart';
import 'package:utube/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:utube/models/user.dart';
import 'package:utube/screens/app_screen/profile/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchControllerClass searchController =
      Get.put(SearchControllerClass());
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.red,
            title: TextFormField(
                controller: _searchTextEditingController,
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onFieldSubmitted: (value) {
                  searchController.searchVideo(value);
                  _searchTextEditingController.clear();
                }),
          ),
          body: searchController.searchedVideo.isEmpty
              ? const Center(
                  child: Text(
                    'Search for users!',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: searchController.searchedVideo.length,
                  itemBuilder: (context, index) {
                    if (searchController.searchedVideo.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Videos Found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      );
                    }
                    User user = searchController.searchedVideo[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              phoneNumber: user.phoneNumber,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePhoto),
                        ),
                        title: Text(
                          user.userName,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
