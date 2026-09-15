import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/video_web_registrar.dart';

class ScrollResponsiveVideoBackground extends StatefulWidget {
  final ScrollController scrollController;
  final ValueChanged<bool>? onVideoReady;

  const ScrollResponsiveVideoBackground({
    super.key,
    required this.scrollController,
    this.onVideoReady,
  });

  @override
  State<ScrollResponsiveVideoBackground> createState() =>
      _ScrollResponsiveVideoBackgroundState();
}

class _ScrollResponsiveVideoBackgroundState
    extends State<ScrollResponsiveVideoBackground>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  late Ticker _ticker;
  double _currentProgress = 0.0;
  double _targetProgress = 0.0;
  DateTime _lastSeekTime = DateTime.fromMillisecondsSinceEpoch(0);
  bool _isSeeking = false;
  Duration? _pendingSeek;

  @override
  void initState() {
    super.initState();
    ensureVideoPlayerInitialized();
    _controller = VideoPlayerController.asset('assets/video/bgvideo.mp4');
    _controller
        .initialize()
        .then((_) async {
          if (!mounted) return;
          await _controller.setVolume(0.0);
          await _controller.setLooping(false);
          await _controller.pause();
          setState(() {
            _isInitialized = true;
          });
          _updateTargetFromScroll();
          widget.onVideoReady?.call(true);
        })
        .catchError((e) {
          debugPrint("Background video initialization failed: $e");
          if (mounted) {
            setState(() {
              _hasError = true;
            });
            widget.onVideoReady?.call(true);
          }
        });

    widget.scrollController.addListener(_onScroll);

    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(covariant ScrollResponsiveVideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
      _updateTargetFromScroll();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    _updateTargetFromScroll();
  }

  void _updateTargetFromScroll() {
    if (!widget.scrollController.hasClients) return;
    final position = widget.scrollController.position;
    if (!position.hasContentDimensions) return;
    final maxScroll = position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final double offset = position.pixels;
    _targetProgress = (offset / maxScroll).clamp(0.0, 1.0);
  }

  void _onTick(Duration elapsed) {
    if (!_isInitialized) return;

    // Smooth exponential decay (lerp) towards targetProgress for fluid interpolation
    final double diff = _targetProgress - _currentProgress;
    if (diff.abs() > 0.0001) {
      _currentProgress += diff * 0.25; // responsive, smooth easing factor
    } else {
      _currentProgress = _targetProgress;
    }

    final totalDuration = _controller.value.duration;
    if (totalDuration == Duration.zero) return;

    final now = DateTime.now();

    // Watchdog: If seeking has been locked for over 250ms (decoder stalled or dropped event), release the lock
    if (_isSeeking && now.difference(_lastSeekTime).inMilliseconds > 250) {
      _isSeeking = false;
    }

    // Seek to video position smoothly with proper pacing for the browser video decoder
    if (!_isSeeking && now.difference(_lastSeekTime).inMilliseconds >= 35) {
      final int targetMs = (totalDuration.inMilliseconds * _currentProgress).round();
      final target = Duration(milliseconds: targetMs);
      if ((target - _controller.value.position).inMilliseconds.abs() > 20) {
        _lastSeekTime = now;
        _performSeek(target);
      }
    }
  }

  void _performSeek(Duration target) {
    if (_isSeeking) {
      _pendingSeek = target;
      return;
    }

    _isSeeking = true;
    _controller
        .seekTo(target)
        .then((_) {
          _isSeeking = false;
          if (_pendingSeek != null) {
            final next = _pendingSeek!;
            _pendingSeek = null;
            _performSeek(next);
          }
        })
        .catchError((_) {
          _isSeeking = false;
        })
        .timeout(
          const Duration(milliseconds: 200),
          onTimeout: () {
            _isSeeking = false;
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(color: const Color(0xFF111111));
    }

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFF0C0C0E)),
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width > 0
                      ? _controller.value.size.width
                      : 1280,
                  height: _controller.value.size.height > 0
                      ? _controller.value.size.height
                      : 720,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          if (!_isInitialized)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ParticleVortexLoader(
                    options: LoaderOptions(
                      color: AppColors.primary,
                      secondaryColor: const Color(0xFF4BA3E3),
                      tertiaryColor: Colors.white,
                      size: LoaderSize.large,
                      durationMs: 3000,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Loading experience...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
