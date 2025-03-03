import 'package:flutter/cupertino.dart';

import '../../peertube_toolkit.dart';

class PeerTubeListVideoPlayer {
  final _controller = BetterPlayerListVideoPlayerController();

  late BetterPlayerListVideoPlayer _player;

  BetterPlayerListVideoPlayer player() => _player;

  void _initializeVideoPlayer(Key? key, PeerTubeVideoSourceInfo source,
      BetterPlayerNotificationConfiguration? notificationCfg,
      {double? aspectRatio,
      double? playFraction,
      BetterPlayerControlsConfiguration? controlsConfiguration}) {
    final activeCache = (currentPlatform == PlatformType.android);

    // Extract the thumbnail URL from the video source
    final thumbnailURL = source.thumbnailURL;

    // Create a data source for the video player
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, // Use a network data source
      source.url, // Set the video URL
      videoFormat: source.type,
      useAsmsSubtitles: false, // Disable ASMS subtitles
      liveStream: false, // Set the live stream flag
      cacheConfiguration:
          activeCache ? PeerTubePlayerCacheConfig.create(source) : null,
      bufferingConfiguration:
          PeerTubePlayerBufferOptimizerConfig.getOptimalBufferConfig(
        source.duration,
      ), // Configure buffering
      resolutions: source.resolutions, // Set available video resolutions
      notificationConfiguration: notificationCfg,
    );

    // Initialize the video player with the appropriate configuration
    _player = BetterPlayerListVideoPlayer(
      dataSource,
      configuration: PeerTubePlayerConfig.defaultConfig(
          thumbnailURL: thumbnailURL,
          aspectRatio: aspectRatio ?? 16 / 9,
          controlsConfiguration: controlsConfiguration),
      key: key ?? Key(source.hashCode.toString()),
      playFraction: playFraction ?? 0.5,
      betterPlayerListVideoPlayerController: _controller,
    );
  }

  void initializePlayerFromVideoDetails(
    VideoDetails? videoDetails, {
    key,
    String? nodeUrl,
    BetterPlayerControlsConfiguration? controlsConfiguration,
    double? playFraction,
    double? aspectRatio,
  }) {
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

    _initializeVideoPlayer(
        key,
        source,
        PeerTubePlayerNotificationConfig.create(
          thumbnailURL: thumbnailURL,
          title: videoDetails.name,
          author: VideoUtils.extractNameOrDisplayName(videoDetails),
        ),
        aspectRatio: aspectRatio,
        controlsConfiguration: controlsConfiguration,
        playFraction: playFraction);
  }

  void initializeVideoPlayerFromSourceInfo(PeerTubeVideoSourceInfo source,
      {key,
      double? aspectRatio,
      BetterPlayerControlsConfiguration? controlsConfiguration,
      double? playFraction}) {
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
        aspectRatio: aspectRatio,
        controlsConfiguration: controlsConfiguration,
        playFraction: playFraction);
  }

  BetterPlayerListVideoPlayerController? get controller => _controller;
}
