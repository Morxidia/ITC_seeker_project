/// Converts a JSON-relative path (e.g. "./img/foo.webp")
/// to a Flutter asset path (e.g. "assets/img/foo.webp").
String toAssetPath(String jsonPath) {
  if (jsonPath.startsWith('./')) {
    return 'assets/${jsonPath.substring(2)}';
  }
  return jsonPath;
}

/// Returns true if the path points to a video file.
bool isVideo(String path) {
  final ext = path.split('.').last.toLowerCase();
  return const {'mp4', 'mov', 'avi', 'mkv', 'webm'}.contains(ext);
}

/// Returns true if the path points to a static image.
bool isImage(String path) {
  final ext = path.split('.').last.toLowerCase();
  return const {'jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'}.contains(ext);
}
