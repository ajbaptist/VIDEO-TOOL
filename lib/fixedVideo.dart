import 'dart:developer';

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
  bool isFulled = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Size size = _controller.value.size;
          log("aspect----->${_controller.value.aspectRatio}");
          return Column(
            children: [
              AspectRatio(
                aspectRatio: !isFulled ? 1 : _controller.value.aspectRatio,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.lightBlue,
                  child: FittedBox(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                          width: size.width,
                          height: size.height,
                          child: VideoPlayer(_controller))),
                ),
              ),
              IconButton(
                  onPressed: () {
                    isFulled = !isFulled;
                    setState(() {});
                  },
                  icon: Icon(Icons.abc_rounded))
            ],
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
