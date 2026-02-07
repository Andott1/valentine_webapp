import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  
  // Track mute state
  static bool isMuted = false;

  static Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    // Ensure BGM player is reset on app start
    await _bgmPlayer.stop(); 
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> preload() async {
    final cache = AudioCache(prefix: 'assets/sounds/');
    await cache.loadAll(['click.mp3', 'error.mp3', 'success.mp3', 'bgm.mp3']);
  }

  // --- SFX ---
  static void playClick() async {
    if (isMuted) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/click.mp3'));
  }

  static void playError() async {
    if (isMuted) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/error.mp3'));
  }

  static void playSuccess() async {
    if (isMuted) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/success.mp3'));
  }

  // --- BGM ---
  static void playBgm() async {
    // 1. SAFETY CHECK: If already playing, do nothing!
    if (_bgmPlayer.state == PlayerState.playing) return;

    if (isMuted) return; // Don't start if muted

    await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3);
  }

  static void stopBgm() async {
    await _bgmPlayer.stop();
  }

  // --- MUTE TOGGLE ---
  static void toggleMute() async {
    isMuted = !isMuted;
    
    if (isMuted) {
      // If we just muted, stop everything
      await _bgmPlayer.pause(); // Pause allows resuming later
      await _sfxPlayer.stop();
    } else {
      // If we just unmuted, resume BGM (if we are in a screen that needs it)
      // Note: We normally let the UI handle "when" to resume, 
      // but strictly resuming only if we were paused is safe.
      if (_bgmPlayer.state == PlayerState.paused) {
        await _bgmPlayer.resume();
      }
    }
  }
}