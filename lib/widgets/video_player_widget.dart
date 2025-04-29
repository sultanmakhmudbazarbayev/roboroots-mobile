import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onSkipPrevious;
  final VoidCallback? onSkipNext;
  final bool hasPrevious;
  final bool hasNext;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.onSkipPrevious,
    this.onSkipNext,
    this.hasPrevious = false,
    this.hasNext = false,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

// RENAMED to public class: VideoPlayerWidgetState
class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isBuffering = false;
  bool _hasEnded = false;

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

  /// Re-initialize the video with a new URL if needed.
  Future<void> _initializeVideo(String url) async {
    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();

    // Listen for buffering status.
    _videoPlayerController!.addListener(() {
      final isPlaying = _videoPlayerController!.value.isPlaying;
      final controllerBuffering = _videoPlayerController!.value.isBuffering;
      if (isPlaying) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_videoPlayerController!.value.isPlaying && _isBuffering) {
            setState(() => _isBuffering = false);
          }
        });
      } else {
        if (controllerBuffering != _isBuffering) {
          setState(() => _isBuffering = controllerBuffering);
        }
      }
    });

    _hasEnded = false;
    _videoPlayerController!.addListener(_videoListener);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
    );
    setState(() {});
  }

  /// Called each frame; checks if video ended & calls onSkipNext if it exists.
  void _videoListener() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) return;

    final position = _videoPlayerController!.value.position;
    final duration = _videoPlayerController!.value.duration;
    if (!_hasEnded && position >= duration) {
      _hasEnded = true;
      // If there's a next video, skip automatically; else just pause
      if (widget.hasNext && widget.onSkipNext != null) {
        widget.onSkipNext!();
      } else {
        _videoPlayerController!.pause();
      }
    }
  }

  /// Public method to load a new video URL.
  Future<void> loadVideoUrl(String newUrl) async {
    // Dispose old
    _videoPlayerController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    setState(() => _hasEnded = false);
    await _initializeVideo(newUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
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
            // Previous lesson button overlay.
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
            // Next lesson button overlay.
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
