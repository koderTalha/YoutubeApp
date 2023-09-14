import 'package:flutter/material.dart';
import 'package:youutbeapp/Models/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoItem videoItem;


  VideoPlayerScreen({
    super.key,
    required this.videoItem,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  bool _isplayerReady = false;
  YoutubePlayerController  _ytcontroller = YoutubePlayerController(initialVideoId: "");


  @override
  void initState() {
    _ytcontroller = YoutubePlayerController(initialVideoId: widget.videoItem.video.resourceId.videoId,
    flags: YoutubePlayerFlags(
      mute: false,
      autoPlay: true,
    )
    )..addListener(_listener);
    super.initState();
  }

  void _listener() {
    if (_isplayerReady && mounted && !_ytcontroller.value.isFullScreen) {
      //
    }
  }

  @override
  void deactivate() {
    _ytcontroller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _ytcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoItem.video.title),
      ),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 5, right: 5),
          child: YoutubePlayer(
            controller: _ytcontroller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Player is ready.');
              _isplayerReady = true;
            },
          ),
        ),
      ),
    );
  }
}
