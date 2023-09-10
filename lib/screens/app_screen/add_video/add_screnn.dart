import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  AddScreen({super.key});
  late Future<Function> dialogBox;
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  displayDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.image),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Get Video from Phone Gallery',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.camera),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Make Video with Phone Camera',
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.dialogBox = displayDialogBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
