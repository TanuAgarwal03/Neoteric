import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ChooseFileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() function;
  final double size;

  const ChooseFileWidget({
    super.key,
    required this.icon,
    required this.function,
    required this.title,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: InkWell(
        onTap: function,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: width / 5,
          width: width / 5,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: const Color(0xFFFF3803), size:size),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFFFF3803),
                    fontSize: width / 30,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Future<File?> choosecameraFile(bool image,String type) async {
  final imgPicker = ImagePicker();
  late XFile? choosenFile;
  image
      ? choosenFile =
  await imgPicker.pickImage(source: ImageSource.camera)
      : type=="post"?choosenFile = await imgPicker.pickVideo(source: ImageSource.camera,maxDuration: const Duration(seconds: 300))
  :choosenFile = await imgPicker.pickVideo(source: ImageSource.camera);
  if (choosenFile != null) return File(choosenFile.path);
  return null;
}





Future<File?> choosegalleryFile(bool image,String type) async {
  final imgPicker = ImagePicker();
  late XFile? choosenFile;
  image
      ? choosenFile =
  await imgPicker.pickImage(source: ImageSource.gallery)
      : choosenFile = await imgPicker.pickVideo(source: ImageSource.gallery);
  if (choosenFile != null) return File(choosenFile.path);
  return null;
}

