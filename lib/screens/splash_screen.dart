import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_sizes.dart';
import 'home_screen.dart';

/// Splash Screen - First screen user sees
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ========== ANIMATION CONTROLLERS ==========
  
  late AnimationController _logoController;
  late AnimationController _barsController;
  late AnimationController _textController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;

  // ========== SORTING BARS DATA ==========
  
  List<double> _barHeights = [];
  final int _barCount = 7;
  bool _isSorting = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateBars();
    _startSequence();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _barsController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ========== INITIALIZATION ==========

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves. elasticOut,
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _barsController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve:  Curves.easeIn,
      ),
    );
  }

  void _generateBars() {
    final random = Random();
    _barHeights = List.generate(
      _barCount,
      (index) => 30.0 + random.nextDouble() * 70.0,
    );
  }

  // ========== ANIMATION SEQUENCE ==========

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 200));
    _startSorting();

    await Future.delayed(const Duration(milliseconds: 800));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 700));
    _navigateToHome();
  }

  void _startSorting() async {
    setState(() {
      _isSorting = true;
    });

    for (int i = 0; i < _barHeights.length - 1; i++) {
      for (int j = 0; j < _barHeights.length - i - 1; j++) {
        if (! mounted) return;

        if (_barHeights[j] > _barHeights[j + 1]) {
          await Future. delayed(const Duration(milliseconds:  100));
          
          if (! mounted) return;
          
          setState(() {
            final temp = _barHeights[j];
            _barHeights[j] = _barHeights[j + 1];
            _barHeights[j + 1] = temp;
          });
        }
      }
    }

    setState(() {
      _isSorting = false;
    });
  }

  void _navigateToHome() {
    if (!mounted) return;

    Navigator. of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity:  animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ========== BUILD UI ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                _buildAnimatedBars(),

                const SizedBox(height: AppSizes.xxl),

                AnimatedBuilder(
                  animation:  _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        AppStrings. appName,
                        style:  Theme.of(context).textTheme.displayLarge?. copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                      ),
                      
                      const SizedBox(height: AppSizes.sm),

                      AnimatedBuilder(
                        animation:  _textController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: child,
                          );
                        },
                        child: Text(
                          AppStrings. appTagline,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors. textSecondary,
                                fontSize: 14,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                _buildLoadingIndicator(),

                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== WIDGETS ==========

  Widget _buildAnimatedBars() {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_barCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            width: 12,
            height: _barHeights[index],
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment. bottomCenter,
                colors: [
                  _isSorting
                      ? AppColors.barComparing
                      : AppColors.barSorted,
                  (_isSorting
                          ? AppColors.barComparing
                          : AppColors. barSorted)
                      .withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusXs),
              boxShadow: [
                BoxShadow(
                  color: (_isSorting
                          ? AppColors.barComparing
                          : AppColors.barSorted)
                      .withValues(alpha: 0.5),
                  blurRadius:  8,
                  spreadRadius: 1,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height:  40,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.primary. withValues(alpha: 0.5),
        ),
      ),
    );
  }
}