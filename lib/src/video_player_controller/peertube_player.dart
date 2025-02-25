import 'package:peer_tube_api_sdk/peer_tube_api_sdk.dart';
import 'package:river_player/river_player.dart';

import '../../peertube_toolkit.dart';
import '../utils/video_utils.dart';
import '../core/platform_detector/export.dart';

import 'peertube_player_buffer_optimizer_config.dart';
import 'peertube_video_source_info.dart';
import 'peertube_player_config.dart';
import 'peertube_player_notification_config.dart';

/// A service class for managing the video player controller.
class PeerTubePlayer {
  /// The internal video player controller instance.
  BetterPlayerController? _controller;

  /// Initializes the video player controller with the given source and notification configuration.
  ///
  /// This method sets up the video player controller with the appropriate configuration
  /// based on whether the video is a live stream or not. It also creates a data source
  /// for the video player and sets up the data source for the video player.
  ///
  /// [key]: The key for the video player.
  /// [source]: The video source information.
  /// [notificationCfg]: The notification configuration for the video player.
  Future<void> _initializeVideoPlayer(
      key,
      PeerTubeVideoSourceInfo source,
      BetterPlayerNotificationConfiguration? notificationCfg,
      double aspectRatio,
      {BetterPlayerControlsConfiguration? controlsConfiguration}) async {
    final activeCache = (currentPlatform == PlatformType.android);

    // Extract the thumbnail URL from the video source
    final thumbnailURL = source.thumbnailURL;

    // Determine if the video is a live stream
    final bool isLive = source.isLive;

    // Initialize the video player controller with the appropriate configuration
    _controller = BetterPlayerController(
      // Use live stream configuration if the video is a live stream

      isLive
          ? PeerTubePlayerConfig.liveStreamConfig(
              thumbnailURL: thumbnailURL,
              aspectRatio: aspectRatio,
              controlsConfiguration: controlsConfiguration)
          : PeerTubePlayerConfig.defaultConfig(
              thumbnailURL: thumbnailURL,
              aspectRatio: aspectRatio,
              controlsConfiguration: controlsConfiguration),
    );

    // Create a data source for the video player
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, // Use a network data source
      source.url, // Set the video URL
      videoFormat: source.type,
      useAsmsSubtitles: false, // Disable ASMS subtitles
      liveStream: isLive, // Set the live stream flag
      cacheConfiguration:
          activeCache ? PeerTubePlayerCacheConfig.create(source) : null,
      bufferingConfiguration:
          PeerTubePlayerBufferOptimizerConfig.getOptimalBufferConfig(
        source.duration,
      ), // Configure buffering
      resolutions: source.resolutions, // Set available video resolutions
      notificationConfiguration:
          notificationCfg, // Set notification configuration
    );

    // Set up the data source for the video player
    await _controller!.setupDataSource(dataSource);
    _controller!.setBetterPlayerGlobalKey(key);

    if (activeCache) {
      // Pre-cache the video data for smoother playback
      Future.microtask(() => _controller!.preCache(dataSource));
    }
  }

  /// Initializes the video player from video details.
  ///
  /// This method extracts the best video source from the given video details and
  /// initializes the video player with the extracted source.
  ///
  /// [key]: The key for the video player.
  /// [videoDetails]: The video details.
  /// [nodeUrl]: The node URL.
  Future<void> initializePlayerFromVideoDetails(key, VideoDetails? videoDetails,
      {String? nodeUrl,
      double aspectRatio = 16 / 9,
      BetterPlayerControlsConfiguration? controlsConfiguration}) async {
    // Extract the best video source from the video details
    PeerTubeVideoSourceInfo source =
        PeerTubeVideoSourceInfo.extractBestVideoSource(videoDetails)!;

    // Get the thumbnail URL from the video details and node URL
    final thumbnailURL = VideoUtils.getVideoThumbnailUrl(
      videoDetails!,
      nodeUrl!,
    );

    if (thumbnailURL != null) {
      // Update the source with the thumbnail URL
      source = source.copyWith(thumbnailURL: thumbnailURL);
    }

    // Initialize the video player with the extracted source and thumbnail URL
    _initializeVideoPlayer(
        key,
        source,
        PeerTubePlayerNotificationConfig.create(
          thumbnailURL: thumbnailURL,
          title: videoDetails.name,
          author: VideoUtils.extractNameOrDisplayName(videoDetails),
        ),
        aspectRatio,
        controlsConfiguration: controlsConfiguration);
  }

  /// Initializes the video player from a video source info.
  ///
  /// This method initializes the video player with the given video source info.
  ///
  /// [key]: The key for the video player.
  /// [source]: The video source info.
  Future<void> initializeVideoPlayerFromSourceInfo(
      key, PeerTubeVideoSourceInfo source,
      {double aspectRatio = 16 / 9,
      BetterPlayerControlsConfiguration? controlsConfiguration}) async {
    // Initialize the video player with the given source
    _initializeVideoPlayer(
        key,
        source,
        PeerTubePlayerNotificationConfig.create(
          thumbnailURL: source.thumbnailURL,
          title: source.url
              .split('/')
              .last, // Use the last segment of the URL as the title
          author: "PeerTube", // Default author name
        ),
        aspectRatio,
        controlsConfiguration: controlsConfiguration);
  }

  /// Get the player controller instance.
  ///
  /// Returns the internal video player controller instance.
  BetterPlayerController? get controller => _controller;

  /// Check if the video has been initialized.
  ///
  /// Returns `true` if the video has been initialized, `false` otherwise.
  bool get isVideoInitialized => _controller?.isVideoInitialized() ?? false;

  /// Check if the video is currently playing.
  ///
  /// Returns `true` if the video is currently playing, `false` otherwise.
  bool get isVideoPlaying => _controller?.isPlaying() ?? false;

  /// Check if the video is initialized and currently playing.
  ///
  /// Returns `true` if the video is initialized and playing, `false` otherwise.
  bool get isVideoActive => isVideoInitialized && isVideoPlaying;

  /// Dispose of the player when no longer needed.
  ///
  /// Releases system resources used by the video player.
  void dispose() {
    _controller?.dispose();
  }
}
