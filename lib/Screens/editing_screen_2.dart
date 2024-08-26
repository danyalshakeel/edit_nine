import 'dart:io';
import 'dart:ui';

import 'package:edit_nine/Screens/filter_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageEditingScreen2 extends StatefulWidget {
  final File image;

  ImageEditingScreen2({super.key, required this.image});

  @override
  State<ImageEditingScreen2> createState() => _ImageEditingScreen2State();
}

class _ImageEditingScreen2State extends State<ImageEditingScreen2> {
  late File _editableImage;
  List<EnhancedTextInfo> _texts = [];
  ColorFilter? _appliedFilter;

  @override
  void initState() {
    super.initState();
    _editableImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: 200,
            width: 200,
            child: ColorFiltered(
              colorFilter: _appliedFilter ??
                  ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: Image.file(
                _editableImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ..._buildTexts(),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Row(
              children: [
                _buildToolButton(
                  icon: CupertinoIcons.color_filter,
                  onTap: _applyFilter,
                ),
                const SizedBox(width: 20),
                _buildToolButton(
                  icon: Icons.text_fields_outlined,
                  onTap: _addNewText,
                ),
                const SizedBox(width: 20),
                _buildToolButton(
                  icon: CupertinoIcons.crop_rotate,
                  onTap: _cropImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(
      {required IconData icon, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTexts() {
    return _texts.map((textInfo) {
      return Positioned(
        left: textInfo.position.dx,
        top: textInfo.position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              textInfo.position += details.delta;
            });
          },
          onTap: () => _editText(textInfo),
          child: Text(
            textInfo.text,
            style: TextStyle(
              color: textInfo.color,
              fontSize: textInfo.fontSize,
              fontWeight: textInfo.fontWeight,
              fontStyle: textInfo.fontStyle,
              backgroundColor: textInfo.backgroundColor,
              shadows:
                  textInfo.textShadow != null ? [textInfo.textShadow!] : null,
              foreground: textInfo.textGradient != null
                  ? (Paint()..shader = textInfo.textGradient)
                  : null,
            ),
            textAlign: textInfo.alignment,
          ),
        ),
      );
    }).toList();
  }

  void _addNewText() {
    setState(() {
      _texts.add(EnhancedTextInfo(
        text: "New Text",
        position: Offset(100, 100),
        color: Colors.white,
        fontSize: 24,
        alignment: TextAlign.left,
        fontWeight: FontWeight.bold,
      ));
    });
  }

  void _editText(EnhancedTextInfo textInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newText = textInfo.text;
        Color newColor = textInfo.color;
        double newFontSize = textInfo.fontSize;
        FontWeight newFontWeight = textInfo.fontWeight;
        FontStyle newFontStyle = textInfo.fontStyle;
        TextAlign newAlignment = textInfo.alignment;
        return AlertDialog(
          title: Text("Edit Text"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newText = value;
                },
                controller: TextEditingController(text: textInfo.text),
                decoration: InputDecoration(hintText: "Enter text"),
              ),
              SizedBox(height: 10),
              _buildFontSizeSlider(newFontSize, (value) {
                setState(() {
                  newFontSize = value;
                });
              }),
              SizedBox(height: 10),
              _buildFontWeightSelector(newFontWeight, (value) {
                setState(() {
                  newFontWeight = value!;
                });
              }),
              SizedBox(height: 10),
              _buildFontStyleSelector(newFontStyle, (value) {
                setState(() {
                  newFontStyle = value!;
                });
              }),
              SizedBox(height: 10),
              _buildTextAlignSelector(newAlignment, (value) {
                setState(() {
                  newAlignment = value!;
                });
              }),
              SizedBox(height: 10),
              _buildColorPicker(newColor, (color) {
                setState(() {
                  newColor = color;
                });
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  textInfo.text = newText;
                  textInfo.color = newColor;
                  textInfo.fontSize = newFontSize;
                  textInfo.fontWeight = newFontWeight;
                  textInfo.fontStyle = newFontStyle;
                  textInfo.alignment = newAlignment;
                });
                Navigator.of(context).pop();
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFontSizeSlider(double fontSize, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Text("Font Size"),
        Expanded(
          child: Slider(
            value: fontSize,
            min: 8.0,
            max: 72.0,
            divisions: 64,
            label: fontSize.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFontWeightSelector(
      FontWeight fontWeight, ValueChanged<FontWeight?> onChanged) {
    return Row(
      children: [
        Text("Font Weight"),
        DropdownButton<FontWeight>(
          value: fontWeight,
          items: FontWeight.values.map((weight) {
            return DropdownMenuItem<FontWeight>(
              value: weight,
              child: Text(weight.toString().split('.').last),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFontStyleSelector(
      FontStyle fontStyle, ValueChanged<FontStyle?> onChanged) {
    return Row(
      children: [
        Text("Font Style"),
        DropdownButton<FontStyle>(
          value: fontStyle,
          items: FontStyle.values.map((style) {
            return DropdownMenuItem<FontStyle>(
              value: style,
              child: Text(style.toString().split('.').last),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextAlignSelector(
      TextAlign alignment, ValueChanged<TextAlign?> onChanged) {
    return Row(
      children: [
        Text("Alignment"),
        DropdownButton<TextAlign>(
          value: alignment,
          items: TextAlign.values.map((align) {
            return DropdownMenuItem<TextAlign>(
              value: align,
              child: Text(align.toString().split('.').last),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorPicker(Color color, ValueChanged<Color> onColorChanged) {
    return Row(
      children: [
        Text("Text Color"),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            Color? pickedColor = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Pick Color"),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: color,
                    onColorChanged: onColorChanged,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            if (pickedColor != null) {
              onColorChanged(pickedColor);
            }
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _applyFilter() async {
    final selectedFilter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(selectedImage: _editableImage),
      ),
    );
    if (selectedFilter != null) {
      setState(() {
        _appliedFilter = selectedFilter;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_editableImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: _editableImage.path,
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
            ],
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _editableImage = File(croppedImage.path);
        });
      }
    }
  }
}

class EnhancedTextInfo {
  String text;
  Offset position;
  Color color;
  double fontSize;
  TextAlign alignment;
  FontWeight fontWeight;
  FontStyle fontStyle;
  Color? backgroundColor;
  BoxShadow? textShadow;
  Shader? textGradient;

  EnhancedTextInfo({
    required this.text,
    required this.position,
    required this.color,
    required this.fontSize,
    this.alignment = TextAlign.left,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.backgroundColor,
    this.textShadow,
    this.textGradient,
  });
}
