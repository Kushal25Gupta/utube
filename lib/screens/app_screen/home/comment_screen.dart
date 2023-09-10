import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utube/components/global.dart';
import 'package:utube/controllers/comment_controller.dart';
import 'package:utube/screens/app_screen/profile/profile_screen.dart';
import 'package:timeago/timeago.dart' as tago;

// ignore: must_be_immutable
class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({required this.id, super.key});

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    if (commentController.comments.isEmpty) {
                      return Center(
                        child: Text(
                          'No Comments',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return InkWell(
                          onDoubleTap: () {
                            commentController.likeComments(comment.id);
                          },
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    phoneNumber: comment.phoneNumber),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comment.profilePhoto),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${comment.userName}  ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      tago.format(
                                        comment.datePublished.toDate(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  comment.comment,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${comment.likes.length} likes',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                commentController.likeComments(comment.id);
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color: comment.likes.contains(userPhoneNumber)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: "Comment",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    commentController.postComment(_commentController.text);
                    _commentController.clear();
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
