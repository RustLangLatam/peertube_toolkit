import 'package:flutter/material.dart';
import 'package:river_player/river_player.dart';

/// A utility class for configuring video player controls with
/// a PeerTube-style theme and advanced customization.
class PeerTubePlayerControlsConfig {
  /// Returns a `BetterPlayerControlsConfiguration` with custom settings.
  ///
  /// - [showControlsOnInitialize] Determines if controls should be visible on startup.
  /// - [enableFullscreen] Enables/disables fullscreen mode.
  /// - [enablePip] Enables/disables Picture-in-Picture mode.
  /// - [progressBarColor] Custom color for the played portion of the progress bar.
  /// - [bufferedColor] Custom color for the buffered portion of the progress bar.
  /// - [backgroundColor] Background color for the control overlay.
  /// - [loadingIndicatorColor] Color of the loading indicator.
  /// - [autoHideControlsDuration] Duration before controls automatically hide.
  static BetterPlayerControlsConfiguration defaultConfig({
    bool showControlsOnInitialize = false,
    bool enableFullscreen = true,
    bool enablePip = true,
    Color progressBarColor = Colors.deepOrange,
    Color bufferedColor = const Color(0xFF28A745),
    Color backgroundColor = const Color(0xFF13100E),
    Color loadingIndicatorColor = Colors.orange,
    Duration autoHideControlsDuration = const Duration(milliseconds: 200),
  }) {
    return BetterPlayerControlsConfiguration(
      showControlsOnInitialize: showControlsOnInitialize,
      controlBarColor: Colors.black54,
      textColor: Colors.white,
      iconsColor: Colors.white,
      progressBarPlayedColor: progressBarColor,
      progressBarHandleColor: Colors.white,
      progressBarBufferedColor: bufferedColor,
      progressBarBackgroundColor: Colors.white30,
      loadingColor: loadingIndicatorColor,
      liveTextColor: Colors.redAccent,
      backgroundColor: backgroundColor,
      overflowModalColor: Colors.black87,
      overflowModalTextColor: Colors.white,
      overflowMenuIconsColor: Colors.white,
      enableFullscreen: enableFullscreen,
      enablePip: enablePip,
      enableProgressText: true,
      enableProgressBar: true,
      enableProgressBarDrag: true,
      enablePlayPause: true,
      enableSkips: true,
      enableSubtitles: true,
      enableQualities: true,
      enablePlaybackSpeed: true,
      enableRetry: true,
      enableAudioTracks: true,
      controlBarHeight: 50,
      overflowMenuIcon: Icons.settings,
      subtitlesIcon: Icons.closed_caption,
      playbackSpeedIcon: Icons.speed,
      qualitiesIcon: Icons.high_quality,
      forwardSkipTimeInMilliseconds: 10000,
      backwardSkipTimeInMilliseconds: 10000,
      controlsHideTime: autoHideControlsDuration,
    );
  }

  /// Returns a minimalistic configuration with only essential controls.
  static BetterPlayerControlsConfiguration minimalConfig({
    bool enableFullscreen = true,
    bool enablePip = true,
  }) {
    return BetterPlayerControlsConfiguration(
      showControlsOnInitialize: false,
      controlBarColor: Colors.black54,
      textColor: Colors.white,
      iconsColor: Colors.white,
      progressBarPlayedColor: Colors.deepOrange,
      progressBarHandleColor: Colors.white,
      progressBarBufferedColor: Colors.grey,
      progressBarBackgroundColor: Colors.white30,
      loadingColor: Colors.orange,
      backgroundColor: Colors.black,
      enableFullscreen: enableFullscreen,
      enablePip: enablePip,
      enableProgressText: true,
      enableProgressBar: true,
      enableProgressBarDrag: true,
      enablePlayPause: true,
      enableSkips: false,
      enableSubtitles: false,
      enableQualities: false,
      enablePlaybackSpeed: false,
      enableRetry: true,
      enableAudioTracks: false,
      controlBarHeight: 40,
      overflowMenuIcon: Icons.more_vert,
      forwardSkipTimeInMilliseconds: 5000,
      backwardSkipTimeInMilliseconds: 5000,
      controlsHideTime: const Duration(seconds: 2),
    );
  }

  /// Returns a configuration optimized for live streaming playback.
  static BetterPlayerControlsConfiguration liveStreamConfig({
    Color progressBarColor = Colors.redAccent,
    Color bufferedColor = Colors.grey,
    Color backgroundColor = Colors.black,
  }) {
    return BetterPlayerControlsConfiguration(
      showControlsOnInitialize: false,
      controlBarColor: Colors.black54,
      progressBarBufferedColor: bufferedColor,
      progressBarPlayedColor: progressBarColor,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      iconsColor: Colors.white,
      progressBarHandleColor: Colors.white,
      progressBarBackgroundColor: Colors.white30,
      loadingColor: Colors.orange,
      enableFullscreen: true,
      enablePip: true,
      enableProgressText: false,
      enableProgressBar: false,
      enableProgressBarDrag: false,
      enablePlayPause: true,
      enableSkips: false,
      enableSubtitles: true,
      enableQualities: true,
      enablePlaybackSpeed: false,
      enableRetry: true,
      enableAudioTracks: true,
      controlBarHeight: 45,
      overflowMenuIcon: Icons.more_vert,
      liveTextColor: Colors.redAccent,
      controlsHideTime: const Duration(milliseconds: 200),
    );
  }

  /// Returns a configuration that only shows the progress bar without any other controls.
  /// Returns a configuration that only shows the progress bar with no other controls.
  static BetterPlayerControlsConfiguration progressBarOnlyConfig({
    Color progressBarColor = Colors.deepOrange,
    Color bufferedColor = Colors.grey,
    Color backgroundColor = Colors.black,
  }) {
    return BetterPlayerControlsConfiguration(
      showControlsOnInitialize: true, // Controls are hidden initially
      controlBarColor: Colors.transparent, // No control bar
      textColor: Colors.transparent, // Hide text
      iconsColor: Colors.transparent, // Hide icons
      progressBarPlayedColor: progressBarColor, // Color of played portion
      progressBarHandleColor: Colors.white, // Handle color
      progressBarBufferedColor: bufferedColor, // Buffered portion color
      progressBarBackgroundColor: Colors.white30, // Background of the progress bar
      loadingColor: Colors.transparent, // Hide loading spinner
      backgroundColor: backgroundColor, // Background color
      enableFullscreen: false,
      enablePip: false,
      enableProgressText: false, // No time indicators
      enableProgressBar: true, // ✅ Show progress bar
      enableProgressBarDrag: false, // Disable dragging
      enablePlayPause: false, // No play/pause button
      enableSkips: false, // No skip buttons
      enableSubtitles: false, // No subtitles
      enableQualities: false, // No quality selector
      enablePlaybackSpeed: false, // No speed controls
      enableRetry: false, // No retry button
      enableAudioTracks: false, // No audio track selector
      controlBarHeight: 0, // Hide control bar completely
      // overflowMenuIcon: null, // No overflow menu
      forwardSkipTimeInMilliseconds: 0, // No skip forward
      backwardSkipTimeInMilliseconds: 0, // No skip backward
      controlsHideTime: Duration.zero, // Never show full controls

    );
  }

}
