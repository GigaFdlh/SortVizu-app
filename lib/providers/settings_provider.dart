import 'package:flutter/material.dart';
import '../core/services/preferences_manager.dart';
import '../core/services/sound_manager.dart'; // Pastikan import SoundManager kamu
import '../core/enums/visualization_type.dart';

class SettingsProvider with ChangeNotifier {
  final _prefs = PreferencesManager();
  
  // Instance SoundManager (Singleton)
  final _soundManager = SoundManager(); 

  // State Variables
  late ThemeMode _themeMode;
  late int _sortingSpeed;
  late bool _soundEnabled;
  late int _defaultArraySize;
  late VisualizationType _defaultVisualization;

  // Getters
  ThemeMode get themeMode => _themeMode;
  int get sortingSpeed => _sortingSpeed;
  bool get soundEnabled => _soundEnabled;
  int get defaultArraySize => _defaultArraySize;
  VisualizationType get defaultVisualization => _defaultVisualization;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    // 1. Load Theme
    final themeString = _prefs.getThemeMode();
    if (themeString == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeString == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    // 2. Load variable lainnya
    _sortingSpeed = _prefs.getDefaultSpeed();
    _defaultArraySize = _prefs.getDefaultArraySize();
    _soundEnabled = _prefs.getSoundEnabled();
    _defaultVisualization = _prefs.getDefaultVisualization();

    // 3. Sinkronisasi SoundManager dengan settingan terakhir
    // (Menggunakan method setSoundEnabled punya kamu)
    _soundManager.setSoundEnabled(_soundEnabled);
    _soundManager.setHapticEnabled(_prefs.getHapticEnabled());

    notifyListeners();
  }

  // ========== SETTERS ==========

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners(); // Update UI langsung

    String themeString = 'system';
    if (mode == ThemeMode.light) themeString = 'light';
    if (mode == ThemeMode.dark) themeString = 'dark';
    
    await _prefs.setThemeMode(themeString);
  }

  Future<void> setSortingSpeed(int speed) async {
    _sortingSpeed = speed;
    notifyListeners();
    await _prefs.setDefaultSpeed(speed);
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    
    // Panggil method yang ADA di SoundManager kamu
    _soundManager.setSoundEnabled(value); 
    
    notifyListeners();
    await _prefs.setSoundEnabled(value);
  }

  Future<void> setDefaultArraySize(int size) async {
    _defaultArraySize = size;
    notifyListeners();
    await _prefs.setDefaultArraySize(size);
  }

  Future<void> setDefaultVisualization(VisualizationType type) async {
    _defaultVisualization = type;
    notifyListeners();
    await _prefs.setDefaultVisualization(type);
  }
  
  Future<void> resetSettings() async {
    await _prefs.resetSettings();
    _loadSettings(); 
  }
}