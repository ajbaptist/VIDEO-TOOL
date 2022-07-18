import 'dart:async';
import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BetterVideoListWidget extends StatefulWidget {
  // final String videoListData;

  // const VideoListWidget(
  //     {Key? key, required this.videoListData })
  //     : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<BetterVideoListWidget> {
  late VideoPlayerController videoPlayerController;
  late BetterPlayerController betterPlayerController;
  bool _isDisposing = false;
  bool autoDispose = true;
  int duration = 00;
  bool retry = false;
  bool isAspected = false;
  double aspectRatio = 1;

  static var betterPlayerDataSource = BetterPlayerDataSource(
    BetterPlayerDataSourceType.network,
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    useAsmsSubtitles: true,
    bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 2000,
        maxBufferMs: 5000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000),
    cacheConfiguration: const BetterPlayerCacheConfiguration(
      useCache: true,
      preCacheSize: 10 * 1024 * 1024,
      maxCacheSize: 100 * 1024 * 1024,
      maxCacheFileSize: 100 * 1024 * 1024,

      ///Android only option to use cached video between app sessions
      key: "testCacheKey",
    ),
  );

  static var betterPlayerConfig = const BetterPlayerConfiguration(
      aspectRatio: 1,
      controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false, enableRetry: true));

  @override
  void initState() {
    log("working");
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _isDisposing = true;
    betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }

  Future<void> initializePlayer() async {
    betterPlayerController = BetterPlayerController(
      betterPlayerConfig,
    );

    await Future.wait([
      betterPlayerController.setupDataSource(betterPlayerDataSource),
      betterPlayerController.setVolume(mute)
    ]).then((value) {
      betterPlayerController.preCache(betterPlayerDataSource);
    });

    betterPlayerController.addEventsListener(((BetterPlayerEvent event) {
      if ((betterPlayerController.isVideoInitialized()) != null && true) {
        double aspectRatio =
            (betterPlayerController.videoPlayerController?.value.aspectRatio) ??
                1;

        betterPlayerController.setOverriddenAspectRatio(aspectRatio);

        duration = betterPlayerController
                .videoPlayerController!.value.duration!.inSeconds -
            betterPlayerController
                .videoPlayerController!.value.position.inSeconds;

        if (mounted) setState(() {});
        if (duration == 0) {
          retry = true;
        }

        if (mounted) setState(() {});

        // ignore: prefer_interpolation_to_compose_strings

      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: (betterPlayerController.isVideoInitialized()!)
            ? VisibilityDetector(
                key: Key(_getUniqueKey()),
                onVisibilityChanged: (visibilityInfo) {
                  onVisibilityChanged(visibilityInfo.visibleFraction);
                },
                child: InkWell(
                  onDoubleTap: () {
                    if ((betterPlayerController.isPlaying()!)) {
                      betterPlayerController.pause();
                    } else {
                      if (retry) {
                        betterPlayerController
                            .seekTo(const Duration(seconds: 0))
                            .then((value) {
                          retry = false;
                        });
                      } else {
                        betterPlayerController.play();
                      }
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: (betterPlayerController
                            .videoPlayerController?.value.aspectRatio) ??
                        1,
                    child: Stack(alignment: Alignment.center, children: [
                      BetterPlayer(
                        controller: betterPlayerController,
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                            onTap: () {
                              if (betterPlayerController
                                      .videoPlayerController!.value.volume ==
                                  0.0) {
                                betterPlayerController.setVolume(1.0);
                                mute = 1.0;
                              } else {
                                betterPlayerController.setVolume(0.0);
                                mute = 0.0;
                              }
                              setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              radius: 15,
                              child: Icon(
                                mute == 0.0
                                    ? Icons.volume_mute
                                    : Icons.volume_up,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 20,
                              ),
                            )),
                      ),
                      Positioned(
                          left: 10,
                          bottom: 10,
                          child: Text(
                            "00:${duration.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      AnimatedBuilder(
                        animation:
                            (betterPlayerController.videoPlayerController!),
                        builder: (_, __) => OpacityTransition(
                          visible:
                              (betterPlayerController.isPlaying()!) == false,
                          child: InkWell(
                            onTap: () {
                              if ((betterPlayerController.isPlaying()!)) {
                                betterPlayerController.pause();
                              } else {
                                if (retry) {
                                  betterPlayerController
                                      .seekTo(const Duration(seconds: 0))
                                      .then((value) {
                                    retry = false;
                                  });
                                } else {
                                  betterPlayerController.play();
                                }
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 44, 16, 16)
                                    .withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: retry
                                  ? const Icon(Icons.replay,
                                      color: Color.fromARGB(255, 255, 255, 255))
                                  : const Icon(Icons.play_arrow,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    height: 250,
                  ),
                )));
  }

  void onVisibilityChanged(double visibleFraction) async {
    final bool isPlaying = (betterPlayerController.isPlaying()!);

    if (visibleFraction >= 0.6) {
      if (!isPlaying && !_isDisposing) {
        betterPlayerController.setVolume(mute);
        mute = (betterPlayerController.videoPlayerController!.value.volume);

        setState(() {});
        if (duration != 0) {
          betterPlayerController.play();
        }
      }
    } else {
      if (isPlaying) {
        betterPlayerController.pause();
      }
    }
  }

  String _getUniqueKey() =>
      betterPlayerController.betterPlayerDataSource.hashCode.toString();
}

double mute = 0.0;
