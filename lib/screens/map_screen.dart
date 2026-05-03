import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart';
import '../widgets/transport_filter_bar.dart';
import '../widgets/route_detail_panel.dart';
import '../theme.dart';

/// Metro Manila bounding box (includes San Pedro, Laguna)
const _swBound = LatLng(14.30, 120.85);
const _neBound = LatLng(14.85, 121.25);

/// Initial view — matches Svelte INITIAL_VIEW
const _initialCenter = LatLng(14.556610468041919, 121.02414579541572);
const _initialZoom = 15.0;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final _fmController = fm.MapController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    
    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapController>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Full-screen map ─────────────────────────────────────────
            Positioned.fill(
              child: _buildMap(ctrl),
            ),
            // ── Top header bar ──────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(ctrl),
            ),
            // ── Left controls panel ─────────────────────────────────────
            const ControlsPanel(),
            // ── Zoom badge (bottom-center) ──────────────────────────────
            _buildZoomBadge(ctrl),
            // ── Bottom detail sheet ─────────────────────────────────────
            const RouteDetailPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(MapController ctrl) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return Container(
          color: const Color(0xFFE8E8E8),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.amber),
          ),
        );
      }

      return FadeTransition(
        opacity: _fadeAnimation,
        child: fm.FlutterMap(
          mapController: _fmController,
          options: fm.MapOptions(
            initialCenter: _initialCenter,
            initialZoom: _initialZoom,
            minZoom: 10.0,
            maxZoom: 19.0,
            // Restrict pan to Metro Manila + San Pedro bounds
            cameraConstraint: fm.CameraConstraint.contain(
              bounds: fm.LatLngBounds(_swBound, _neBound),
            ),
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
            // ── Light CartoDB tile layer ──────────────────────────────
            fm.TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.manilakbay.app',
              retinaMode: true,
              keepBuffer: 4,
              panBuffer: 2,
            ),
            // ── Single polyline layer for all visible routes ─────────
            Obx(() {
              final polylines = ctrl.allVisiblePolylines;
              return polylines.isNotEmpty
                  ? fm.PolylineLayer(polylines: polylines)
                  : const SizedBox.shrink();
            }),
            // ── Single marker layer for all visible markers ───────────
            Obx(() {
              final markers = ctrl.allVisibleMarkers;
              return markers.isNotEmpty
                  ? fm.MarkerLayer(markers: markers)
                  : const SizedBox.shrink();
            }),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(MapController ctrl) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.navigation, color: AppColors.amber, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Manilakbay',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.04,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Metro Manila Commute Guide',
              style: TextStyle(
                fontSize: 10,
                color: Color(0x80000000),
                letterSpacing: 0.06,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Panel toggle
          Obx(() => GestureDetector(
            onTap: ctrl.togglePanel,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                ctrl.showPanel.value ? Icons.close : Icons.layers,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildZoomBadge(MapController ctrl) {
    return Positioned(
      bottom: 36,
      left: 0,
      right: 0,
      child: Obx(() {
        final unlocked = ctrl.isZoomedIn;
        final zoom = ctrl.currentZoom.value;
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xF2F0FDF4)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: unlocked
                    ? const Color(0x6622C55E)
                    : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: unlocked
                      ? const Color(0x2622C55E)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              unlocked
                  ? '🗺️ Routes ON · z${zoom.toStringAsFixed(0)}'
                  : '🔍 Zoom in for routes · z${zoom.toStringAsFixed(0)}/${kRouteVisibleZoom.toInt()}',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: unlocked
                    ? AppColors.zoomUnlockedText
                    : const Color(0xFF8A8A8A),
              ),
            ),
          ),
        );
      }),
    );
  }
}

