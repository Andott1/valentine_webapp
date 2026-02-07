import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  static void playClick() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/click.mp3'), volume: 1.0);
  }

  static void playError() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/error.mp3'), volume: 1.0);
  }

  static void playSuccess() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/success.mp3'), volume: 1.0);
  }
}