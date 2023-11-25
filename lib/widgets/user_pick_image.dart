
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPickImage extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  const UserPickImage(this.imagePickFn, {super.key});

  @override
  _UserPickImageState createState() => _UserPickImageState();
}

class _UserPickImageState extends State<UserPickImage> {
  File? _pickedImageFile;

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
      widget.imagePickFn(_pickedImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _pickedImageFile != null
            ? CircleAvatar(
            radius: 60, backgroundImage: FileImage(_pickedImageFile!))
            : const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text(
                'Add image \nfrom Camera',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.image_outlined),
              label: const Text(
                'Add image \nfrom Gallery',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
