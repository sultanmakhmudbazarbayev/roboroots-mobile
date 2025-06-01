import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:roboroots/api/course_service.dart';

class VideoPlayerWidget extends StatefulWidget {
  final int lessonId;
  final String videoUrl;
  final VoidCallback? onSkipPrevious;
  final VoidCallback? onSkipNext;
  final bool hasPrevious;
  final bool hasNext;

  const VideoPlayerWidget({
    Key? key,
    required this.lessonId,
    required this.videoUrl,
    this.onSkipPrevious,
    this.onSkipNext,
    this.hasPrevious = false,
    this.hasNext = false,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isBuffering = false;
  bool _hasEnded = false;
  double _lastSavedProgress = 0.0;

  void pause() {
    _videoPlayerController?.pause();
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(String url) async {
    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();

    _videoPlayerController!.addListener(() {
      final controllerValue = _videoPlayerController!.value;
      final isPlaying = controllerValue.isPlaying;
      final buffering = controllerValue.isBuffering;

      // Buffering indicator
      if (buffering != _isBuffering) {
        setState(() => _isBuffering = buffering);
      }

      // Track end
      _videoListener();

      // Periodically save progress every 10%
      if (isPlaying && controllerValue.duration.inMilliseconds > 0) {
        final pos = controllerValue.position.inMilliseconds;
        final dur = controllerValue.duration.inMilliseconds;
        final fraction = pos / dur;
        if ((fraction - _lastSavedProgress).abs() >= 0.1) {
          _lastSavedProgress = fraction;
          CourseService()
              .saveLessonProgress(widget.lessonId, fraction)
              .catchError((e) => debugPrint('Save progress failed: $e'));
        }
      }
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
    );

    setState(() {
      _hasEnded = false;
    });
  }

  void _videoListener() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) return;

    final pos = _videoPlayerController!.value.position;
    final dur = _videoPlayerController!.value.duration;
    if (!_hasEnded && pos >= dur) {
      _hasEnded = true;
      if (widget.hasNext && widget.onSkipNext != null) {
        widget.onSkipNext!();
      } else {
        _videoPlayerController!.pause();
      }
    }
  }

  Future<void> loadVideoUrl(String newUrl) async {
    _videoPlayerController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    setState(() => _hasEnded = false);
    await _initializeVideo(newUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _videoPlayerController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            Chewie(controller: _chewieController!),
            if (_isBuffering)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_previous, color: Colors.white70),
                  onPressed: widget.hasPrevious ? widget.onSkipPrevious : null,
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next, color: Colors.white70),
                  onPressed: widget.hasNext ? widget.onSkipNext : null,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 200,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
