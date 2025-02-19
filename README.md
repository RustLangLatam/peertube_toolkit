# **PeerTube Toolkit**

**PeerTube Toolkit** is a collection of **Flutter utilities** designed to simplify the development of **PeerTube-based applications**. It provides optimized video playback, text formatting, date utilities, animated transitions, formatted avatars, and more—everything needed to enhance the **PeerTube experience in Flutter**.

---

## **📌 Features**

✅ **Optimized Video Playback** – Seamless PeerTube video streaming with adaptive controls.  
✅ **Text Formatting** – Utilities for markdown parsing, text truncation, and rich text rendering.  
✅ **Date & Time Utilities** – Format timestamps, time ago, and custom date patterns.  
✅ **Animated Transitions** – Smooth UI animations for seamless navigation.  
✅ **Formatted Avatars** – Auto-generated profile images with consistent styling.  
✅ **PeerTube-Specific Enhancements** – Helper functions tailored for PeerTube APIs and content.

---

## **📥 Installation**

Add **PeerTube Toolkit** to your `pubspec.yaml`:

```yaml
dependencies:
  peertube_toolkit: ^1.0.0
```

Then, run:

```sh
flutter pub get
```

Import it into your project:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';
```

---

## **🚀 Usage Examples**

### **🎥 PeerTube Video Player**
Effortless video playback with **HLS support**:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';

PeerTubePlayer.initializePlayerFromVideoDetails(key, VideoDetails());
```

---

### **📝 Text Formatting**
Format PeerTube descriptions with **Markdown parsing**:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';

String formattedText = VideoUtils.extractNameOrDisplayName(Video());
```

---

### **📅 Date Formatting**
Convert timestamps into human-readable **"time ago"** format:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';

String formattedDate = VideoDateUtils.formatTimeAgo(timestamp);
// Output: "2 days ago"
```

---

### **🔄 Animated Transitions**
Create smooth animations between screens:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';

Navigator.push(
  context,
  CustomPageRoute.fade(NewScreen()),
);
```

---

### **👤 Formatted Avatars**
Generate **circular avatars** with default placeholders:

```dart
import 'package:peertube_toolkit/peertube_toolkit.dart';

  AvatarUtils.buildAvatarFromVideoDetails(VideoDetails());
```

---

## **🛠️ Contributions**
Contributions are welcome! If you have improvements or feature suggestions, feel free to open an **issue** or submit a **pull request**.

---

## **📜 License**
PeerTube Toolkit is open-source and released under the **MIT License**.

🚀 **Build amazing PeerTube apps with ease!** 🎥
