import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_web/video_player_web.dart';

void ensureVideoPlayerInitialized() {
  try {
    if (VideoPlayerPlatform.instance is! VideoPlayerPlugin) {
      VideoPlayerPlatform.instance = VideoPlayerPlugin();
    }
  } catch (_) {}
}
