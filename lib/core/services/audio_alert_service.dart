import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioAlertService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static bool get isPlaying => _isPlaying;

  /// Start playing continuous emergency siren loop
  static Future<void> playEmergencySiren() async {
    if (_isPlaying) return;
    try {
      _isPlaying = true;
      await _player.setReleaseMode(ReleaseMode.loop);
      // Online siren audio source for reliable emergency sound without requiring local bundling
      await _player.play(
        UrlSource('https://assets.mixkit.co/active_storage/sfx/2874/2874-preview.mp3'),
        volume: 1.0,
      );
      debugPrint('[AudioAlertService] Emergency siren playing');
    } catch (e) {
      debugPrint('[AudioAlertService] Could not play siren audio: $e');
    }
  }

  /// Stop emergency siren
  static Future<void> stopEmergencySiren() async {
    try {
      _isPlaying = false;
      await _player.stop();
      debugPrint('[AudioAlertService] Emergency siren stopped');
    } catch (e) {
      debugPrint('[AudioAlertService] Error stopping siren: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}
