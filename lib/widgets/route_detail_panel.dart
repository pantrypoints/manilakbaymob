import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import '../models/route_model.dart';
import '../theme.dart';

class RouteDetailPanel extends StatelessWidget {
  const RouteDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Obx(() {
      if (!ctrl.hasSelection) return const SizedBox.shrink();

      Widget content;
      if (ctrl.selectedRoute.value != null) {
        content = _RouteContent(route: ctrl.selectedRoute.value!, ctrl: ctrl);
      } else if (ctrl.selectedTricycle.value != null) {
        content = _TricycleContent(terminal: ctrl.selectedTricycle.value!);
      } else if (ctrl.selectedBicycle.value != null) {
        content = _BicycleContent(parking: ctrl.selectedBicycle.value!);
      } else if (ctrl.selectedSidewalk.value != null) {
        content = _SidewalkContent(segment: ctrl.selectedSidewalk.value!, ctrl: ctrl);
      } else {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceAlpha,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 32,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                content,
              ],
            ),
          ),
        ),
      );
    });
  }
}

// ── Shared header row ────────────────────────────────────────────────────────
class _SheetHeader extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String badge;
  final VoidCallback onClose;

  const _SheetHeader({
    required this.color,
    required this.icon,
    required this.title,
    required this.badge,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: iconColor ?? AppColors.textMuted),
          const SizedBox(width: 7),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Route content ────────────────────────────────────────────────────────────
class _RouteContent extends StatelessWidget {
  final TransportRoute route;
  final MapController ctrl;
  const _RouteContent({required this.route, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final color = ctrl.routeColor(route);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          color: color,
          icon: ctrl.iconForType(route.type),
          title: route.name,
          badge: ctrl.labelForType(route.type),
          onClose: ctrl.clearSelection,
        ),
        const SizedBox(height: 12),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        _InfoRow(
          icon: Icons.route_outlined,
          label: 'Waypoints',
          value: '${route.points.length} points',
          iconColor: color,
        ),
      ],
    );
  }
}

// ── Tricycle content ──────────────────────────────────────────────────────────
class _TricycleContent extends StatelessWidget {
  final TricycleTerminal terminal;
  const _TricycleContent({required this.terminal});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          color: AppColors.tricycleColor,
          icon: Icons.electric_rickshaw,
          title: terminal.name,
          badge: 'Tricycle Terminal',
          onClose: ctrl.clearSelection,
        ),
        const SizedBox(height: 12),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        if (terminal.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              terminal.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        if (terminal.baseFare.isNotEmpty)
          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Base fare',
            value: terminal.baseFare,
            iconColor: AppColors.tricycleColor,
          ),
        if (terminal.operatingHours.isNotEmpty)
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Hours',
            value: terminal.operatingHours,
          ),
        if (terminal.address.isNotEmpty)
          _InfoRow(
            icon: Icons.place_outlined,
            label: 'Address',
            value: terminal.address,
          ),
      ],
    );
  }
}

// ── Bicycle content ───────────────────────────────────────────────────────────
class _BicycleContent extends StatelessWidget {
  final BicycleParking parking;
  const _BicycleContent({required this.parking});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          color: AppColors.bicycleColor,
          icon: Icons.directions_bike,
          title: parking.name,
          badge: 'Bicycle Parking',
          onClose: ctrl.clearSelection,
        ),
        const SizedBox(height: 12),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        if (parking.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              parking.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        _InfoRow(
          icon: Icons.category_outlined,
          label: 'Type',
          value: parking.type,
          iconColor: AppColors.bicycleColor,
        ),
        _InfoRow(
          icon: Icons.format_list_numbered,
          label: 'Capacity',
          value: '${parking.capacity} bikes',
        ),
        _InfoRow(
          icon: parking.covered ? Icons.umbrella : Icons.wb_sunny_outlined,
          label: 'Covered',
          value: parking.covered ? 'Yes' : 'No',
        ),
        _InfoRow(
          icon: Icons.payments_outlined,
          label: 'Fee',
          value: parking.fee,
        ),
        _InfoRow(
          icon: Icons.schedule_outlined,
          label: 'Hours',
          value: parking.operatingHours,
        ),
      ],
    );
  }
}

// ── Sidewalk content ──────────────────────────────────────────────────────────
class _SidewalkContent extends StatelessWidget {
  final SidewalkSegment segment;
  final MapController ctrl;
  const _SidewalkContent({required this.segment, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final color = ctrl.colorForSidewalk(segment.width);
    final label = ctrl.labelForSidewalk(segment.width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          color: color,
          icon: Icons.accessibility_new,
          title: segment.name,
          badge: 'Sidewalk',
          onClose: ctrl.clearSelection,
        ),
        const SizedBox(height: 12),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        _InfoRow(
          icon: Icons.straighten,
          label: 'Width',
          value: segment.widthM > 0
              ? '${segment.widthM}m ($label)'
              : 'Impassable / No sidewalk',
          iconColor: color,
        ),
      ],
    );
  }
}
