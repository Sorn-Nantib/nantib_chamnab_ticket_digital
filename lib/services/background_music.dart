import 'package:audioplayers/audioplayers.dart';

/// Background music for the wedding invitation. Uses assets/audio/ MP3.
class BackgroundMusic {
  BackgroundMusic._();
  static final BackgroundMusic _instance = BackgroundMusic._();
  static BackgroundMusic get instance => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _muted = false;
  bool _initialized = false;

  /// Path relative to pubspec assets (assets/audio/ folder).
  static const String _assetPath = 'audio/NISAI.mp3';

  bool get isMuted => _muted;
  bool get isPlaying => _player.state == PlayerState.playing;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _player.setReleaseMode(ReleaseMode.loop);
    _player.onPlayerStateChanged.listen((state) {});
  }

  Future<void> play() async {
    if (_muted) return;
    try {
      await _player.play(AssetSource(_assetPath));
    } catch (_) {
      // Ensure assets/audio/ is in pubspec and the mp3 file exists
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void setMuted(bool muted) {
    _muted = muted;
    if (muted) {
      _player.pause();
    } else {
      play();
    }
  }

  void toggleMuted() {
    setMuted(!_muted);
  }

  void dispose() {
    _player.dispose();
  }
}
