import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FixedVideo extends StatefulWidget {
  const FixedVideo({Key? key}) : super(key: key);

  @override
  State<FixedVideo> createState() => _FixedVideoState();
}

class _FixedVideoState extends State<FixedVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.play();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
 
        if (snapshot.connectionState == ConnectionState.done) {
final Size size = _controller.value.size;
return Container(
  color: Colors.lightBlue,
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.width,
  child: FittedBox(
           alignment: Alignment.center,
       fit: BoxFit.fitWidth,
       clipBehavior: Clip.hardEdge,
       child: Container(
         width: size.width,
         height: size.height,
         child: VideoPlayer(_controller))),
      );

        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
