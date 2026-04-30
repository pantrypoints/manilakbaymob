import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/route_model.dart';
import '../data/route_data.dart';
import '../theme.dart';

/// Zoom level (approx) at which the viewport is ~5km wide on a phone screen.
/// flutter_map zoom 14 ≈ 1.5km wide on a 400px screen → zoom 13 ≈ 3km, zoom 12 ≈ 6km.
/// We use 13.0 as a comfortable threshold for ~5km width.
const double kRouteVisibleZoom = 13.0;

class MapController extends GetxController {
  // Active transport type filters
  final RxMap<TransportType, bool> activeFilters = {
    TransportType.jeepney: true,
    TransportType.bus: true,
    TransportType.tricycle: true,
    TransportType.uvExpress: true,
  }.obs;

  // Sidewalk overlay toggle
  final RxBool showSidewalks = false.obs;

  // Selected route for detail panel
  final Rx<TransportRoute?> selectedRoute = Rx<TransportRoute?>(null);

  // Show/hide legend
  final RxBool showLegend = true.obs;

  // Current zoom level — updated from map camera callbacks
  final RxDouble currentZoom = 11.5.obs;

  /// True when the map is zoomed in enough to render route overlays.
  bool get isZoomedIn => currentZoom.value >= kRouteVisibleZoom;

  // All routes
  List<TransportRoute> get allRoutes => RouteData.allRoutes;

  // All sidewalk segments
  List<SidewalkSegment> get allSidewalks => RouteData.allSidewalks;

  // Filtered visible routes (only when zoomed in)
  List<TransportRoute> get visibleRoutes {
    if (!isZoomedIn) return [];
    return allRoutes.where((r) => activeFilters[r.type] == true).toList();
  }

  // Visible sidewalks (only when zoomed in AND toggle on)
  List<SidewalkSegment> get visibleSidewalks {
    if (!isZoomedIn || !showSidewalks.value) return [];
    return allSidewalks;
  }

  void onZoomChanged(double zoom) {
    currentZoom.value = zoom;
  }

  void toggleFilter(TransportType type) {
    activeFilters[type] = !(activeFilters[type] ?? true);
    activeFilters.refresh();
  }

  void toggleSidewalks() {
    showSidewalks.value = !showSidewalks.value;
  }

  void selectRoute(TransportRoute route) {
    selectedRoute.value = route;
  }

  void clearSelection() {
    selectedRoute.value = null;
  }

  void toggleLegend() {
    showLegend.value = !showLegend.value;
  }

  Color colorForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return AppColors.jeepneyColor;
      case TransportType.bus:
        return AppColors.busColor;
      case TransportType.tricycle:
        return AppColors.tricycleColor;
      case TransportType.uvExpress:
        return AppColors.uvExpressColor;
    }
  }

  Color colorForSidewalk(SidewalkWidth width) {
    switch (width) {
      case SidewalkWidth.wide:
        return const Color(0xFF2ECC71);       // green
      case SidewalkWidth.moderate:
        return const Color(0xFFFFD600);       // yellow
      case SidewalkWidth.narrow:
        return const Color(0xFFFF8C00);       // orange
      case SidewalkWidth.veryNarrow:
        return const Color(0xFFE53935);       // red
      case SidewalkWidth.impassable:
        return const Color(0xFF1A1A1A);       // near-black
    }
  }

  String labelForSidewalk(SidewalkWidth width) {
    switch (width) {
      case SidewalkWidth.wide:
        return '≥5m';
      case SidewalkWidth.moderate:
        return '3–5m';
      case SidewalkWidth.narrow:
        return '1.2–3m';
      case SidewalkWidth.veryNarrow:
        return '<1.2m';
      case SidewalkWidth.impassable:
        return 'Impassable';
    }
  }

  IconData iconForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return Icons.directions_bus_filled;
      case TransportType.bus:
        return Icons.airport_shuttle;
      case TransportType.tricycle:
        return Icons.electric_rickshaw;
      case TransportType.uvExpress:
        return Icons.directions_car;
    }
  }

  String labelForType(TransportType type) {
    switch (type) {
      case TransportType.jeepney:
        return 'Jeepney';
      case TransportType.bus:
        return 'Bus';
      case TransportType.tricycle:
        return 'Tricycle';
      case TransportType.uvExpress:
        return 'UV Express';
    }
  }

  int routeCountForType(TransportType type) =>
      allRoutes.where((r) => r.type == type).length;
}
