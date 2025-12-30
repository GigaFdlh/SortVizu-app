import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class SnackBarHelper {
  /// Show success message from top
  static void showSuccess(BuildContext context, String message, {IconData?  icon}) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear any existing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                message,
                style:  const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120, // ← FROM BOTTOM!  
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  /// Show info message from top
  static void showInfo(BuildContext context, String message, {IconData? icon}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors. info,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery. of(context).size.height - 120,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes. radiusMd),
        ),
      ),
    );
  }

  /// Show secondary message from top
  static void showSecondary(BuildContext context, String message, {IconData? icon}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: AppSizes. sm),
            ],
            Expanded(
              child: Text(
                message,
                style:  const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets. only(
          bottom: MediaQuery.of(context).size.height - 120,
          left:  16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}