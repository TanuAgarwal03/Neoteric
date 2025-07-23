import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neoteric_flutter/screens/home_screen.dart';
// import 'package:neoteric_flutter/screens/login_screen.dart';
import 'package:neoteric_flutter/screens/welcome_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  String fcmToken;
  SplashScreen({super.key, required this.fcmToken});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash.mp4");
    _controller?.initialize().then((value) async {
      await _controller?.setVolume(0);
      await _controller?.play();
    });
    checkFirstSeen();
  }
  //final userData;

  void checkFirstSeen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("get_preference_data===");
    print(pref.getString("is_login"));
    // print(pref.getString("user_id"));
    String? checkLogin = pref.getString("is_login");
    print("get_log===");
    print(checkLogin);

    print('check_token== ${widget.fcmToken}');
    pref.setString("fcmToken", widget.fcmToken);

    Timer(
        const Duration(seconds: 4),
        () => checkLogin == "true"
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: VideoPlayer(_controller!)),
    );
  }
}
