import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; // WAJIB: Pastikan package ini ada
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/services/preferences_manager.dart';
import 'providers/settings_provider.dart'; // Import Provider yang baru dibuat
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Preferences
  await PreferencesManager().init();
  
  // Set default system UI (akan di-override oleh Theme nanti)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Default icon putih
      systemNavigationBarColor: Color(0xFF0A0E27), // Default nav bar gelap
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const SortVizuApp());
  });
}

class SortVizuApp extends StatelessWidget {
  const SortVizuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Bungkus dengan MultiProvider agar state bisa diakses di seluruh app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      // 2. Gunakan Consumer untuk mendengarkan perubahan Theme/Settings
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            
            // ===== KONFIGURASI TEMA DINAMIS =====
            theme: AppTheme.lightTheme,       // Tema Terang
            darkTheme: AppTheme.darkTheme,    // Tema Gelap
            themeMode: settingsProvider.themeMode, // Berubah sesuai pilihan user (System/Light/Dark)
            // ===================================
            
            home: const SplashScreen(),
            
            // Text Scaler Logic (Tetap dipertahankan)
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              final textScale = mediaQuery.textScaler.scale(1.0);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.linear(textScale.clamp(0.8, 1.3)),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}