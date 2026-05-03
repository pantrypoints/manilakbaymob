import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum TransportType { jeepney, bus, uvExpress, tricycle, bicycle }

/// A polyline-based transport route (jeepney, bus, UV express)
class TransportRoute {
  final String id;
  final String name;
  final TransportType type;
  final List<LatLng> points;
  final Color? overrideColor; // from JSON color field

  const TransportRoute({
    required this.id,
    required this.name,
    required this.type,
    required this.points,
    this.overrideColor,
  });
}

/// A point marker for tricycle terminals
class TricycleTerminal {
  final String name;
  final LatLng position;
  final String baseFare;
  final String operatingHours;
  final String description;
  final String address;

  const TricycleTerminal({
    required this.name,
    required this.position,
    required this.baseFare,
    required this.operatingHours,
    required this.description,
    required this.address,
  });
}

/// A point marker for bicycle parking
class BicycleParking {
  final String name;
  final LatLng position;
  final String type;
  final int capacity;
  final bool covered;
  final String fee;
  final String operatingHours;
  final String description;

  const BicycleParking({
    required this.name,
    required this.position,
    required this.type,
    required this.capacity,
    required this.covered,
    required this.fee,
    required this.operatingHours,
    required this.description,
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

SidewalkWidth sidewalkWidthFromMeters(double m) {
  if (m >= 5) return SidewalkWidth.wide;
  if (m >= 3) return SidewalkWidth.moderate;
  if (m >= 1.2) return SidewalkWidth.narrow;
  if (m > 0) return SidewalkWidth.veryNarrow;
  return SidewalkWidth.impassable;
}

class SidewalkSegment {
  final String id;
  final String name;
  final double widthM;
  final SidewalkWidth width;
  final List<LatLng> points;

  SidewalkSegment({
    required this.id,
    required this.name,
    required this.widthM,
    required this.points,
  }) : width = sidewalkWidthFromMeters(widthM);
}
