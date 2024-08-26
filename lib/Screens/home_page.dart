import 'dart:io';

import 'package:edit_nine/Screens/editing_page.dart';
import 'package:edit_nine/Screens/editing_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ImageEditingScreen2(image: image);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
              "image/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Text(
                  "Pick an Image",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        // Map<Permission, PermissionStatus> statuses = await [
                        //   Permission.storage,
                        //   Permission.camera,
                        // ].request();

                        // if (statuses[Permission.camera]!.isGranted &&
                        //     statuses[Permission.storage]!.isGranted) {
                        await _pickImage(ImageSource.gallery, context);
                        //}
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // Map<Permission, PermissionStatus> statuses = await [
                        //   Permission.storage,
                        //   Permission.camera,
                        // ].request();

                        // if (statuses[Permission.camera]!.isGranted &&
                        //     statuses[Permission.storage]!.isGranted) {
                        await _pickImage(ImageSource.camera, context);
                        // }
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Camera",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    builder: (_) {
                      return Center(
                        child: Text(
                          "Save Image",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text("Press"),
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
