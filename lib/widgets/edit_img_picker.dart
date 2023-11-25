import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



// ignore: must_be_immutable
class EditPickImage extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;
  String imageUrl;
  EditPickImage(this.imagePickFn, this.imageUrl, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditPickImageState createState() => _EditPickImageState();
}

class _EditPickImageState extends State<EditPickImage> {
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
  }

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
            : CachedNetworkImage(
          imageUrl: widget.imageUrl,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 60,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => const CircularProgressIndicator(
            color: Colors.orangeAccent,
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error_outline_rounded,
            color: Colors.deepOrangeAccent,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text(
                'Add image \nfrom Camera',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
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
