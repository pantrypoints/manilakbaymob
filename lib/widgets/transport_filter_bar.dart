import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import '../models/route_model.dart';
import '../theme.dart';

class TransportFilterBar extends StatelessWidget {
  const TransportFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 2),
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Transport type toggles
                ...TransportType.values.map((type) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _FilterChip(
                        isActive: ctrl.activeFilters[type] ?? true,
                        color: ctrl.colorForType(type),
                        icon: ctrl.iconForType(type),
                        label: ctrl.labelForType(type),
                        count: ctrl.routeCountForType(type),
                        onTap: () => ctrl.toggleFilter(type),
                      ),
                    )),

                // Divider
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.only(right: 6),
                  color: AppColors.textMuted.withValues(alpha: 0.25),
                ),

                // Sidewalk toggle
                _FilterChip(
                  isActive: ctrl.showSidewalks.value,
                  color: const Color(0xFF2ECC71),
                  icon: Icons.accessibility_new,
                  label: 'Sidewalks',
                  count: null,
                  onTap: ctrl.toggleSidewalks,
                ),
              ],
            ),
          )),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final bool isActive;
  final Color color;
  final IconData icon;
  final String label;
  final int? count;
  final VoidCallback onTap;

  const _FilterChip({
    required this.isActive,
    required this.color,
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.18) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : AppColors.textMuted.withValues(alpha: 0.3),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? color : AppColors.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? color : AppColors.textMuted,
                letterSpacing: 0.2,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withValues(alpha: 0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isActive ? color : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
