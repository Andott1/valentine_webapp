import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  // NEW: Dedicated player for the typing loop
  static final AudioPlayer _typingPlayer = AudioPlayer();
  
  static bool isMuted = false;

  static Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    // NEW: Init typing player
    await _typingPlayer.setReleaseMode(ReleaseMode.stop);
    await _typingPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    await _bgmPlayer.stop(); 
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> preload() async {
    final cache = AudioCache(prefix: 'assets/sounds/');
    // NOTE: You need to add 'typing.mp3' to your assets!
    await cache.loadAll(['click.mp3', 'error.mp3', 'success.mp3', 'bgm.mp3', 'typing.mp3']);
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
    await _sfxPlayer.play(AssetSource('sounds/error.mp3'), volume: 0.55);
  }

  static void playSuccess() async {
    if (isMuted) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/success.mp3'), volume: 0.35);
  }

  // --- NEW: TYPING SFX ---
  static void startTyping() async {
    if (isMuted) return;
    // Don't restart if already playing
    if (_typingPlayer.state == PlayerState.playing) return;

    await _typingPlayer.setReleaseMode(ReleaseMode.loop);
    await _typingPlayer.play(AssetSource('sounds/typing.mp3'), volume: 0.6);
  }

  static void stopTyping() async {
    await _typingPlayer.stop();
  }

  // --- BGM ---
  static void playBgm() async {
    if (_bgmPlayer.state == PlayerState.playing) return;
    if (isMuted) return;

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

    if (_bgmPlayer.state == PlayerState.paused) {
      await _bgmPlayer.resume(); 
    } else {
      await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3);
    }
  }

  static void stopBgm() async {
    await _bgmPlayer.stop();
  }

  // --- MUTE TOGGLE ---
  static void toggleMute() async {
    isMuted = !isMuted;
    
    if (isMuted) {
      await _bgmPlayer.pause();
      await _sfxPlayer.stop();
      // NEW: Stop typing immediately if muted
      await _typingPlayer.stop();
    } else {
      playBgm();
    }
  }
}