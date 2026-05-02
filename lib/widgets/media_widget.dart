import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/asset_helper.dart';

/// Renders either a static image or a looping video depending on the file type.
/// Reads the asset path from the JSON-relative [path].
class MediaWidget extends StatefulWidget {
  final String path;
  final BoxFit fit;
  final bool autoPlay;

  const MediaWidget({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
  });

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoError = false;

  String get _assetPath => toAssetPath(widget.path);

  @override
  void initState() {
    super.initState();
    if (isVideo(widget.path)) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    try {
      final ctrl = VideoPlayerController.asset(_assetPath);
      _controller = ctrl;
      await ctrl.initialize();
      ctrl.setLooping(true);
      if (widget.autoPlay) ctrl.play();
      if (mounted) setState(() => _videoReady = true);
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isVideo(widget.path)) {
      return _buildVideoPlayer();
    }
    return _buildImage();
  }

  Widget _buildImage() {
    return Image.asset(
      _assetPath,
      fit: widget.fit,
      errorBuilder: (_, __, ___) => _placeholder(Icons.broken_image_rounded),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoError) return _placeholder(Icons.videocam_off_rounded);

    if (!_videoReady) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: widget.fit,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // Play/Pause tap overlay
        GestureDetector(
          onTap: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            });
          },
          child: Container(color: Colors.transparent),
        ),
        // Play/pause icon indicator
        ValueListenableBuilder(
          valueListenable: _controller!,
          builder: (_, VideoPlayerValue value, __) {
            if (value.isPlaying) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 28),
            );
          },
        ),
      ],
    );
  }

  Widget _placeholder(IconData icon) => Container(
        color: const Color(0xFF1A2A3A),
        child: Center(
          child: Icon(icon, color: Colors.white38, size: 48),
        ),
      );
}
