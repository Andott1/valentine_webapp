import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _typingPlayer = AudioPlayer();
  
  static bool isMuted = false;

  static Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    await _typingPlayer.setReleaseMode(ReleaseMode.stop);
    await _typingPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    await _bgmPlayer.stop(); 
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> preload() async {
    // 1. CONFIGURE AUDIO SESSION (The iOS Fix)
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: { // Set syntax {}
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none,
      ),
    );

    // Apply this configuration globally
    await AudioPlayer.global.setAudioContext(audioContext);

    // 2. Preload Assets
    final cache = AudioCache(prefix: 'assets/sounds/');
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

  // --- TYPING SFX ---
  static void startTyping() async {
    if (isMuted) return;
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
      await _typingPlayer.stop();
    } else {
      playBgm();
    }
  }
}