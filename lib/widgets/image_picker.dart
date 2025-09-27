import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.onImageSelected});

  final void Function(File pickedImg) onImageSelected;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedFile;

  void pickImg() async {
    final imgPicked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 120,
    );

    if (imgPicked == null) {
      return;
    }

    setState(() {
      _pickedFile = File(imgPicked.path);
    });

    widget.onImageSelected(_pickedFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple,
          foregroundImage: _pickedFile != null ? FileImage(_pickedFile!) : null,
        ),
        TextButton(onPressed: pickImg, child: Text("Add Image")),
      ],
    );
  }
}
