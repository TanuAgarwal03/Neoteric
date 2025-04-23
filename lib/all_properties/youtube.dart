import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeWudget extends StatefulWidget {
  String videoId;
  YoutubeWudget({super.key, required this.videoId});

  @override
  State<YoutubeWudget> createState() => _YoutubeState();
}

class _YoutubeState extends State<YoutubeWudget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
          autoPlay: true, mute: false, showLiveFullscreenButton: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Expanded(
                      child: YoutubePlayer(
                        controller: _controller,
                        topActions: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                            SystemChrome.setPreferredOrientations(
                                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

                          }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,))
                        ],
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                        onReady: () {
                          _controller.addListener(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
