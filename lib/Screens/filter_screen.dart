import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FilterScreen extends StatefulWidget {
  final File selectedImage;

  FilterScreen({super.key, required this.selectedImage});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  ColorFilter? _currentFilter;
  Color _filterColor = Colors.transparent;

  final List<ColorFilter> _filters = [
    // Original Filter (No filter)
    const ColorFilter.mode(Colors.transparent, BlendMode.multiply),

    // Vivid Filters
    const ColorFilter.matrix([
      1.2, 0.2, 0.2, 0, 0, // Red
      0.2, 1.2, 0.2, 0, 0, // Green
      0.2, 0.2, 1.2, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ]), // Vivid
    const ColorFilter.mode(Color(0xFFFFE0B2), BlendMode.modulate), // Vivid Warm
    const ColorFilter.mode(Color(0xFFB2EBF2), BlendMode.modulate), // Vivid Cool

    // Dramatic Filters
    const ColorFilter.matrix([
      1.3, -0.3, -0.3, 0, 0, // Red
      -0.3, 1.3, -0.3, 0, 0, // Green
      -0.3, -0.3, 1.3, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ]), // Dramatic
    const ColorFilter.mode(Color(0xFFFFE0B2), BlendMode.hue), // Dramatic Warm
    const ColorFilter.mode(Color(0xFFB2EBF2), BlendMode.hue), // Dramatic Cool

    // Mono Filters
    const ColorFilter.matrix([
      0.33, 0.33, 0.33, 0, 0, // Red
      0.33, 0.33, 0.33, 0, 0, // Green
      0.33, 0.33, 0.33, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ]), // Mono
    const ColorFilter.mode(Color(0xFFBFBFBF), BlendMode.modulate), // Silvertone
    const ColorFilter.mode(Color(0xFF333333), BlendMode.multiply), // Noir

    // Tonal Filters
    const ColorFilter.mode(Color(0xFFAAAAAA), BlendMode.modulate), // Tonal
    const ColorFilter.mode(Color(0xFFE0E0E0), BlendMode.lighten), // Fade

    // Transfer Filters
    const ColorFilter.mode(Color(0xFFB794F4), BlendMode.modulate), // Transfer
    const ColorFilter.mode(Color(0xFFD1C4E9), BlendMode.modulate), // Instant
    const ColorFilter.mode(Color(0xFFB3E5FC), BlendMode.color), // Process
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 250, 249),
      appBar: AppBar(
        title: const Text('Filter Screen'),
        backgroundColor: Color.fromARGB(255, 213, 236, 234),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, _currentFilter); // Return selected filter
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 400,
            height: 500,
            // color: Colors.amber,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ColorFiltered(
                colorFilter: _currentFilter ??
                    const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply),
                child: Image.file(
                  widget.selectedImage,
                  fit: BoxFit.cover,
                  width: 300,
                  height: 500,
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            //color: Colors.amber,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.2),
              border: Border.all(color: Colors.black),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 120,
            child: _filterList(),
          ),
          const SizedBox(height: 60),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.color_lens),
      //   onPressed: _showColorPicker, // Show color picker
      // ),
    );
  }

  Widget _filterList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _filters.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              _currentFilter = _filters[index];
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: ColorFiltered(
                colorFilter: _filters[index],
                child: Image.file(
                  widget.selectedImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _filterColor,
              onColorChanged: (color) {
                setState(() {
                  _filterColor = color;
                  _currentFilter =
                      ColorFilter.mode(_filterColor, BlendMode.modulate);
                });
              },
              showLabel: true,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
