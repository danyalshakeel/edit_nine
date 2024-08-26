import 'dart:io';

import 'package:edit_nine/Screens/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

// ignore: must_be_immutable
class ImageEditScreen extends StatefulWidget {
  final File image;
  String? path;

  ImageEditScreen({required this.image});

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late File _editableImage;
  ColorFilter? _appliedFilter;

  @override
  void initState() {
    super.initState();
    _editableImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Image"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // TODO: Implement save functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: ColorFiltered(
                colorFilter: _appliedFilter ??
                    ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                child: Image.file(
                  _editableImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () async {
                    final selectedFilter = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FilterScreen(selectedImage: _editableImage),
                      ),
                    );
                    if (selectedFilter != null) {
                      setState(() {
                        _appliedFilter = selectedFilter;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.text_fields),
                  onPressed: () {
                    // TODO: Implement add text functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    // TODO: Implement add emoji functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.crop_rotate),
                  onPressed: () async {
                    await _cropImage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement undo functionality
                },
                child: Text("Undo"),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement redo functionality
                },
                child: Text("Redo"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _handlePermissionsAndCropImage() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //     Permission.camera,
  //     Permission.photos,
  //   ].request();

  //   if (statuses[Permission.camera]!.isGranted &&
  //       statuses[Permission.storage]!.isGranted &&
  //       statuses[Permission.photos]!.isGranted) {
  //     await _cropImage();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Permissions not granted.')),
  //     );
  //   }
  // }

  Future<void> _cropImage() async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: _editableImage.path,
      //  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            statusBarColor: Colors.transparent,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black,
            activeControlsWidgetColor: Colors.blue,
            cropFrameColor: Colors.white,
            cropGridColor: Colors.white.withOpacity(0.7),
            cropFrameStrokeWidth: 3,
            showCropGrid: true,
            lockAspectRatio: false,
            cropStyle: CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio16x9,
            ]),
      ],
    );

    if (croppedImage != null) {
      setState(() {
        _editableImage = File(croppedImage.path);
      });
    }
  }
}
