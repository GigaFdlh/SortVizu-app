import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_strings.dart';
import '../core/enums/visualization_type.dart';
import '../core/services/preferences_manager.dart';
import '../core/services/sound_manager.dart';
import '../core/utils/snackbar_helper.dart';

/// Settings Screen - User preferences and customization
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _prefs = PreferencesManager();
  final _soundManager = SoundManager();

  late String _themeMode;
  late int _defaultArraySize;
  late int _defaultSpeed;
  late bool _soundEnabled;
  late bool _hapticEnabled;
  late VisualizationType _defaultVisualization;

  // ========== Speed conversion helpers ==========
  
  /// Convert speed (ms) to slider value (1-10)
  double _msToSliderValue(int speedMs) {
    if (speedMs >= 500) return 1;
    if (speedMs >= 250) return 2;
    if (speedMs >= 150) return 3;
    if (speedMs >= 100) return 4;
    if (speedMs >= 75) return 5;
    if (speedMs >= 50) return 6;
    if (speedMs >= 30) return 7;
    if (speedMs >= 20) return 8;
    if (speedMs >= 15) return 9;
    return 10;
  }

  /// Convert slider value (1-10) to speed (ms)
  int _sliderValueToMs(double sliderValue) {
    switch (sliderValue. round()) {
      case 1: return 500;
      case 2: return 250;
      case 3: return 150;
      case 4: return 100;
      case 5: return 75;
      case 6: return 50;
      case 7: return 30;
      case 8: return 20;
      case 9: return 15;
      case 10: return 10;
      default: return 100;
    }
  }

  /// Get speed multiplier label
  String _getSpeedLabel(int speedMs) {
    if (speedMs >= 500) return '0.25x';
    if (speedMs >= 250) return '0.5x';
    if (speedMs >= 150) return '0.75x';
    if (speedMs >= 100) return '1x';
    if (speedMs >= 75) return '1.5x';
    if (speedMs >= 50) return '2x';
    if (speedMs >= 30) return '3x';
    if (speedMs >= 20) return '4x';
    if (speedMs >= 15) return '5x';
    return '10x';
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _themeMode = _prefs.getThemeMode();
      _defaultArraySize = _prefs.getDefaultArraySize();
      _defaultSpeed = _prefs.getDefaultSpeed();
      _soundEnabled = _prefs.getSoundEnabled();
      _hapticEnabled = _prefs.getHapticEnabled();
      _defaultVisualization = _prefs.getDefaultVisualization();
    });
  }

  Future<void> _saveThemeMode(String mode) async {
    await _prefs.setThemeMode(mode);
    setState(() => _themeMode = mode);
    _soundManager.hapticLight();
    if (! mounted) return;
    SnackBarHelper.showInfo(context, 'Theme updated to $mode mode');
  }

  Future<void> _saveArraySize(double value) async {
    await _prefs.setDefaultArraySize(value. toInt());
    setState(() => _defaultArraySize = value.toInt());
  }

  Future<void> _saveSpeed(double sliderValue) async {
    final speedMs = _sliderValueToMs(sliderValue);
    await _prefs.setDefaultSpeed(speedMs);
    setState(() => _defaultSpeed = speedMs);
  }

  Future<void> _toggleSound(bool value) async {
    await _prefs.setSoundEnabled(value);
    _soundManager.setSoundEnabled(value);
    setState(() => _soundEnabled = value);
    
    if (value) {
      _soundManager.playSwap();
    }
    _soundManager.hapticLight();
  }

  Future<void> _toggleHaptic(bool value) async {
    await _prefs.setHapticEnabled(value);
    _soundManager. setHapticEnabled(value);
    setState(() => _hapticEnabled = value);
    
    if (value) {
      _soundManager.hapticMedium();
    }
  }

  Future<void> _saveVisualization(VisualizationType type) async {
    await _prefs.setDefaultVisualization(type);
    setState(() => _defaultVisualization = type);
    _soundManager.hapticLight();
    if (!mounted) return;
    SnackBarHelper. showInfo(context, 'Default visualization:  ${type.displayName}');
  }

  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context:  context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings? '),
        content: const Text(
          'This will reset all settings to defaults but keep your statistics.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _prefs.resetSettings();
      _soundManager.setSoundEnabled(true);
      _soundManager.setHapticEnabled(true);
      _loadSettings();
      
      _soundManager.hapticMedium();
      if (!mounted) return;
      
      SnackBarHelper.showSuccess(context, 'Settings reset to defaults');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Settings'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed:  () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient. scale(0.5),
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSizes. md),
          children: [
            // Theme Section
            _buildSectionHeader('Appearance', Icons.palette),
            _buildThemeSelector(),
            
            const SizedBox(height: AppSizes.lg),

            // Defaults Section
            _buildSectionHeader('Defaults', Icons.tune),
            _buildArraySizeSlider(),
            const SizedBox(height: AppSizes.md),
            _buildSpeedSlider(),
            const SizedBox(height: AppSizes.md),
            _buildVisualizationPicker(),

            const SizedBox(height:  AppSizes.lg),

            // Audio & Haptic Section
            _buildSectionHeader('Audio & Haptic', Icons.volume_up),
            _buildSoundToggle(),
            _buildHapticToggle(),

            const SizedBox(height:  AppSizes.lg),

            // Statistics Section
            _buildSectionHeader('Statistics', Icons.bar_chart),
            _buildStatsCard(),

            const SizedBox(height: AppSizes.lg),

            // Actions Section
            _buildResetButton(),

            const SizedBox(height: AppSizes. lg),

            // About Section
            _buildSectionHeader('About', Icons. info_outline),
            _buildAboutCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSizes.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface. withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes. radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight. withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Mode',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes. sm),
          Row(
            children: [
              _buildThemeOption('Dark', Icons.dark_mode, 'dark'),
              const SizedBox(width: AppSizes.sm),
              _buildThemeOption('Light', Icons.light_mode, 'light'),
              const SizedBox(width: AppSizes.sm),
              _buildThemeOption('System', Icons.brightness_auto, 'system'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, IconData icon, String mode) {
    final isSelected = _themeMode == mode;
    
    return Expanded(
      child: InkWell(
        onTap:  () => _saveThemeMode(mode),
        borderRadius: BorderRadius.circular(AppSizes. radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.sm,
            horizontal: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: isSelected
                  ?  AppColors.primary
                  :  AppColors.surfaceLight.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? AppColors. primary : AppColors.textSecondary,
                      fontWeight:  isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArraySizeSlider() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors. surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Array Size',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                '$_defaultArraySize',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'JetBrains Mono',
                    ),
              ),
            ],
          ),
          Slider(
            value: _defaultArraySize. toDouble(),
            min: 10,
            max: 100,
            divisions: 18,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surfaceLight,
            onChanged: _saveArraySize,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedSlider() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color:  AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border. all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Speed',
                style: Theme.of(context).textTheme.labelLarge?. copyWith(
                      color:  AppColors.textPrimary,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes. radiusSm),
                ),
                child: Text(
                  _getSpeedLabel(_defaultSpeed), // ← NOW USED! 
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight. w600,
                        fontFamily: 'JetBrains Mono',
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Row(
            children: [
              Text(
                'Slower',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Expanded(
                child: Slider(
                  value: _msToSliderValue(_defaultSpeed), // ← NOW USED! 
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surfaceLight,
                  onChanged: _saveSpeed,
                ),
              ),
              Text(
                'Faster',
                style: Theme. of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationPicker() {
    return Container(
      padding: const EdgeInsets. all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Default Visualization',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors. textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes. sm),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: VisualizationType.values.map((type) {
              final isSelected = _defaultVisualization == type;
              return InkWell(
                onTap: () => _saveVisualization(type),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceLight.withValues(alpha: 0.3),
                      width: isSelected ? 2 :  1,
                    ),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type.icon,
                        size: 16,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        type.displayName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors. textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundToggle() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: _soundEnabled
              ? AppColors.primary. withValues(alpha: 0.5)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          width: _soundEnabled ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes. sm),
            decoration: BoxDecoration(
              color: _soundEnabled
                  ? AppColors.primary. withValues(alpha: 0.15)
                  : AppColors.surfaceLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              _soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: _soundEnabled ? AppColors. primary : AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width:  AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sound Effects',
                  style: Theme. of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  _soundEnabled
                      ? 'Audio playing during sorting'
                      : 'No sound will play',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _soundEnabled
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: _soundEnabled,
            onChanged: _toggleSound,
            activeTrackColor: AppColors.primary,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildHapticToggle() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color:  AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border. all(
          color: _hapticEnabled
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          width: _hapticEnabled ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color:  _hapticEnabled
                  ?  AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              _hapticEnabled ? Icons.vibration : Icons.mobile_off,
              color: _hapticEnabled ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haptic Feedback',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight:  FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  _hapticEnabled
                      ? 'Device vibrates on interactions'
                      : 'No vibration feedback',
                  style: Theme. of(context).textTheme.bodySmall?.copyWith(
                        color: _hapticEnabled
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: _hapticEnabled,
            onChanged: _toggleHaptic,
            activeTrackColor: AppColors.primary,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final totalSorts = _prefs.getTotalSorts();
    final fastestTime = _prefs.getFastestSortTime();

    return Container(
      padding:  const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius. circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _buildStatRow('Total Sorts', '$totalSorts', Icons.sort),
          const Divider(height: AppSizes.md),
          _buildStatRow(
            'Fastest Sort',
            fastestTime > 0 ? '${(fastestTime / 1000).toStringAsFixed(2)}s' : 'N/A',
            Icons.timer,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.info, size: 20),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'JetBrains Mono',
              ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return OutlinedButton. icon(
      onPressed: _resetSettings,
      icon: const Icon(Icons.refresh),
      label: const Text('Reset Settings'),
      style: OutlinedButton.styleFrom(
        foregroundColor:  AppColors.warning,
        side: BorderSide(color: AppColors.warning),
        padding: const EdgeInsets.all(AppSizes.md),
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes. md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appName,
            style: Theme. of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height:  AppSizes.xs),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSizes. sm),
          Text(
            'A beautiful visualization tool for understanding sorting algorithms.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors. textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}