import 'package:audioplayers/audioplayers.dart';

class SoundService {
  // Player 1: Sound Effects (One-shot)
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // Player 2: Background Music (Looping)
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
  }

  // --- SFX METHODS (Use _sfxPlayer) ---
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

  // --- BGM METHODS (Use _bgmPlayer) ---
  static void playBgm() async {
    // Set to loop endlessly
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3); // Lower volume for background
  }

  static void stopBgm() async {
    await _bgmPlayer.stop();
  }
}