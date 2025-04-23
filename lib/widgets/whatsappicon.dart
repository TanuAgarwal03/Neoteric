import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappIcon extends StatelessWidget {
  const WhatsappIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(child: Image.asset(
      "assets/whatsapp.png",
      height: 20,
      width: 20,
      scale: 1,
    ),onTap: ()async{
      var contactNo=HomeProvider.homeSharedInstanace.getContactNumber;
      var whatsapp = contactNo?.first.name??"";
      var whatsappurlAndroid =
          "whatsapp://send?phone=$whatsapp";
      var whatappurlIos =
          "https://wa.me/$whatsapp";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappurlIos)) {
      await launch(whatappurlIos, forceSafariVC: false);
      } else {
          Fluttertoast.showToast(
              msg: "whatsapp no installed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
      }
      } else {
      print(whatsappurlAndroid);
      // android , web
      if (await canLaunch(whatsappurlAndroid)) {
      await launch(whatsappurlAndroid);
      } else {
        Fluttertoast.showToast(
            msg: "whatsapp no installed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      }
    },);
  }
}
