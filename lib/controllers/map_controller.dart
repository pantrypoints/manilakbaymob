import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';
import '../data/route_data.dart';
import '../theme.dart';
import 'dart:async';


/// Zoom ≥14 → viewport is roughly 2–3km wide → routes are legible.
/// Matches the Svelte ROUTE_ZOOM_THRESHOLD = 14.
const double kRouteVisibleZoom = 14.0;

class MapController extends GetxController {
  // ── Loading ────────────────────────────────────────────────────────────
  final RxBool isLoading = true.obs;

  // ── Layer toggles (matches Svelte defaults) ────────────────────────────
  final RxBool showJeepney = true.obs;
  final RxBool showBus = true.obs;
  final RxBool showUV = true.obs;
  final RxBool showTricycle = false.obs;
  final RxBool showBicycle = false.obs;
  final RxBool showSidewalks = false.obs;

  // ── UI state ───────────────────────────────────────────────────────────
  final RxBool showPanel = true.obs; // left controls panel
  final RxDouble currentZoom = 15.0.obs;

  // Selected item for bottom sheet
  final Rx<TransportRoute?> selectedRoute = Rx(null);
  final Rx<TricycleTerminal?> selectedTricycle = Rx(null);
  final Rx<BicycleParking?> selectedBicycle = Rx(null);
  final Rx<SidewalkSegment?> selectedSidewalk = Rx(null);

  bool get isZoomedIn => currentZoom.value >= kRouteVisibleZoom;

  // ── Data accessors ─────────────────────────────────────────────────────
  List<TransportRoute> get visibleJeepneys =>
      isZoomedIn && showJeepney.value ? RouteData.jeepneyRoutes : [];

  List<TransportRoute> get visibleBuses =>
      isZoomedIn && showBus.value ? RouteData.busRoutes : [];

  List<TransportRoute> get visibleUV =>
      isZoomedIn && showUV.value ? RouteData.uvRoutes : [];

  List<TricycleTerminal> get visibleTricycles =>
      isZoomedIn && showTricycle.value ? RouteData.tricycleTerminals : [];

  List<BicycleParking> get visibleBicycles =>
      isZoomedIn && showBicycle.value ? RouteData.bicycleParkings : [];

  List<SidewalkSegment> get visibleSidewalks =>
      isZoomedIn && showSidewalks.value ? RouteData.sidewalks : [];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await RouteData.load();
    isLoading.value = false;
  }

  // void onZoomChanged(double zoom) => currentZoom.value = zoom;
  void togglePanel() => showPanel.value = !showPanel.value;

  void selectRoute(TransportRoute r) {
    _clearAll();
    selectedRoute.value = r;
  }

  void selectTricycle(TricycleTerminal t) {
    _clearAll();
    selectedTricycle.value = t;
  }

  void selectBicycle(BicycleParking b) {
    _clearAll();
    selectedBicycle.value = b;
  }

  void selectSidewalk(SidewalkSegment s) {
    _clearAll();
    selectedSidewalk.value = s;
  }

  void clearSelection() => _clearAll();

  void _clearAll() {
    selectedRoute.value = null;
    selectedTricycle.value = null;
    selectedBicycle.value = null;
    selectedSidewalk.value = null;
  }

  bool get hasSelection =>
      selectedRoute.value != null ||
      selectedTricycle.value != null ||
      selectedBicycle.value != null ||
      selectedSidewalk.value != null;

  // ── Color / icon helpers ───────────────────────────────────────────────
  Color routeColor(TransportRoute r) =>
      r.overrideColor ?? defaultColorForType(r.type);

  Color defaultColorForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return AppColors.jeepneyColor;
      case TransportType.bus:
        return AppColors.busColor;
      case TransportType.uvExpress:
        return AppColors.uvColor;
      case TransportType.tricycle:
        return AppColors.tricycleColor;
      case TransportType.bicycle:
        return AppColors.bicycleColor;
    }
  }

  Color colorForSidewalk(SidewalkWidth w) {
    switch (w) {
      case SidewalkWidth.wide:
        return AppColors.swWide;
      case SidewalkWidth.moderate:
        return AppColors.swModerate;
      case SidewalkWidth.narrow:
        return AppColors.swNarrow;
      case SidewalkWidth.veryNarrow:
        return AppColors.swVeryNarrow;
      case SidewalkWidth.impassable:
        return AppColors.swImpassable;
    }
  }

  String labelForSidewalk(SidewalkWidth w) {
    switch (w) {
      case SidewalkWidth.wide:
        return '≥ 5m';
      case SidewalkWidth.moderate:
        return '3m – 5m';
      case SidewalkWidth.narrow:
        return '1.2m – 3m';
      case SidewalkWidth.veryNarrow:
        return '< 1.2m';
      case SidewalkWidth.impassable:
        return 'Impassable / None';
    }
  }

  IconData iconForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return Icons.directions_bus_filled;
      case TransportType.bus:
        return Icons.airport_shuttle;
      case TransportType.uvExpress:
        return Icons.directions_car;
      case TransportType.tricycle:
        return Icons.electric_rickshaw;
      case TransportType.bicycle:
        return Icons.directions_bike;
    }
  }

  String labelForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return 'Jeepney';
      case TransportType.bus:
        return 'Bus';
      case TransportType.uvExpress:
        return 'UV Express';
      case TransportType.tricycle:
        return 'Tricycle Terminal';
      case TransportType.bicycle:
        return 'Bicycle Parking';
    }
  }

  double strokeWidthForType(TransportType type) {
    switch (type) {
      case TransportType.bus:
        return 5.0;
      case TransportType.uvExpress:
        return 4.0;
      case TransportType.jeepney:
        return 4.0;
      default:
        return 3.0;
    }
  }

  // ── Combined layer getters for performance ──────────────────────────

  /// Combined polylines for all visible transport types
  List<fm.Polyline> get allVisiblePolylines {
    final polylines = <fm.Polyline>[];
    if (!isZoomedIn) return polylines;

    // Add route polylines
    void addRoutes(List<TransportRoute> routes) {
      for (final r in routes) {
        polylines.add(
          fm.Polyline(
            points: r.points,
            color: routeColor(r).withValues(alpha: 0.85),
            strokeWidth: strokeWidthForType(r.type),
            strokeCap: StrokeCap.round,
            strokeJoin: StrokeJoin.round,
          ),
        );
      }
    }

    if (showJeepney.value) addRoutes(visibleJeepneys);
    if (showBus.value) addRoutes(visibleBuses);
    if (showUV.value) addRoutes(visibleUV);

    // Add sidewalk polylines
    if (showSidewalks.value) {
      for (final s in visibleSidewalks) {
        polylines.add(
          fm.Polyline(
            points: s.points,
            color: colorForSidewalk(s.width).withValues(alpha: 0.9),
            strokeWidth: 5.0,
            strokeCap: StrokeCap.round,
            strokeJoin: StrokeJoin.round,
          ),
        );
      }
    }

    return polylines;
  }

  /// Combined markers for all visible transport types
  List<fm.Marker> get allVisibleMarkers {
    final markers = <fm.Marker>[];
    if (!isZoomedIn) return markers;

    // Add route midpoint markers
    void addRouteMarkers(List<TransportRoute> routes) {
      for (final route in routes) {
        final mid = route.points[route.points.length ~/ 2];
        final color = routeColor(route);
        markers.add(
          fm.Marker(
            point: mid,
            width: 38,
            height: 38,
            child: GestureDetector(
              onTap: () => selectRoute(route),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(iconForType(route.type), size: 16, color: color),
              ),
            ),
          ),
        );
      }
    }

    if (showJeepney.value) addRouteMarkers(visibleJeepneys);
    if (showBus.value) addRouteMarkers(visibleBuses);
    if (showUV.value) addRouteMarkers(visibleUV);

    // Add tricycle terminal markers
    if (showTricycle.value) {
      for (final t in visibleTricycles) {
        markers.add(
          fm.Marker(
            point: t.position,
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => selectTricycle(t),
              child: _buildEmojiMarker('🛺', AppColors.tricycleColor),
            ),
          ),
        );
      }
    }

    // Add bicycle parking markers
    if (showBicycle.value) {
      for (final b in visibleBicycles) {
        markers.add(
          fm.Marker(
            point: b.position,
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => selectBicycle(b),
              child: _buildEmojiMarker('🚲', AppColors.bicycleColor),
            ),
          ),
        );
      }
    }

    return markers;
  }

  // Helper to build emoji markers
  Widget _buildEmojiMarker(String emoji, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Timer? _zoomThrottle;
  
  void onZoomChanged(double zoom) {
    // Throttle zoom updates to reduce rebuilds
    _zoomThrottle?.cancel();
    _zoomThrottle = Timer(const Duration(milliseconds: 150), () {
      currentZoom.value = zoom;
    });
  }
  
  @override
  void onClose() {
    _zoomThrottle?.cancel();
    super.onClose();
  }
}
