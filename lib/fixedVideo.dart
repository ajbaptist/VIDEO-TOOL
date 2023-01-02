import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class FixedVideo extends StatefulWidget {
  const FixedVideo({Key? key}) : super(key: key);

  @override
  State<FixedVideo> createState() => _FixedVideoState();
}

class _FixedVideoState extends State<FixedVideo> {
  late VideoPlayerController _controller;

  bool isFulled = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    );

    _controller.initialize();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_controller.value.isInitialized) {
          final Size size = _controller.value.size;

          return AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              child: FittedBox(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: VideoPlayer(_controller))),
            ),
          );
        } else {
          return Shimmer(
              child: AspectRatio(aspectRatio: 1),
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ));
        }
      },
    );
  }
}
