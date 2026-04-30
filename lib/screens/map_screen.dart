import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart';
import '../models/route_model.dart';
import '../widgets/transport_filter_bar.dart';
import '../widgets/route_detail_panel.dart';
import '../widgets/map_legend.dart';
import '../theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _fmController = fm.MapController();
  static const LatLng _metroCenter = LatLng(14.5995, 121.0002);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Compact title + filter bar ─────────────────────────────
            _buildTitleBar(),
            const TransportFilterBar(),
            const SizedBox(height: 2),

            // ── Map fills remaining space ──────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  _buildMap(ctrl),
                  const MapLegend(),
                  const RouteDetailPanel(),
                  _buildControls(ctrl),
                  _buildZoomHint(ctrl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      color: AppColors.navyBlue,
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: AppColors.brightGold, size: 17),
          const SizedBox(width: 7),
          const Row(
            children: [
              Text(
                'Manila',
                style: TextStyle(
                  color: AppColors.brightGold,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              Text(
                'kbay',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A1A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF2ECC71), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2ECC71),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Color(0xFF2ECC71),
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Obx(() {
            final ctrl = Get.find<MapController>();
            final zoom = ctrl.currentZoom.value;
            return Text(
              'z${zoom.toStringAsFixed(1)}',
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.6),
                fontSize: 9,
                fontFamily: 'monospace',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMap(MapController ctrl) {
    return Obx(() {
      final routes = ctrl.visibleRoutes;
      final sidewalks = ctrl.visibleSidewalks;

      return fm.FlutterMap(
        mapController: _fmController,
        options: fm.MapOptions(
          initialCenter: _metroCenter,
          initialZoom: 11.5,
          minZoom: 9.0,
          maxZoom: 18.0,
          onTap: (_, __) => ctrl.clearSelection(),
          onMapEvent: (event) {
            if (event is fm.MapEventMove ||
                event is fm.MapEventScrollWheelZoom ||
                event is fm.MapEventDoubleTapZoom ||
                event is fm.MapEventFlingAnimation) {
              ctrl.onZoomChanged(_fmController.camera.zoom);
            }
          },
        ),
        children: [
          // Dark CartoDB tiles
          fm.TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.manilakbay.app',
            retinaMode: true,
          ),

          // ── Sidewalk polylines (below transport routes) ──────────────
          if (sidewalks.isNotEmpty)
            fm.PolylineLayer(
              polylines: sidewalks
                  .map((seg) => fm.Polyline(
                        points: seg.points,
                        color: ctrl
                            .colorForSidewalk(seg.width)
                            .withValues(alpha: 0.9),
                        strokeWidth: 4.5,
                        strokeCap: StrokeCap.round,
                        strokeJoin: StrokeJoin.round,
                      ))
                  .toList(),
            ),

          // ── Transport route polylines ────────────────────────────────
          if (routes.isNotEmpty)
            fm.PolylineLayer(
              polylines: routes
                  .map((route) => fm.Polyline(
                        points: route.points,
                        color: ctrl
                            .colorForType(route.type)
                            .withValues(alpha: 0.85),
                        strokeWidth: _strokeWidth(route.type),
                        strokeCap: StrokeCap.round,
                        strokeJoin: StrokeJoin.round,
                      ))
                  .toList(),
            ),

          // ── Endpoint dots ────────────────────────────────────────────
          if (routes.isNotEmpty)
            fm.MarkerLayer(
              markers: routes
                  .expand((route) => [
                        _endpointMarker(route.points.first,
                            ctrl.colorForType(route.type)),
                        _endpointMarker(
                            route.points.last, ctrl.colorForType(route.type)),
                      ])
                  .toList(),
            ),

          // ── Tappable midpoint icon markers ───────────────────────────
          if (routes.isNotEmpty)
            fm.MarkerLayer(
              markers: routes
                  .map((route) => fm.Marker(
                        point: route.points[route.points.length ~/ 2],
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => ctrl.selectRoute(route),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ctrl
                                  .colorForType(route.type)
                                  .withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ctrl.colorForType(route.type),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              ctrl.iconForType(route.type),
                              size: 16,
                              color: ctrl.colorForType(route.type),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      );
    });
  }

  fm.Marker _endpointMarker(LatLng point, Color color) {
    return fm.Marker(
      point: point,
      width: 10,
      height: 10,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
          ],
        ),
      ),
    );
  }

  double _strokeWidth(TransportType type) {
    switch (type) {
      case TransportType.bus:
        return 5.0;
      case TransportType.uvExpress:
        return 4.0;
      case TransportType.jeepney:
        return 3.5;
      case TransportType.tricycle:
        return 2.5;
    }
  }

  /// Zoom hint banner shown when zoomed out too far to see routes
  Widget _buildZoomHint(MapController ctrl) {
    return Obx(() {
      if (ctrl.isZoomedIn) return const SizedBox.shrink();

      return Positioned(
        bottom: 70,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.navyBlue.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.brightGold.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.zoom_in,
                  size: 14,
                  color: AppColors.brightGold.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Zoom in to see routes',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Legend toggle + future controls stack in bottom-right
  Widget _buildControls(MapController ctrl) {
    return Positioned(
      right: 12,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => _ControlButton(
                icon: ctrl.showLegend.value
                    ? Icons.layers_clear
                    : Icons.layers_outlined,
                color: AppColors.brightGold,
                onTap: ctrl.toggleLegend,
                tooltip: 'Legend',
              )),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.navyBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.royalBlue.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}
