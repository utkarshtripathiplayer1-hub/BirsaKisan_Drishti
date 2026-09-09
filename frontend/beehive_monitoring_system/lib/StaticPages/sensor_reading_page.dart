import 'package:flutter/material.dart';

class SensorReadingPage extends StatelessWidget {
  const SensorReadingPage({super.key});

  // ==============================================================
  // COLORS
  // ==============================================================

  static const Color backgroundColor = Color(0xFFFFFEEA);
  static const Color headerColor = Color(0xFFE4C274);
  static const Color darkBrown = Color(0xFF5C4724);
  static const Color borderColor = Color(0xFFC98D26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),

        titleSpacing: 0,

        title: const Text(
          'SENSOR READING',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TIME FILTER
              // ==================================================

              _buildTimeFilter(),

              const SizedBox(height: 33),

              // ==================================================
              // SENSOR GRID
              // ==================================================
              GridView.count(
                crossAxisCount: 2,

                crossAxisSpacing: 24,
                mainAxisSpacing: 15,

                childAspectRatio: 1.42,

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  // BROOD TEMPERATURE
                  _sensorCard(
                    title: 'BROOD TEMPERATURE',
                    value: '35.6',
                    iconPath: 'assets/images/ventilation.png',
                    graphType: SensorGraphType.blue,
                  ),

                  // OVERALL TEMPERATURE
                  _sensorCard(
                    title: 'OVERALL TEMPERATURE',
                    value: '35.6',
                    iconPath: 'assets/images/ventilation.png',
                    graphType: SensorGraphType.green,
                  ),

                  // HUMIDITY
                  _sensorCard(
                    title: 'HUMIDITY',
                    value: '65%',
                    iconPath: 'assets/images/humidity.png',
                    graphType: SensorGraphType.purple,
                  ),

                  // HIVE WEIGHT
                  _sensorCard(
                    title: 'HIVE WEIGHT',
                    value: '35.6KGS',
                    iconPath: 'assets/images/fungal_risk.png',
                    graphType: SensorGraphType.orange,
                  ),

                  // VIBRATIONS
                  _sensorCard(
                    title: 'VIBRATIONS',
                    value: '26',
                    iconPath: 'assets/images/fungal_risk.png',
                    graphType: SensorGraphType.green,
                  ),

                  // CARBON DIOXIDE
                  _sensorCard(
                    title: 'CARBON DIOXIDE',
                    value: '540PPM',
                    iconPath: 'assets/images/carbon_dioxide.png',
                    graphType: SensorGraphType.orange,
                  ),

                  // VOC GASES
                  _sensorCard(
                    title: 'VOC GASES',
                    value: '0.18PPM',
                    iconPath: 'assets/images/voc_gases.png',
                    graphType: SensorGraphType.orange,
                  ),

                  // HAZARD
                  _sensorCard(
                    title: 'HAZARD DETECTED',
                    value: '1',
                    iconPath: 'assets/images/hazard_detected.png',
                    graphType: SensorGraphType.blue,
                  ),
                ],
              ),

              const SizedBox(height: 21),

              // ==================================================
              // NORMAL RANGE MESSAGE
              // ==================================================
              _buildNormalRangeMessage(),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // TIME FILTER
  // ==============================================================

  Widget _buildTimeFilter() {
    return Container(
      width: double.infinity,
      height: 60,

      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C9),

        border: Border.all(color: const Color(0xFFDCAF58), width: 3),

        borderRadius: BorderRadius.circular(18),
      ),

      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Text('Live', style: TextStyle(fontSize: 22, color: darkBrown)),

          Text('1H', style: TextStyle(fontSize: 22, color: darkBrown)),

          Text('6H', style: TextStyle(fontSize: 22, color: darkBrown)),

          Text('7D', style: TextStyle(fontSize: 22, color: darkBrown)),

          Text('1M', style: TextStyle(fontSize: 22, color: darkBrown)),
        ],
      ),
    );
  }

  // ==============================================================
  // SENSOR CARD
  // ==============================================================

  // Widget _sensorCard({
  //   required String title,
  //   required String value,
  //   required String iconPath,
  //   required SensorGraphType graphType,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFFFEF8),

  //       border: Border.all(color: borderColor, width: 1.8),

  //       borderRadius: BorderRadius.circular(17),
  //     ),

  //     padding: const EdgeInsets.fromLTRB(10, 12, 7, 5),

  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // ======================================================
  //         // ICON + SENSOR NAME
  //         // ======================================================

  //         Expanded(
  //           flex: 7,

  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,

  //             children: [
  //               // ------------------------------------------------
  //               // ICON
  //               // ------------------------------------------------

  //               SizedBox(
  //                 width: 55,
  //                 height: 55,

  //                 child: Image.asset(
  //                   iconPath,
  //                   fit: BoxFit.contain,

  //                   errorBuilder: (context, error, stackTrace) {
  //                     return const SizedBox(width: 55, height: 55);
  //                   },
  //                 ),
  //               ),

  //               const SizedBox(width: 8),

  //               // ------------------------------------------------
  //               // TEXT
  //               // ------------------------------------------------
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,

  //                   children: [
  //                     const SizedBox(height: 1),

  //                     Text(
  //                       title,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,

  //                       style: const TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),

  //                     const SizedBox(height: 3),

  //                     Text(
  //                       value,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,

  //                       style: const TextStyle(
  //                         fontSize: 7,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // ======================================================
  //         // GRAPH
  //         // ======================================================
  //         Expanded(
  //           flex: 5,

  //           child: CustomPaint(
  //             painter: SensorGraphPainter(type: graphType),

  //             size: Size.infinite,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _sensorCard({
    required String title,
    required String value,
    required String iconPath,
    required SensorGraphType graphType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),
        border: Border.all(color: borderColor, width: 1.8),
        borderRadius: BorderRadius.circular(17),
      ),

      padding: const EdgeInsets.fromLTRB(9, 10, 7, 5),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // ICON + TEXT
          // ======================================================

          Expanded(
            flex: 7,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ------------------------------------------------
                // ICON
                // ------------------------------------------------

                SizedBox(
                  width: 48,
                  height: 48,

                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 48, height: 48);
                    },
                  ),
                ),

                const SizedBox(width: 6),

                // ------------------------------------------------
                // TEXT
                // ------------------------------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // SENSOR NAME
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // SENSOR VALUE
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,

                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,

                            child: Text(
                              value,
                              maxLines: 1,

                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // GRAPH
          // ======================================================
          Expanded(
            flex: 5,

            child: CustomPaint(
              painter: SensorGraphPainter(type: graphType),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
  // ==============================================================
  // NORMAL RANGE MESSAGE
  // ==============================================================

  Widget _buildNormalRangeMessage() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      decoration: BoxDecoration(
        color: const Color(0xFFEBD293),
        borderRadius: BorderRadius.circular(35),
      ),

      child: const Text(
        'All Sensor Readings are in Normal Range',
        style: TextStyle(
          fontSize: 15,
          height: 1.05,
          fontWeight: FontWeight.w500,
          color: darkBrown,
        ),
      ),
    );
  }
}

// ==================================================================
// SENSOR GRAPH TYPE
// ==================================================================

enum SensorGraphType { green, blue, orange, purple }

// ==================================================================
// SENSOR GRAPH PAINTER
// ==================================================================

class SensorGraphPainter extends CustomPainter {
  final SensorGraphType type;

  SensorGraphPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    // --------------------------------------------------------------
    // GRAPH COLOR
    // --------------------------------------------------------------

    Color graphColor;

    switch (type) {
      case SensorGraphType.green:
        graphColor = const Color(0xFF52B788);
        break;

      case SensorGraphType.blue:
        graphColor = const Color(0xFF4C9BE8);
        break;

      case SensorGraphType.orange:
        graphColor = const Color(0xFFF2A65A);
        break;

      case SensorGraphType.purple:
        graphColor = const Color(0xFF9569D4);
        break;
    }

    // --------------------------------------------------------------
    // GRAPH DATA
    // --------------------------------------------------------------

    final List<double> values = [
      0.55,
      0.40,
      0.50,
      0.38,
      0.47,
      0.43,
      0.52,
      0.46,
      0.58,
      0.51,
      0.63,
      0.48,
      0.55,
      0.46,
      0.60,
      0.42,
      0.50,
      0.36,
      0.44,
      0.35,
      0.45,
      0.38,
      0.48,
      0.31,
      0.40,
      0.30,
      0.45,
      0.34,
      0.42,
      0.30,
      0.39,
      0.27,
      0.36,
      0.25,
      0.40,
      0.32,
      0.45,
      0.34,
      0.42,
      0.30,
    ];

    final Path linePath = Path();
    final Path fillPath = Path();

    final double stepX = size.width / (values.length - 1);

    // --------------------------------------------------------------
    // CREATE GRAPH
    // --------------------------------------------------------------

    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;

      final double y = size.height * values[i];

      if (i == 0) {
        linePath.moveTo(x, y);

        fillPath.moveTo(x, size.height);

        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);

        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);

    fillPath.close();

    // --------------------------------------------------------------
    // GRAPH FILL
    // --------------------------------------------------------------

    final Paint fillPaint = Paint()
      ..color = graphColor.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // --------------------------------------------------------------
    // GRAPH LINE
    // --------------------------------------------------------------

    final Paint linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant SensorGraphPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
