import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import '../models/route_model.dart';
import '../theme.dart';

/// Left-side controls panel — matches the Svelte `.controls-panel` layout.
class ControlsPanel extends StatelessWidget {
  const ControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Positioned(
      top: 56, // below header
      left: 12,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: ctrl.showPanel.value ? 212 : 0,
            child: ctrl.showPanel.value
                ? _PanelBody(ctrl: ctrl)
                : const SizedBox.shrink(),
          )),
    );
  }
}



class _PanelBody extends StatelessWidget {
  final MapController ctrl;
  const _PanelBody({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(/* ... */),
      child: Obx(() => Column(  // ← Single Obx wrapping everything
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelToggle(ctrl: ctrl),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 4),
                const _SectionLabel('TRANSPORT ROUTES'),
                _ToggleRow(
                  label: 'Jeepney',
                  color: AppColors.jeepneyColor,
                  value: ctrl.showJeepney.value,
                  onChanged: (_) => ctrl.showJeepney.toggle(),
                ),
                _ToggleRow(
                  label: 'Bus',
                  color: AppColors.busColor,
                  value: ctrl.showBus.value,
                  onChanged: (_) => ctrl.showBus.toggle(),
                ),
                // ... all other toggles WITHOUT individual Obx
                const SizedBox(height: 6),
                const _SectionLabel('PEDESTRIAN'),
                _ToggleRow(
                  label: 'Sidewalks',
                  color: AppColors.swWide,
                  value: ctrl.showSidewalks.value,
                  onChanged: (_) => ctrl.showSidewalks.toggle(),
                  isSidewalkGradient: true,
                ),
                if (ctrl.showSidewalks.value)  // Direct check, no Obx needed
                  _SidewalkLegend(ctrl: ctrl),
                const SizedBox(height: 8),
                _ZoomStatus(ctrl: ctrl),
              ],
            ),
          ),
        ],
      )),
    );
  }
}


// class _PanelBody extends StatelessWidget {
//   final MapController ctrl;
//   const _PanelBody({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.surfaceAlpha,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x1A000000),
//             blurRadius: 16,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Header toggle button ──────────────────────────────────
//           _PanelToggle(ctrl: ctrl),

//           // ── Body ─────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(color: AppColors.divider, height: 1),
//                 const SizedBox(height: 4),

//                 // Transport routes section
//                 const _SectionLabel('TRANSPORT ROUTES'),
//                 Obx(() => _ToggleRow(
//                       label: 'Jeepney',
//                       color: AppColors.jeepneyColor,
//                       value: ctrl.showJeepney.value,
//                       onChanged: (_) => ctrl.showJeepney.toggle(),
//                     )),
//                 Obx(() => _ToggleRow(
//                       label: 'Bus',
//                       color: AppColors.busColor,
//                       value: ctrl.showBus.value,
//                       onChanged: (_) => ctrl.showBus.toggle(),
//                     )),
//                 Obx(() => _ToggleRow(
//                       label: 'UV Express',
//                       color: AppColors.uvColor,
//                       value: ctrl.showUV.value,
//                       onChanged: (_) => ctrl.showUV.toggle(),
//                     )),
//                 Obx(() => _ToggleRow(
//                       label: 'Tricycle Terminals',
//                       color: AppColors.tricycleColor,
//                       value: ctrl.showTricycle.value,
//                       onChanged: (_) => ctrl.showTricycle.toggle(),
//                     )),
//                 Obx(() => _ToggleRow(
//                       label: 'Bicycle Parking',
//                       color: AppColors.bicycleColor,
//                       value: ctrl.showBicycle.value,
//                       onChanged: (_) => ctrl.showBicycle.toggle(),
//                     )),

//                 const SizedBox(height: 6),

//                 // Pedestrian section
//                 const _SectionLabel('PEDESTRIAN'),
//                 Obx(() => _ToggleRow(
//                       label: 'Sidewalks',
//                       color: AppColors.swWide,
//                       value: ctrl.showSidewalks.value,
//                       onChanged: (_) => ctrl.showSidewalks.toggle(),
//                       isSidewalkGradient: true,
//                     )),

//                 // Sidewalk sub-legend
//                 Obx(() {
//                   if (!ctrl.showSidewalks.value) return const SizedBox.shrink();
//                   return _SidewalkLegend(ctrl: ctrl);
//                 }),

//                 const SizedBox(height: 8),

//                 // Zoom status indicator
//                 Obx(() => _ZoomStatus(ctrl: ctrl)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _PanelToggle extends StatelessWidget {
  final MapController ctrl;
  const _PanelToggle({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ctrl.togglePanel,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            const Icon(Icons.layers_outlined,
                size: 16, color: AppColors.amber),
            const SizedBox(width: 8),
            const Text(
              'Layers',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.04,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Obx(() => Icon(
                  ctrl.showPanel.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.textMuted,
                )),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final Color color;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isSidewalkGradient;

  const _ToggleRow({
    required this.label,
    required this.color,
    required this.value,
    required this.onChanged,
    this.isSidewalkGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: value
              ? Colors.black.withValues(alpha: 0.02)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            // Color indicator
            if (isSidewalkGradient)
              Container(
                width: 20,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.swWide,
                      AppColors.swModerate,
                      AppColors.swNarrow,
                      AppColors.swVeryNarrow,
                      AppColors.swImpassable,
                    ],
                  ),
                ),
              )
            else
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: value ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value ? color : AppColors.textMuted,
                    width: 1.5,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  color: value
                      ? AppColors.textSecondary
                      : AppColors.textMuted,
                  fontWeight:
                      value ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              value ? Icons.visibility : Icons.visibility_off,
              size: 12,
              color: value
                  ? AppColors.textSecondary
                  : AppColors.textMuted.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidewalkLegend extends StatelessWidget {
  final MapController ctrl;
  const _SidewalkLegend({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 2),
      child: Column(
        children: SidewalkWidth.values.map((w) {
          final color = ctrl.colorForSidewalk(w);
          final label = ctrl.labelForSidewalk(w);
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textLabel,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ZoomStatus extends StatelessWidget {
  final MapController ctrl;
  const _ZoomStatus({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final locked = !ctrl.isZoomedIn;
    final zoom = ctrl.currentZoom.value;
    final threshold = kRouteVisibleZoom.toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: locked
            ? AppColors.zoomLockedBg
            : AppColors.zoomUnlockedBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: locked
              ? const Color(0x4DF59E0B)
              : const Color(0x4D22C55E),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.place_outlined,
            size: 11,
            color: locked
                ? AppColors.zoomLockedText
                : AppColors.zoomUnlockedText,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              locked
                  ? 'Zoom in for routes (≥$threshold)'
                  : 'Routes ON · z${zoom.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 10,
                color: locked
                    ? AppColors.zoomLockedText
                    : AppColors.zoomUnlockedText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
