// Flutter imports:
import 'package:flutter/material.dart';

void showLoader(context) async => await showDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => WillPopScope(
    onWillPop: () async => true,
    child: Container(
      color: Colors.black26,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    ),
  ),
);
