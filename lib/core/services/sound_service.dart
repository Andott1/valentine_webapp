import 'package:audioplayers/audioplayers.dart';

class SoundService {
  // Player 1: Sound Effects (Optimized for speed)
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // Player 2: Background Music
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static Future<void> init() async {
    // optimize sfx player for low latency
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  // NEW: Preload all sounds into memory
  static Future<void> preload() async {
    // AudioCache is now internal to AudioPlayer in v6, 
    // but we can use a temporary cache to ensure files are fetched.
    final cache = AudioCache(prefix: 'assets/sounds/');
    await cache.loadAll([
      'click.mp3',
      'error.mp3',
      'success.mp3',
      'bgm.mp3', 
    ]);
  }

  static void playClick() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/click.mp3'), volume: 1.0);
  }

  static void playError() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/error.mp3'), volume: 1.0);
  }

  static void playSuccess() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/success.mp3'), volume: 1.0);
  }

  static void playBgm() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3);
  }

  static void stopBgm() async {
    await _bgmPlayer.stop();
  }
}