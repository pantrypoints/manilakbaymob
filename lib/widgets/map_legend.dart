import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import '../models/route_model.dart';
import '../theme.dart';

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Obx(() {
      if (!ctrl.showLegend.value) return const SizedBox.shrink();

      return Positioned(
        right: 12,
        top: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardSurface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.royalBlue.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Transport routes section ────────────────────────────
              const Text(
                'ROUTES',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              ...TransportType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _LegendLine(
                      color: ctrl.colorForType(type),
                      label: ctrl.labelForType(type),
                      isActive: ctrl.activeFilters[type] ?? true,
                      isDashed: false,
                    ),
                  )),

              // ── Sidewalk section (only when toggle is on) ──────────
              Obx(() {
                if (!ctrl.showSidewalks.value) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFF2A3E5E), height: 1),
                    const SizedBox(height: 8),
                    const Text(
                      'SIDEWALKS',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...SidewalkWidth.values.map((w) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: _LegendLine(
                            color: ctrl.colorForSidewalk(w),
                            label: ctrl.labelForSidewalk(w),
                            isActive: true,
                            isDashed: w == SidewalkWidth.impassable,
                          ),
                        )),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;
  final bool isActive;
  final bool isDashed;

  const _LegendLine({
    required this.color,
    required this.label,
    required this.isActive,
    required this.isDashed,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor =
        isActive ? color : AppColors.textMuted.withValues(alpha: 0.3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 10,
          child: CustomPaint(
            painter: _LinePainter(color: lineColor, dashed: isDashed),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.textSecondary : AppColors.textMuted,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  _LinePainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;
    if (dashed) {
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, y), Offset((x + 4).clamp(0, size.width), y), paint);
        x += 7;
      }
    } else {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.color != color || old.dashed != dashed;
}
