import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

class RouteData {
  static List<TransportRoute> get allRoutes => [
        ..._jeepneyRoutes,
        ..._busRoutes,
        ..._tricycleRoutes,
        ..._uvExpressRoutes,
      ];

  static List<SidewalkSegment> get allSidewalks => _sidewalkSegments;

  // ─── JEEPNEY ROUTES ──────────────────────────────────────────────────────
  static final List<TransportRoute> _jeepneyRoutes = [
    TransportRoute(
      id: 'j1',
      name: 'Quiapo – Divisoria',
      shortName: 'Quiapo-Divisoria',
      type: TransportType.jeepney,
      fare: '₱13 base fare',
      description: 'Along Quezon Blvd via Divisoria Market',
      points: [
        LatLng(14.5995, 120.9842), // Quiapo Church
        LatLng(14.6010, 120.9835),
        LatLng(14.6030, 120.9810),
        LatLng(14.6050, 120.9790),
        LatLng(14.6080, 120.9770),
        LatLng(14.6100, 120.9740), // Divisoria
      ],
    ),
    TransportRoute(
      id: 'j2',
      name: 'SM North EDSA – Fairview',
      shortName: 'SM North-Fairview',
      type: TransportType.jeepney,
      fare: '₱13 base fare',
      description: 'Via Commonwealth Ave to Fairview',
      points: [
        LatLng(14.6565, 121.0326), // SM North EDSA
        LatLng(14.6620, 121.0350),
        LatLng(14.6680, 121.0380),
        LatLng(14.6750, 121.0420),
        LatLng(14.6820, 121.0460),
        LatLng(14.6900, 121.0510),
        LatLng(14.6980, 121.0570), // Fairview
      ],
    ),
    TransportRoute(
      id: 'j3',
      name: 'Cubao – Marikina',
      shortName: 'Cubao-Marikina',
      type: TransportType.jeepney,
      fare: '₱13 base fare',
      description: 'Via Aurora Blvd to Marikina',
      points: [
        LatLng(14.6190, 121.0530), // Cubao
        LatLng(14.6210, 121.0620),
        LatLng(14.6240, 121.0720),
        LatLng(14.6260, 121.0820),
        LatLng(14.6280, 121.0920),
        LatLng(14.6300, 121.1020), // Marikina
      ],
    ),
    TransportRoute(
      id: 'j4',
      name: 'Baclaran – Pasay',
      shortName: 'Baclaran-Pasay',
      type: TransportType.jeepney,
      fare: '₱13 base fare',
      description: 'Along Roxas Blvd coastal route',
      points: [
        LatLng(14.5338, 120.9983), // Baclaran
        LatLng(14.5380, 120.9950),
        LatLng(14.5420, 120.9920),
        LatLng(14.5460, 120.9900),
        LatLng(14.5500, 120.9870),
        LatLng(14.5540, 120.9850), // Pasay
      ],
    ),
    TransportRoute(
      id: 'j5',
      name: 'Espana – Blumentritt',
      shortName: 'Espana-Blumentritt',
      type: TransportType.jeepney,
      fare: '₱13 base fare',
      description: 'University Belt route',
      points: [
        LatLng(14.6100, 120.9890), // UST Espana
        LatLng(14.6120, 120.9870),
        LatLng(14.6140, 120.9855),
        LatLng(14.6160, 120.9840),
        LatLng(14.6180, 120.9820),
        LatLng(14.6200, 120.9800), // Blumentritt
      ],
    ),
  ];

  // ─── BUS ROUTES ──────────────────────────────────────────────────────────
  static final List<TransportRoute> _busRoutes = [
    TransportRoute(
      id: 'b1',
      name: 'EDSA Carousel',
      shortName: 'EDSA Carousel',
      type: TransportType.bus,
      fare: '₱15–₱30',
      description: 'P2P Bus Rapid Transit along EDSA',
      points: [
        LatLng(14.5318, 121.0014), // Baclaran
        LatLng(14.5480, 121.0000),
        LatLng(14.5650, 120.9980),
        LatLng(14.5820, 120.9970),
        LatLng(14.5990, 120.9950),
        LatLng(14.6150, 120.9940),
        LatLng(14.6310, 121.0050),
        LatLng(14.6470, 121.0200),
        LatLng(14.6565, 121.0326), // SM North EDSA
      ],
    ),
    TransportRoute(
      id: 'b2',
      name: 'Alabang – Makati P2P',
      shortName: 'Alabang-Makati',
      type: TransportType.bus,
      fare: '₱65',
      description: 'Point-to-point express via South Luzon Expressway',
      points: [
        LatLng(14.4200, 121.0340), // Alabang
        LatLng(14.4400, 121.0300),
        LatLng(14.4600, 121.0200),
        LatLng(14.4800, 121.0100),
        LatLng(14.5000, 121.0000),
        LatLng(14.5200, 120.9900),
        LatLng(14.5500, 121.0150), // Makati
      ],
    ),
    TransportRoute(
      id: 'b3',
      name: 'Fairview – Quiapo',
      shortName: 'Fairview-Quiapo',
      type: TransportType.bus,
      fare: '₱20–₱35',
      description: 'Via Commonwealth Ave and España',
      points: [
        LatLng(14.6980, 121.0570), // Fairview
        LatLng(14.6870, 121.0490),
        LatLng(14.6750, 121.0400),
        LatLng(14.6600, 121.0300),
        LatLng(14.6400, 121.0150),
        LatLng(14.6200, 120.9980),
        LatLng(14.6050, 120.9890),
        LatLng(14.5995, 120.9842), // Quiapo
      ],
    ),
    TransportRoute(
      id: 'b4',
      name: 'Cubao – Marikina P2P',
      shortName: 'Cubao-Marikina P2P',
      type: TransportType.bus,
      fare: '₱60',
      description: 'Express P2P via Aurora Blvd',
      points: [
        LatLng(14.6190, 121.0530), // Cubao
        LatLng(14.6230, 121.0650),
        LatLng(14.6270, 121.0780),
        LatLng(14.6310, 121.0920),
        LatLng(14.6350, 121.1050), // Marikina
      ],
    ),
  ];

  // ─── TRICYCLE ROUTES ─────────────────────────────────────────────────────
  static final List<TransportRoute> _tricycleRoutes = [
    TransportRoute(
      id: 't1',
      name: 'Mandaluyong Loop',
      shortName: 'Mandaluyong Loop',
      type: TransportType.tricycle,
      fare: '₱10–₱20',
      description: 'Inner Mandaluyong residential areas',
      points: [
        LatLng(14.5794, 121.0359), // Shaw Blvd
        LatLng(14.5810, 121.0390),
        LatLng(14.5830, 121.0410),
        LatLng(14.5850, 121.0400),
        LatLng(14.5840, 121.0375),
        LatLng(14.5820, 121.0360),
        LatLng(14.5794, 121.0359),
      ],
    ),
    TransportRoute(
      id: 't2',
      name: 'Las Piñas Feeder',
      shortName: 'Las Piñas Loop',
      type: TransportType.tricycle,
      fare: '₱10–₱20',
      description: 'Las Piñas barangay connector routes',
      points: [
        LatLng(14.4493, 120.9800), // Las Piñas area
        LatLng(14.4520, 120.9820),
        LatLng(14.4550, 120.9850),
        LatLng(14.4540, 120.9880),
        LatLng(14.4510, 120.9870),
        LatLng(14.4490, 120.9840),
        LatLng(14.4493, 120.9800),
      ],
    ),
    TransportRoute(
      id: 't3',
      name: 'Caloocan Inner Routes',
      shortName: 'Caloocan Loop',
      type: TransportType.tricycle,
      fare: '₱10–₱20',
      description: 'Caloocan residential feeder',
      points: [
        LatLng(14.6497, 120.9673), // Caloocan
        LatLng(14.6520, 120.9700),
        LatLng(14.6545, 120.9710),
        LatLng(14.6535, 120.9690),
        LatLng(14.6515, 120.9670),
        LatLng(14.6497, 120.9673),
      ],
    ),
    TransportRoute(
      id: 't4',
      name: 'Malabon – Navotas',
      shortName: 'Malabon-Navotas',
      type: TransportType.tricycle,
      fare: '₱10–₱25',
      description: 'North Manila coastal connector',
      points: [
        LatLng(14.6629, 120.9563), // Malabon
        LatLng(14.6600, 120.9520),
        LatLng(14.6570, 120.9500),
        LatLng(14.6540, 120.9490),
        LatLng(14.6520, 120.9480), // Navotas
      ],
    ),
  ];

  // ─── UV EXPRESS ROUTES ───────────────────────────────────────────────────
  static final List<TransportRoute> _uvExpressRoutes = [
    TransportRoute(
      id: 'uv1',
      name: 'Eastwood – Makati',
      shortName: 'Eastwood-Makati',
      type: TransportType.uvExpress,
      fare: '₱60–₱80',
      description: 'Express via C5 and Kalayaan Ave',
      points: [
        LatLng(14.6096, 121.0822), // Eastwood
        LatLng(14.6000, 121.0700),
        LatLng(14.5900, 121.0600),
        LatLng(14.5800, 121.0500),
        LatLng(14.5700, 121.0400),
        LatLng(14.5600, 121.0300),
        LatLng(14.5500, 121.0200), // Makati BGC area
      ],
    ),
    TransportRoute(
      id: 'uv2',
      name: 'Alabang – Makati UV',
      shortName: 'Alabang-Makati UV',
      type: TransportType.uvExpress,
      fare: '₱70–₱100',
      description: 'UV Express via SLEX and Skyway',
      points: [
        LatLng(14.4220, 121.0390), // Alabang Terminal
        LatLng(14.4500, 121.0280),
        LatLng(14.4800, 121.0200),
        LatLng(14.5100, 121.0200),
        LatLng(14.5350, 121.0250),
        LatLng(14.5540, 121.0150), // Makati
      ],
    ),
    TransportRoute(
      id: 'uv3',
      name: 'Novaliches – Cubao',
      shortName: 'Novaliches-Cubao',
      type: TransportType.uvExpress,
      fare: '₱50–₱70',
      description: 'Via Quirino Highway and EDSA',
      points: [
        LatLng(14.7270, 121.0340), // Novaliches
        LatLng(14.7100, 121.0330),
        LatLng(14.6930, 121.0320),
        LatLng(14.6750, 121.0310),
        LatLng(14.6565, 121.0326),
        LatLng(14.6400, 121.0280),
        LatLng(14.6190, 121.0530), // Cubao
      ],
    ),
    TransportRoute(
      id: 'uv4',
      name: 'Monumento – Divisoria UV',
      shortName: 'Monumento-Divisoria',
      type: TransportType.uvExpress,
      fare: '₱30–₱45',
      description: 'Via Rizal Ave Extension',
      points: [
        LatLng(14.6540, 120.9830), // Monumento
        LatLng(14.6450, 120.9820),
        LatLng(14.6350, 120.9800),
        LatLng(14.6250, 120.9780),
        LatLng(14.6150, 120.9770),
        LatLng(14.6080, 120.9760),
        LatLng(14.6100, 120.9740), // Divisoria
      ],
    ),
  ];

  // ─── SIDEWALK SEGMENTS ───────────────────────────────────────────────────
  // Concentrated around Cubao, Quiapo, and Makati for demo density
  static final List<SidewalkSegment> _sidewalkSegments = [
    // ── Cubao area ──────────────────────────────────────────────────────
    SidewalkSegment(
      id: 'sw1',
      width: SidewalkWidth.wide,
      description: 'EDSA-Cubao main sidewalk (≥5m)',
      points: [
        LatLng(14.6200, 121.0500),
        LatLng(14.6210, 121.0520),
        LatLng(14.6220, 121.0540),
        LatLng(14.6230, 121.0560),
      ],
    ),
    SidewalkSegment(
      id: 'sw2',
      width: SidewalkWidth.moderate,
      description: 'Aurora Blvd sidewalk (3–5m)',
      points: [
        LatLng(14.6180, 121.0490),
        LatLng(14.6190, 121.0510),
        LatLng(14.6200, 121.0530),
        LatLng(14.6210, 121.0550),
      ],
    ),
    SidewalkSegment(
      id: 'sw3',
      width: SidewalkWidth.narrow,
      description: 'Gen. Romulo Ave (1.2–3m)',
      points: [
        LatLng(14.6195, 121.0480),
        LatLng(14.6185, 121.0465),
        LatLng(14.6175, 121.0450),
      ],
    ),
    SidewalkSegment(
      id: 'sw4',
      width: SidewalkWidth.veryNarrow,
      description: 'Side street near Araneta (<1.2m)',
      points: [
        LatLng(14.6165, 121.0445),
        LatLng(14.6158, 121.0435),
        LatLng(14.6150, 121.0425),
      ],
    ),
    SidewalkSegment(
      id: 'sw5',
      width: SidewalkWidth.impassable,
      description: 'Market access road — no sidewalk',
      points: [
        LatLng(14.6145, 121.0415),
        LatLng(14.6138, 121.0405),
        LatLng(14.6130, 121.0395),
      ],
    ),

    // ── Quiapo / Binondo area ─────────────────────────────────────────
    SidewalkSegment(
      id: 'sw6',
      width: SidewalkWidth.moderate,
      description: 'Quezon Blvd walkway (3–5m)',
      points: [
        LatLng(14.6005, 120.9845),
        LatLng(14.6015, 120.9838),
        LatLng(14.6025, 120.9830),
        LatLng(14.6035, 120.9822),
      ],
    ),
    SidewalkSegment(
      id: 'sw7',
      width: SidewalkWidth.narrow,
      description: 'Hidalgo St sidewalk (1.2–3m)',
      points: [
        LatLng(14.5990, 120.9850),
        LatLng(14.5983, 120.9843),
        LatLng(14.5976, 120.9836),
      ],
    ),
    SidewalkSegment(
      id: 'sw8',
      width: SidewalkWidth.impassable,
      description: 'Underpass ramp — blocked by vendors',
      points: [
        LatLng(14.5975, 120.9830),
        LatLng(14.5970, 120.9822),
        LatLng(14.5965, 120.9815),
      ],
    ),
    SidewalkSegment(
      id: 'sw9',
      width: SidewalkWidth.veryNarrow,
      description: 'R. Hidalgo extension (<1.2m)',
      points: [
        LatLng(14.5980, 120.9860),
        LatLng(14.5974, 120.9853),
        LatLng(14.5968, 120.9847),
      ],
    ),

    // ── Makati CBD ────────────────────────────────────────────────────
    SidewalkSegment(
      id: 'sw10',
      width: SidewalkWidth.wide,
      description: 'Ayala Ave promenade (≥5m)',
      points: [
        LatLng(14.5560, 121.0170),
        LatLng(14.5548, 121.0185),
        LatLng(14.5536, 121.0200),
        LatLng(14.5524, 121.0215),
      ],
    ),
    SidewalkSegment(
      id: 'sw11',
      width: SidewalkWidth.wide,
      description: 'Paseo de Roxas (≥5m)',
      points: [
        LatLng(14.5580, 121.0155),
        LatLng(14.5567, 121.0168),
        LatLng(14.5554, 121.0181),
      ],
    ),
    SidewalkSegment(
      id: 'sw12',
      width: SidewalkWidth.moderate,
      description: 'Makati Ave sidewalk (3–5m)',
      points: [
        LatLng(14.5600, 121.0140),
        LatLng(14.5590, 121.0152),
        LatLng(14.5580, 121.0164),
        LatLng(14.5570, 121.0176),
      ],
    ),
    SidewalkSegment(
      id: 'sw13',
      width: SidewalkWidth.narrow,
      description: 'Jupiter St (1.2–3m)',
      points: [
        LatLng(14.5615, 121.0130),
        LatLng(14.5608, 121.0118),
        LatLng(14.5600, 121.0107),
      ],
    ),
    SidewalkSegment(
      id: 'sw14',
      width: SidewalkWidth.veryNarrow,
      description: 'Back alleys Poblacion (<1.2m)',
      points: [
        LatLng(14.5628, 121.0120),
        LatLng(14.5622, 121.0112),
        LatLng(14.5616, 121.0104),
      ],
    ),

    // ── EDSA corridor ────────────────────────────────────────────────
    SidewalkSegment(
      id: 'sw15',
      width: SidewalkWidth.narrow,
      description: 'EDSA near Shaw (1.2–3m)',
      points: [
        LatLng(14.5800, 121.0520),
        LatLng(14.5810, 121.0510),
        LatLng(14.5820, 121.0500),
        LatLng(14.5830, 121.0490),
      ],
    ),
    SidewalkSegment(
      id: 'sw16',
      width: SidewalkWidth.impassable,
      description: 'EDSA flyover ramp — no pedestrian path',
      points: [
        LatLng(14.5840, 121.0480),
        LatLng(14.5848, 121.0470),
        LatLng(14.5856, 121.0460),
      ],
    ),
  ];
}
