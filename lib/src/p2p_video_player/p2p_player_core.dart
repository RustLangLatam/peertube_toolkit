import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

double convertToMiB(double bytes) => bytes / 1024 / 1024;

class P2PPlayerCore extends StatefulWidget {
  final List<String> announceTrackers;
  final String hlsSrc;
  final double aspectRatio;
  final Function(double)? onChunkDownloadedByHttp;
  final Function(double)? onChunkDownloadedByP2P;
  final Function(double)? onChunkUploaded;
  final Function(String)? onPeerConnect;
  final Function(String)? onPeerClose;


  const P2PPlayerCore({
    super.key,
    required this.hlsSrc,
    this.aspectRatio = 16 / 9,
    this.onChunkDownloadedByHttp,
    this.onChunkDownloadedByP2P,
    this.onChunkUploaded,
    this.onPeerConnect,
    this.onPeerClose,
    this.announceTrackers = const [],
  });

  @override
  State<P2PPlayerCore> createState() => _P2PPlayerCoreState();
}

class _P2PPlayerCoreState extends State<P2PPlayerCore> {
  final videoController = P2PVideoController(autoplay: '1');


  void _initializeWebViewController(InAppWebViewController controller) async {
    videoController.init(controller);
    _applyJavaScriptHandlers(controller);
  }

  Future<void> _updateHlsSrc(InAppWebViewController controller, String newSrc) async {
    await controller.evaluateJavascript(source: '''
      if (typeof updateHlsSrc === "function") {
        updateHlsSrc("$newSrc");
      } else {
        console.error("updateHlsSrc is not defined");
      }
    ''');
  }

  void _applyJavaScriptHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'onPeerConnect',
      callback: _handlePeerConnect,
    );
    controller.addJavaScriptHandler(
      handlerName: 'onPeerClose',
      callback: _handlePeerClose,
    );
    controller.addJavaScriptHandler(
      handlerName: 'onChunkDownloaded',
      callback: _handleChunkDownloaded,
    );
    controller.addJavaScriptHandler(
      handlerName: 'onChunkUploaded',
      callback: _handleChunkUploaded,
    );
  }

  void _handlePeerConnect(List<dynamic> args) {
    if (args.isEmpty) return;
    final peerId = (args[0] as Map<String, dynamic>)['peerId'] as String?;
    if (peerId == null || peerId.isEmpty) return;

    widget.onPeerConnect?.call(peerId);
  }

  void _handlePeerClose(List<dynamic> args) {
    if (args.isEmpty) return;
    final peerId = (args[0] as Map<String, dynamic>)['peerId'] as String?;
    if (peerId == null || peerId.isEmpty) return;

    widget.onPeerClose?.call(peerId);
  }

  void _handleChunkDownloaded(List<dynamic> args) {
    final downloadedBytes = (args[0] as num?)?.toDouble();
    final downloadSource = args[1] as String?;

    if (downloadedBytes != null && downloadSource != null) {
      final downloadedBytesInMiB = convertToMiB(downloadedBytes);
      if (downloadSource == 'http') {
        widget.onChunkDownloadedByHttp?.call(downloadedBytesInMiB);
      } else if (downloadSource == 'p2p') {
        widget.onChunkDownloadedByP2P?.call(downloadedBytesInMiB);
      }
    }
  }

  void _handleChunkUploaded(List<dynamic> args) {
    final uploadedBytes = (args[0] as num?)?.toDouble();
    if (uploadedBytes == null) return;
    widget.onChunkUploaded?.call(convertToMiB(uploadedBytes));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: InAppWebView(
        initialFile: 'packages/peertube_p2p_player/assets/p2p_player.html',
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          allowUniversalAccessFromFileURLs: true,
          mediaPlaybackRequiresUserGesture: false,
          domStorageEnabled: true,
          databaseEnabled: true,
        ),
        onWebViewCreated: _initializeWebViewController,
        onLoadStop: (controller, url) async {
          await _updateHlsSrc(controller, widget.hlsSrc);
        },
      ),
    );
  }
}

class P2PVideoController {
  late InAppWebViewController webViewController;
  final String autoplay;

  P2PVideoController({required this.autoplay});

  init(InAppWebViewController controller) {
    webViewController = controller;
    debugPrint("[2025-01-06 09:26:48][webViewController] ${webViewController}");
  }

  /// Play video
  Future<dynamic> play() {
    debugPrint("[2025-01-06 13:22:39][play] ");
    return webViewController.evaluateJavascript(source: '''
        document.querySelector("video").play()
        window.dispatchEvent( new CustomEvent("play"));
    ''');
  }

  /// Play video
  Future<dynamic> pause() {
    return webViewController.evaluateJavascript(source: '''
      document.querySelector("video").pause()
      player.pause()
      window.dispatchEvent( new CustomEvent("pause"));
    ''');
  }
}