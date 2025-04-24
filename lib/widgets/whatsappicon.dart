import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappIcon extends StatelessWidget {
  const WhatsappIcon({super.key});

  String formatPhone(String number) {
  String digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');
  if (!digitsOnly.startsWith("91")) {
    digitsOnly = "91$digitsOnly"; // for India
  }
  return digitsOnly;
}


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset(
        "assets/whatsapp.png",
        height: 20,
        width: 20,
        scale: 1,
      ),
      // onTap: () async {
      //   var contactNo = HomeProvider.homeSharedInstanace.getContactNumber;
      //   print(contactNo);
      //   print(contactNo?.first.name);
      //   var whatsapp =
      //       contactNo?.first.name?.replaceAll(RegExp(r'[^0-9]'), '') ?? "";
      //   if (!whatsapp.startsWith("91")) {
      //     whatsapp =
      //         "91$whatsapp"; // Prefix country code if missing (India example)
      //   }

      //   // var whatsapp = contactNo?.first.name??"";
      //   var whatsappurlAndroid = "whatsapp://send?phone=$whatsapp";
      //   var whatappurlIos = "https://wa.me/$whatsapp";
      //   print(whatsappurlAndroid);
      //   if (Platform.isIOS) {
      //     // for iOS phone only
      //     if (await canLaunch(whatappurlIos)) {
      //       await launch(whatappurlIos, forceSafariVC: false);
      //     } else {
      //       Fluttertoast.showToast(
      //           msg: "whatsapp not installed",
      //           toastLength: Toast.LENGTH_SHORT,
      //           gravity: ToastGravity.BOTTOM,
      //           timeInSecForIosWeb: 1,
      //           backgroundColor: Colors.black,
      //           textColor: Colors.white,
      //           fontSize: 16.0);
      //     }
      //   } else {
      //     print(whatsappurlAndroid);
      //     // android , web
      //     if (await canLaunch(whatsappurlAndroid)) {
      //       print('launcch url errroorrrrrrr');
      //       await launch(whatsappurlAndroid);
      //     } else {
      //       Fluttertoast.showToast(
      //           msg: "whatsapp not installed",
      //           toastLength: Toast.LENGTH_SHORT,
      //           gravity: ToastGravity.BOTTOM,
      //           timeInSecForIosWeb: 1,
      //           backgroundColor: Colors.black,
      //           textColor: Colors.white,
      //           fontSize: 16.0);
      //     }
      //   }
      // },
      onTap: () async {
  var contactNo = HomeProvider.homeSharedInstanace.getContactNumber;
  var rawNumber = contactNo?.first.name ?? "";
  var whatsapp = formatPhone(rawNumber);
  final message = Uri.encodeComponent("Hi, I want more info!");

  Uri uri;

  if (Platform.isIOS) {
    // iOS prefers the web-based wa.me link
    uri = Uri.parse("https://wa.me/$whatsapp?text=$message");
  } else if (Platform.isAndroid) {
    // Android may still try the custom scheme or wa.me
    uri = Uri.parse("https://wa.me/$whatsapp?text=$message");
  } else {
    Fluttertoast.showToast(msg: "Unsupported platform");
    return;
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    Fluttertoast.showToast(msg: "WhatsApp not installed");
  }
}
//       onTap: () async {
//   var contactNo = HomeProvider.homeSharedInstanace.getContactNumber;
//   var rawNumber = contactNo?.first.name ?? "";
//   var whatsapp = formatPhone(rawNumber);

//   final message = Uri.encodeComponent("Hi, I want more info!");
//   final Uri uri = Uri.parse("https://wa.me/$whatsapp?text=$message");

//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     Fluttertoast.showToast(msg: "WhatsApp not installed");
//   }
// }

    );
  }
}
