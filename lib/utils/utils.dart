import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neoteric_flutter/widgets/choose_file_widget.dart';

Future<File?> chooseSourceSheet(
    BuildContext context, bool img, File? file,String type) async {
  await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChooseFileWidget(
            title: "Camera",
            function: () async {
              final choosen = await choosecameraFile(img,type);
              if (choosen != null) setState(() => file = choosen);
              Navigator.pop(context);
            },
            icon: Icons.camera_outlined,
            size: MediaQuery.of(context).size.width / 10,
          ),
          ChooseFileWidget(
            title: "Gallery",
            function: () async {
              final choosen = await choosegalleryFile(img,type);
              if (choosen != null) setState(() => file = choosen);
              Navigator.pop(context);
            },
            icon: Icons.image_outlined,
            size: MediaQuery.of(context).size.width / 10,
          ),
        ],
      ),
    ),
  );
  return file;
}