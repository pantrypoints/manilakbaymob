import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

class RouteData {
  static List<TransportRoute> jeepneyRoutes = [];
  static List<TransportRoute> busRoutes = [];
  static List<TransportRoute> uvRoutes = [];
  static List<TricycleTerminal> tricycleTerminals = [];
  static List<BicycleParking> bicycleParkings = [];
  static List<SidewalkSegment> sidewalks = [];

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    await Future.wait([
      _loadJeepney(),
      _loadBus(),
      _loadUV(),
      _loadTricycle(),
      _loadBicycle(),
      _loadSidewalks(),
    ]);
  }

  static List<LatLng> _parsePath(List<dynamic> path) =>
      path.map((p) => LatLng((p[0] as num).toDouble(), (p[1] as num).toDouble())).toList();

  static Color? _parseColor(String? hex) {
    if (hex == null) return null;
    try {
      final h = hex.replaceFirst('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return null;
    }
  }

  static Future<void> _loadJeepney() async {
    final raw = await rootBundle.loadString('assets/data/jeepney_routes.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    jeepneyRoutes = (json['routes'] as List).map((r) => TransportRoute(
          id: r['id'] as String,
          name: r['name'] as String,
          type: TransportType.jeepney,
          points: _parsePath(r['path'] as List),
          overrideColor: _parseColor(r['color'] as String?),
        )).toList();
  }

  static Future<void> _loadBus() async {
    final raw = await rootBundle.loadString('assets/data/bus_routes.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    busRoutes = (json['routes'] as List).map((r) => TransportRoute(
          id: r['id'] as String,
          name: r['name'] as String,
          type: TransportType.bus,
          points: _parsePath(r['path'] as List),
          overrideColor: _parseColor(r['color'] as String?),
        )).toList();
  }

  static Future<void> _loadUV() async {
    final raw = await rootBundle.loadString('assets/data/uv_routes.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    uvRoutes = (json['routes'] as List).map((r) => TransportRoute(
          id: r['id'] as String,
          name: r['name'] as String,
          type: TransportType.uvExpress,
          points: _parsePath(r['path'] as List),
          overrideColor: _parseColor(r['color'] as String?),
        )).toList();
  }

  static Future<void> _loadTricycle() async {
    final raw = await rootBundle.loadString('assets/data/tricycle.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    tricycleTerminals = (json['terminals'] as List).map((t) => TricycleTerminal(
          name: t['name'] as String,
          position: LatLng(
            (t['lat'] as num).toDouble(),
            (t['lng'] as num).toDouble(),
          ),
          baseFare: t['base_fare'] as String? ?? '',
          operatingHours: t['operating_hours'] as String? ?? '',
          description: t['description'] as String? ?? '',
          address: t['address'] as String? ?? '',
        )).toList();
  }

  static Future<void> _loadBicycle() async {
    final raw = await rootBundle.loadString('assets/data/bicycle.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    bicycleParkings = (json['parking'] as List).map((p) => BicycleParking(
          name: p['name'] as String,
          position: LatLng(
            (p['lat'] as num).toDouble(),
            (p['lng'] as num).toDouble(),
          ),
          type: p['type'] as String? ?? '',
          capacity: (p['capacity'] as num?)?.toInt() ?? 0,
          covered: p['covered'] as bool? ?? false,
          fee: p['fee'] as String? ?? '',
          operatingHours: p['operating_hours'] as String? ?? '',
          description: p['description'] as String? ?? '',
        )).toList();
  }

  static Future<void> _loadSidewalks() async {
    final raw = await rootBundle.loadString('assets/data/sidewalks.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    sidewalks = (json['sidewalks'] as List).map((s) => SidewalkSegment(
          id: s['id'] as String,
          name: s['name'] as String,
          widthM: (s['width_m'] as num).toDouble(),
          points: _parsePath(s['path'] as List),
        )).toList();
  }
}
