export 'platform_detector.dart';
export 'platform_detector_stub.dart'
    if (dart.library.html) 'platform_detector_web.dart'
    if (dart.library.io) 'platform_detector_io.dart';
