import 'package:flutter/material.dart';
import 'package:neoteric_flutter/all_properties/youtube.dart';
import 'package:neoteric_flutter/widgets/navigation_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  String url;
  YouTubeVideoPlayer({super.key, required this.url});
  @override
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  String? thumbnil;
  String? videoId;

  @override
  void initState() {
    super.initState();
    final videoUrl = widget.url;
    videoId = YoutubePlayer.convertUrlToId(videoUrl);
    thumbnil = YoutubePlayer.getThumbnail(videoId: videoId.toString());
    setState(() {

    });


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: thumbnil != null?Stack(
        alignment: Alignment.center,
        children: [
          Image.network(thumbnil.toString(),fit: BoxFit.cover,
              width: MediaQuery.of(context)
                  .size
                  .width,
              height: 200,
              loadingBuilder: (context, child,
                  loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress
                        .expectedTotalBytes !=
                        null
                        ? loadingProgress
                        .cumulativeBytesLoaded /
                        (loadingProgress
                            .expectedTotalBytes ??
                            1)
                        : null,
                  ),
                );
              }),
          InkWell(child: Image.asset("assets/video.png",height: 50,width: 50,),onTap: (){
            pushTo(context, YoutubeWudget(videoId: videoId.toString()));
          },),
        ],
      ):const CircularProgressIndicator(),
    );
  }
}