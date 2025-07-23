import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappIcon extends StatelessWidget {
  const WhatsappIcon({super.key});

  // String formatPhone(String number) {
  //   String digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');
  //   if (!digitsOnly.startsWith("91")) {
  //     digitsOnly = "91$digitsOnly"; // for India
  //   }
  //   return digitsOnly;
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Image.asset(
          "assets/whatsapp.png",
          height: 20,
          width: 20,
          scale: 1,
        ),
        onTap: () async {
          var contactNo = HomeProvider.homeSharedInstanace.getContactNumber;
          if (contactNo != null) {
            for (var item in contactNo) {
              print("Contact name: ${item.name}");
            }
          }
          // var rawNumber = contactNo?.first.name ?? "";
          var whatsapp = contactNo?.first.name ?? "";
          print("Whatsapp number : $whatsapp");
          if (!whatsapp.startsWith("91")) {
            whatsapp = "91$whatsapp";
          }

          whatsapp = "91$whatsapp";

          print("Whatsapp final number: $whatsapp");
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
        });
  }
}
