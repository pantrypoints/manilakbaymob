import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum TransportType { jeepney, bus, tricycle, uvExpress }

class TransportRoute {
  final String id;
  final String name;
  final String shortName;
  final TransportType type;
  final List<LatLng> points;
  final String description;
  final String fare;

  const TransportRoute({
    required this.id,
    required this.name,
    required this.shortName,
    required this.type,
    required this.points,
    required this.description,
    required this.fare,
  });
}

class TransportTypeInfo {
  final TransportType type;
  final String label;
  final Color color;
  final IconData icon;

  const TransportTypeInfo({
    required this.type,
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Width categories for sidewalk segments
enum SidewalkWidth {
  wide,       // ≥5m — green
  moderate,   // 3m–5m — yellow
  narrow,     // 1.2m–3m — orange
  veryNarrow, // <1.2m — red
  impassable, // no sidewalk / blocked — black
}

class SidewalkSegment {
  final String id;
  final List<LatLng> points;
  final SidewalkWidth width;
  final String description;

  const SidewalkSegment({
    required this.id,
    required this.points,
    required this.width,
    required this.description,
  });
}
