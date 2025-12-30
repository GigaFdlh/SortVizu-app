import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'preferences_manager.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal() {
    _initPlayers();
    _loadPreferences();
  }

  // Audio players
  final List<AudioPlayer> _players = [];
  int _currentPlayerIndex = 0;
  static const int _maxPlayers = 5;

  // Preferences
  final _prefs = PreferencesManager();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  void _initPlayers() {
    for (int i = 0; i < _maxPlayers; i++) {
      _players.add(AudioPlayer());
    }
  }

  // ========== NEW: Load preferences ==========
  void _loadPreferences() {
    _soundEnabled = _prefs.getSoundEnabled();
    _hapticEnabled = _prefs.getHapticEnabled();
  }
  // ===========================================

  AudioPlayer get _nextPlayer {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _maxPlayers;
    return _players[_currentPlayerIndex];
  }

  // ========== UPDATED: Save to preferences ==========
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    _prefs.setSoundEnabled(enabled);
  }

  void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
    _prefs.setHapticEnabled(enabled);
  }
  // ==================================================

  /// Play comparison sound (pitch varies by value)
  Future<void> playComparison(int value) async {
    if (!_soundEnabled) return;

    try {
      final player = _nextPlayer;
      
      // Pitch based on value (10-300 → 0.6-1.8)
      final pitch = 0.6 + (value / 300) * 1.2;
      
      await player.setPlaybackRate(pitch);
      await player.setVolume(0.15);
      await player.play(AssetSource('sounds/tick.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play swap sound
  Future<void> playSwap() async {
    if (!_soundEnabled) return;

    try {
      final player = _nextPlayer;
      await player.setVolume(0.3);
      await player.setPlaybackRate(1.0);
      await player.play(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play completion sound
  Future<void> playComplete() async {
    if (!_soundEnabled) return;

    try {
      final player = _players[0];
      await player.setVolume(0.5);
      await player.setPlaybackRate(1.0);
      await player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Play haptic feedback
  void hapticLight() {
    if (!_hapticEnabled) return;
    HapticFeedback.lightImpact();
  }

  void hapticMedium() {
    if (!_hapticEnabled) return;
    HapticFeedback. mediumImpact();
  }

  void hapticHeavy() {
    if (!_hapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void hapticSelection() {
    if (!_hapticEnabled) return;
    HapticFeedback.selectionClick();
  }

  void dispose() {
    for (var player in _players) {
      player.dispose();
    }
  }
}