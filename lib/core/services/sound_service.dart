import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; 

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _typingPlayer = AudioPlayer();
  
  static bool isMuted = false;

  static Future<void> init() async {
    // Web doesn't support low latency mode well, so we skip it there
    if (!kIsWeb) {
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
      
      await _typingPlayer.setReleaseMode(ReleaseMode.stop);
      await _typingPlayer.setPlayerMode(PlayerMode.lowLatency);
    }
    
    // Ensure BGM is ready to loop
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> preload() async {
    // 1. CONFIGURE AUDIO SESSION (Mobile Only)
    if (!kIsWeb) {
      try {
        final AudioContext audioContext = AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: { 
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
        await AudioPlayer.global.setAudioContext(audioContext);
      } catch (e) {
        debugPrint("Audio Context Error: $e");
      }
    }

    // 2. PRELOAD ASSETS
    final cache = AudioCache(prefix: 'assets/sounds/');
    try {
      await cache.loadAll(['click.mp3', 'error.mp3', 'success.mp3', 'bgm.mp3', 'typing.mp3']);
    } catch (e) {
      debugPrint("Audio Load Error: $e");
    }
  }

  // --- SFX (One-shots) ---
  // These are short, so standard stop() is fine and safer to ensure no overlap.
  static void playClick() async {
    if (isMuted) return;
    try {
      if (_sfxPlayer.state == PlayerState.playing) await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (_) {}
  }

  static void playError() async {
    if (isMuted) return;
    try {
      if (_sfxPlayer.state == PlayerState.playing) await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/error.mp3'), volume: 0.55);
    } catch (_) {}
  }

  static void playSuccess() async {
    if (isMuted) return;
    try {
      if (_sfxPlayer.state == PlayerState.playing) await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/success.mp3'), volume: 0.35);
    } catch (_) {}
  }

  // --- TYPING SFX (Looping) ---
  static void startTyping() async {
    if (isMuted) return;
    if (_typingPlayer.state == PlayerState.playing) return;
    try {
      await _typingPlayer.setReleaseMode(ReleaseMode.loop);
      
      if (_typingPlayer.state == PlayerState.paused) {
        await _typingPlayer.resume();
      } else {
        await _typingPlayer.play(AssetSource('sounds/typing.mp3'), volume: 0.6);
      }
    } catch (_) {}
  }

  static void stopTyping() async {
    try {
      // SIMULATED STOP: Pause and Reset to 0
      await _typingPlayer.pause();
      await _typingPlayer.seek(Duration.zero);
    } catch (_) {}
  }

  // --- BGM (Looping) ---
  static void playBgm() async {
    if (_bgmPlayer.state == PlayerState.playing) return;
    if (isMuted) return;

    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      
      if (_bgmPlayer.state == PlayerState.paused) {
        await _bgmPlayer.resume(); 
      } else {
        await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3);
      }
    } catch (_) {}
  }

  static void stopBgm() async {
    try {
      // SIMULATED STOP: Pause and Reset to 0
      await _bgmPlayer.pause();
      await _bgmPlayer.seek(Duration.zero);
    } catch (_) {}
  }

  // --- MUTE TOGGLE ---
  static void toggleMute() async {
    isMuted = !isMuted;
    if (isMuted) {
      // Use the new "Simulated Stop" for BGM/Typing so they are ready to restart
      stopBgm();
      stopTyping();
      // SFX just stops hard
      await _sfxPlayer.stop(); 
    } else {
      playBgm();
    }
  }
}