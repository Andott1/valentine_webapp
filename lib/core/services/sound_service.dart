import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  
  static bool isMuted = false;

  static Future<void> init() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    
    await _bgmPlayer.stop(); 
    // Set default to loop
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

  // --- BGM (Updated for Infinite Loop) ---
  static void playBgm() async {
    // 1. If already playing, do nothing (prevents double audio)
    if (_bgmPlayer.state == PlayerState.playing) return;

    // 2. If muted, do nothing
    if (isMuted) return;

    // 3. FORCE LOOP MODE
    // We set this explicitly every time to guarantee it never stops.
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

    // 4. Smart Resume/Play Logic
    if (_bgmPlayer.state == PlayerState.paused) {
      await _bgmPlayer.resume(); // Continue from where we left off
    } else {
      await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'), volume: 0.3); // Start fresh
    }
  }

  static void stopBgm() async {
    await _bgmPlayer.stop();
  }

  // --- MUTE TOGGLE ---
  static void toggleMute() async {
    isMuted = !isMuted;
    
    if (isMuted) {
      // Pause BGM (so we can resume later)
      await _bgmPlayer.pause();
      // Stop SFX immediately
      await _sfxPlayer.stop();
    } else {
      // Unmuting: Call playBgm() which now handles the Resume vs Play logic automatically
      playBgm();
    }
  }
}