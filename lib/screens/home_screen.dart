import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_sizes.dart';
import '../core/enums/algorithm_type.dart';
import 'sorting_screen.dart';
import 'settings_screen.dart';
import 'comparison_screen.dart';

/// Home Screen - Algorithm Selection
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ========== STATE ==========

  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  
  // Variable baru untuk logika exit
  DateTime? _currentBackPressTime; 

  List<AlgorithmType> _algorithms = [
    ...getBasicAlgorithms(),
    ...getAdvancedAlgorithms(),
  ];

  int _logoTapCount = 0;
  bool _exoticUnlocked = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ========== ANIMATIONS ==========

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _updateCardAnimations();
  }

  void _updateCardAnimations() {
    _cardAnimations = List.generate(
      _algorithms.length,
      (index) {
        final start = index * 0.1;
        final end = start + 0.4;

        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );
      },
    );
  }

  // ========== ACTIONS ==========

  void _onAlgorithmSelected(AlgorithmType algorithm) {
    HapticFeedback.mediumImpact();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SortingScreen(algorithm: algorithm),
      ),
    );
  }

  void _onLogoTap() {
    setState(() {
      _logoTapCount++;
    });

    if (_logoTapCount == 3) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keep going... 🤔'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    if (_logoTapCount == 7 && !_exoticUnlocked) {
      HapticFeedback.heavyImpact();

      setState(() {
        _exoticUnlocked = true;
        _algorithms = [..._algorithms, ...getExoticAlgorithms()];

        // Re-initialize animations untuk include new cards
        _updateCardAnimations();

        // Animate new cards
        _animationController.reset();
        _animationController.forward();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.msgEasterEgg),
          duration: Duration(seconds: 3),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  // ========== BUILD UI ==========

  @override
  Widget build(BuildContext context) {
    // TAMBAHAN: Bungkus Scaffold dengan PopScope untuk logika Double Back
    return PopScope(
      canPop: false, // Mencegah langsung keluar
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        // Cek selisih waktu antar klik (misal 2 detik)
        if (_currentBackPressTime == null || 
            now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
          
          // Klik Pertama: Update waktu & Tampilkan pesan
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Press back again to exit'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating, // Agar terlihat modern
              backgroundColor: AppColors.surfaceLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          // Klik Kedua: Keluar aplikasi
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: _onLogoTap,
            child: Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.compare_arrows),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComparisonScreen(),
                  ),
                );
              },
              tooltip: 'Compare Algorithms',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
                if (mounted) {
                  setState(() {});
                }
              },
              tooltip: 'Settings',
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.surfaceGradient, // Hapus .scale(0.5) jika error, atau biarkan jika ada extension
          ),
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: AppSizes.md,
                      mainAxisSpacing: AppSizes.md,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _cardAnimations.length) {
                          return const SizedBox.shrink();
                        }

                        return AnimatedBuilder(
                          animation: _cardAnimations[index],
                          builder: (context, child) {
                            final animation = _cardAnimations[index].value;

                            return Opacity(
                              opacity: animation,
                              child: Transform.translate(
                                offset: Offset(0, 50 * (1 - animation)),
                                child: Transform.scale(
                                  scale: 0.8 + (0.2 * animation),
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: _buildAlgorithmCard(_algorithms[index]),
                        );
                      },
                      childCount: _algorithms.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.xxl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== WIDGETS ==========

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.homeTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Choose an algorithm to visualize',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          if (_logoTapCount >= 3 && !_exoticUnlocked)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Text(
                '🤫 ${7 - _logoTapCount} more taps...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          if (_exoticUnlocked)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      'Exotic Mode Unlocked!',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmCard(AlgorithmType algorithm) {
    final isExotic = algorithm.category == AlgorithmCategory.exotic;

    return Card(
      elevation: AppSizes.elevationSm,
      shadowColor: isExotic
          ? AppColors.secondary.withValues(alpha: 0.3)
          : AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: isExotic
            ? BorderSide(
                color: AppColors.secondary.withValues(alpha: 0.5),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _onAlgorithmSelected(algorithm),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            gradient: isExotic
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surface,
                      AppColors.secondary.withValues(alpha: 0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      _getAlgorithmIcon(algorithm),
                      color: AppColors.primary,
                      size: AppSizes.iconLg,
                    ),
                  ),
                  _buildDifficultyBadge(algorithm.difficultyLevel),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                algorithm.displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  algorithm.timeComplexity,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontFamily: 'JetBrains Mono',
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Expanded(
                child: Text(
                  algorithm.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(int level) {
    final colors = [
      AppColors.success,
      AppColors.warning,
      AppColors.error,
    ];

    final labels = ['Easy', 'Medium', 'Hard'];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: colors[level - 1].withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: colors[level - 1].withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        labels[level - 1],
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors[level - 1],
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                          ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      AppStrings.appVersion,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text(AppStrings.menuHome),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text(AppStrings.menuSettings),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text(AppStrings.menuAbout),
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog();
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Text(
                  'Made with ❤️ using Flutter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textDisabled,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAlgorithmIcon(AlgorithmType algorithm) {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return Icons.bubble_chart;
      case AlgorithmType.selection:
        return Icons.check_circle_outline;
      case AlgorithmType.insertion:
        return Icons.add_circle_outline;
      case AlgorithmType.merge:
        return Icons.merge_type;
      case AlgorithmType.quick:
        return Icons.flash_on;
      case AlgorithmType.heap:
        return Icons.account_tree;
      case AlgorithmType.radix:
        return Icons.filter_9_plus;
      case AlgorithmType.bogo:
        return Icons.shuffle;
      case AlgorithmType.stalin:
        return Icons.delete_sweep;
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: AppSizes.sm),
            Text(AppStrings.aboutTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.aboutDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              AppStrings.aboutBuiltWith,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              AppStrings.appVersion,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}