import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// SortVizu App Theme
/// Professional but Fun - Deep Space (Dark) & Clean Lab (Light) Theme
class AppTheme {
  // Private constructor
  AppTheme._();

  // ========== DARK THEME (Primary) ==========
  
  static ThemeData get darkTheme {
    return ThemeData(
      // ===== BRIGHTNESS =====
      brightness: Brightness.dark,
      useMaterial3: true,

      // ===== COLOR SCHEME =====
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // ===== SCAFFOLD =====
      scaffoldBackgroundColor: AppColors.background,

      // ===== APP BAR =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: AppSizes.appBarElevation,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconMd,
        ),
      ),

      // ===== TEXT THEME =====
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        displayMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        labelSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
      ),

      // ===== ELEVATED BUTTON =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: AppSizes.elevationSm,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.buttonPaddingH, vertical: AppSizes.buttonPaddingV),
          minimumSize: const Size(0, AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),

      // ===== OUTLINED BUTTON =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.buttonPaddingH, vertical: AppSizes.buttonPaddingV),
          minimumSize: const Size(0, AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),

      // ===== TEXT BUTTON =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
        ),
      ),

      // ===== FLOATING ACTION BUTTON =====
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: AppSizes.fabElevation,
        highlightElevation: AppSizes.elevationLg,
        shape: CircleBorder(),
        iconSize: AppSizes.iconMd,
      ),

      // ===== CARD =====
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSizes.cardElevation,
        shadowColor: AppColors.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        margin: const EdgeInsets.all(AppSizes.cardMargin),
        clipBehavior: Clip.antiAlias,
      ),

      // ===== SLIDER =====
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceLight,
        trackHeight: 4.0,
        thumbColor: AppColors.primary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0, elevation: 4.0),
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        activeTickMarkColor: AppColors.textPrimary.withValues(alpha: 0.7),
        inactiveTickMarkColor: AppColors.textDisabled,
      ),

      // ===== SWITCH =====
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.surfaceLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary.withValues(alpha: 0.5);
          return AppColors.surfaceLight.withValues(alpha: 0.5);
        }),
      ),

      // ===== CHECKBOX =====
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textPrimary),
        side: const BorderSide(color: AppColors.surfaceLight, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusXs)),
      ),

      // ===== RADIO =====
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.surfaceLight;
        }),
      ),

      // ===== DIVIDER =====
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceLight,
        thickness: AppSizes.dividerThickness,
        space: AppSizes.md,
        indent: AppSizes.dividerIndent,
        endIndent: AppSizes.dividerIndent,
      ),

      // ===== ICON THEME =====
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSizes.iconMd,
      ),

      // ===== DRAWER =====
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSizes.elevationLg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(AppSizes.radiusLg))),
      ),

      // ===== DIALOG =====
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        titleTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        contentTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w400),
      ),

      // ===== BOTTOM SHEET =====
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
        clipBehavior: Clip.antiAlias,
      ),

      // ===== SNACKBAR =====
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
        behavior: SnackBarBehavior.floating,
        elevation: AppSizes.elevationMd,
      ),

      // ===== TOOLTIP =====
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
        textStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w400),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      ),

      // ===== PROGRESS INDICATOR =====
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceLight,
        circularTrackColor: AppColors.surfaceLight,
      ),

      // ===== INPUT DECORATION (TextField) =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.error, width: 2)),
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textDisabled, fontSize: 14),
        errorStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.error, fontSize: 12),
      ),

      // ===== LIST TILE =====
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      ),

      // ===== PAGE TRANSITIONS =====
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ========== LIGHT THEME (Implemented) ==========
  
  static ThemeData get lightTheme {
    return ThemeData(
      // ===== BRIGHTNESS =====
      brightness: Brightness.light,
      useMaterial3: true,

      // ===== COLOR SCHEME =====
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        // Pastikan variabel ini ada di app_colors.dart, atau gunakan Colors.white
        surface: AppColors.surfaceLight, 
        error: AppColors.error,
        onPrimary: Colors.white, // Text di tombol primary putih agar kontras
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight, // Text gelap di background terang
        onError: Colors.white,
      ),

      // ===== SCAFFOLD =====
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ===== APP BAR =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0, 
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Icon status bar jadi gelap
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimaryLight,
          size: AppSizes.iconMd,
        ),
      ),

      // ===== TEXT THEME =====
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 28, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 10, fontWeight: FontWeight.w500),
      ),

      // ===== ELEVATED BUTTON =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: AppSizes.elevationSm,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.buttonPaddingH, vertical: AppSizes.buttonPaddingV),
          minimumSize: const Size(0, AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),

      // ===== OUTLINED BUTTON =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.buttonPaddingH, vertical: AppSizes.buttonPaddingV),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // ===== TEXT BUTTON =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // ===== FLOATING ACTION BUTTON =====
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppSizes.fabElevation,
        shape: CircleBorder(),
        iconSize: AppSizes.iconMd,
      ),

      // ===== CARD =====
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight, // Putih bersih
        elevation: AppSizes.cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.05), // Shadow halus hitam
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        margin: const EdgeInsets.all(AppSizes.cardMargin),
        clipBehavior: Clip.antiAlias,
      ),

      // ===== SLIDER =====
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
        trackHeight: 4.0,
        thumbColor: AppColors.primary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0, elevation: 4.0),
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        activeTickMarkColor: Colors.white.withValues(alpha: 0.7),
        inactiveTickMarkColor: Colors.grey,
      ),

      // ===== SWITCH =====
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary.withValues(alpha: 0.5);
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),

      // ===== CHECKBOX =====
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: Colors.grey, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusXs)),
      ),

      // ===== RADIO =====
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.grey;
        }),
      ),

      // ===== DIVIDER =====
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight, // Pastikan ada, atau pakai Color(0xFFE5E7EB)
        thickness: AppSizes.dividerThickness,
        space: AppSizes.md,
      ),

      // ===== DRAWER =====
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppSizes.elevationLg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(AppSizes.radiusLg))),
      ),

      // ===== DIALOG =====
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        titleTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
        contentTextStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 14),
      ),

      // ===== BOTTOM SHEET =====
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl))),
      ),

      // ===== SNACKBAR =====
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[900], // Gelap agar kontras di light mode
        contentTextStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
        behavior: SnackBarBehavior.floating,
      ),

      // ===== INPUT DECORATION =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.error, width: 2)),
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondaryLight, fontSize: 14),
        hintStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 14),
      ),
      
      // ===== PAGE TRANSITIONS =====
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ========== CUSTOM ANIMATIONS (Playful Curves) ==========
  
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve quickCurve = Curves.easeOut;
  static const Curve springCurve = Curves.easeInOutBack;

  // ========== HELPER METHODS ==========
  
  static TweenAnimationBuilder<double> getButtonScaleAnimation({
    required Widget child,
    bool isPressed = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: AppSizes.durationShort),
      curve: springCurve,
      tween: Tween<double>(
        begin: 1.0,
        end: isPressed ? 0.92 : 1.0,
      ),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  static List<BoxShadow> getGlowShadow({
    Color color = AppColors.primary,
    double blur = 16,
    double spread = 2,
    double opacity = 0.5,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static BoxDecoration getGradientDecoration({
    required Gradient gradient,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusLg),
    );
  }
}