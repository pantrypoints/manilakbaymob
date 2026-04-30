import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import '../theme.dart';

class RouteStatBar extends StatelessWidget {
  const RouteStatBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Obx(() {
      final visible = ctrl.visibleRoutes.length;
      final total = ctrl.allRoutes.length;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.royalBlue.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.route,
              size: 14,
              color: AppColors.skyBlue,
            ),
            const SizedBox(width: 8),
            Text(
              '$visible of $total routes visible',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'Tap a route to view details',
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.7),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }
}
