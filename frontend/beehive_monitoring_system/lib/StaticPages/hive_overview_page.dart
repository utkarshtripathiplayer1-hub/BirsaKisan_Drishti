import 'package:flutter/material.dart';

class HiveOverviewPage extends StatelessWidget {
  const HiveOverviewPage({super.key});

  static const Color bgColor = Color(0xFFFFFEEA);
  static const Color headerColor = Color(0xFFE4C274);
  static const Color darkBrown = Color(0xFF5C4724);
  static const Color borderColor = Color(0xFF6A5128);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,

        automaticallyImplyLeading: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
        ),

        centerTitle: true,

        title: const Text(
          'HIVE OVERVIEW',
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
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // APIARY CARD
              // ==================================================

              _buildApiaryCard(),

              const SizedBox(height: 25),

              // ==================================================
              // SECTION TITLE
              // ==================================================
              const Text(
                'Hive Health At A Glance',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // HEALTH CARDS
              // ==================================================
              GridView.count(
                crossAxisCount: 2,

                crossAxisSpacing: 36,
                mainAxisSpacing: 30,

                childAspectRatio: 1.48,

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  _healthCard(
                    title: 'BROOD HEALTH',
                    value: 'Good',
                    iconPath: 'assets/images/brood_health.png',
                    graphType: GraphType.green,
                  ),

                  _healthCard(
                    title: 'VENTILATION',
                    value: 'Low',
                    iconPath: 'assets/images/ventilation.png',
                    graphType: GraphType.blue,
                  ),

                  _healthCard(
                    title: 'COLONY STRESS',
                    value: 'Healthy',
                    iconPath: 'assets/images/colony_stress.png',
                    graphType: GraphType.orange,
                  ),

                  _healthCard(
                    title: 'HONEY PRODUCTION',
                    value: 'Moderate',
                    iconPath: 'assets/images/honey_production.png',
                    graphType: GraphType.purple,
                  ),

                  _healthCard(
                    title: 'FUNGAL RISK',
                    value: 'Low',
                    iconPath: 'assets/images/fungal_risk.png',
                    graphType: GraphType.orange,
                  ),

                  _healthCard(
                    title: 'QUEEN STATUS',
                    value: 'Good',
                    iconPath: 'assets/images/queen_status.png',
                    graphType: GraphType.green,
                  ),

                  _healthCard(
                    title: 'DISEASE DETECTED',
                    value: 'No Risk',
                    iconPath: 'assets/images/disease_detected.png',
                    graphType: GraphType.purple,
                  ),

                  _temperatureCard(),
                ],
              ),

              const SizedBox(height: 30),

              // ==================================================
              // OVERALL HEALTH
              // ==================================================
              _buildOverallHealth(),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // APIARY CARD
  // ==============================================================

  Widget _buildApiaryCard() {
    return Container(
      width: double.infinity,
      height: 150,

      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C9),

        border: Border.all(color: const Color(0xFFDCAF58), width: 3),

        borderRadius: BorderRadius.circular(18),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),

        child: Row(
          children: [
            // ----------------------------------------------------
            // IMAGE
            // ----------------------------------------------------

            SizedBox(
              width: 155,
              height: double.infinity,

              child: Image.asset(
                'assets/images/hive.png',
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Text('Hive', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),

            // ----------------------------------------------------
            // DETAILS
            // ----------------------------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // NAME + STATUS

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'My Apiary 1',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 11,
                        //     vertical: 2,
                        //   ),

                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFB6F3B2),

                        //     border: Border.all(
                        //       color: const Color(0xFF19C65B),
                        //       width: 1.5,
                        //     ),

                        //     borderRadius: BorderRadius.circular(20),
                        //   ),

                        //   child: const Text(
                        //     'Active',
                        //     style: TextStyle(
                        //       fontSize: 17,
                        //       color: Color(0xFF07994B),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // LOCATION
                    const Text(
                      'Location: DGI, Gautam Buddha Nagar',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(fontSize: 12, color: Color(0xFF5B5B5B)),
                    ),

                    const SizedBox(height: 6),

                    // UPDATED
                    const Text(
                      'Last Updated: 10:20 AM, May 21',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5B5B5B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // HEALTH CARD
  // ==============================================================

  Widget _healthCard({
    required String title,
    required String value,
    required String iconPath,
    required GraphType graphType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1.8),

        borderRadius: BorderRadius.circular(17),
      ),

      padding: const EdgeInsets.fromLTRB(10, 10, 8, 5),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // TOP PART
          // ======================================================

          Expanded(
            flex: 7,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ICON

                SizedBox(
                  width: 42,
                  height: 42,

                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),

                const SizedBox(width: 6),

                // TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF5B5B5B),
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
              painter: HealthGraphPainter(type: graphType),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // TEMPERATURE CARD
  // ==============================================================

  Widget _temperatureCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1.8),

        borderRadius: BorderRadius.circular(17),
      ),

      padding: const EdgeInsets.fromLTRB(10, 10, 8, 5),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(
                  width: 42,
                  height: 42,

                  child: Image.asset(
                    'assets/images/ventilation.png',
                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'TEMPERATURE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 2),

                      const Text(
                        'Inside   35',
                        style: TextStyle(
                          fontSize: 7.5,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),

                      const Text(
                        'Outside  45',
                        style: TextStyle(
                          fontSize: 7.5,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,

            child: CustomPaint(
              painter: HealthGraphPainter(type: GraphType.blue),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // OVERALL HEALTH
  // ==============================================================

  Widget _buildOverallHealth() {
    return Container(
      width: double.infinity,
      height: 105,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1.8),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // SHIELD
          // ------------------------------------------------------

          SizedBox(
            width: 55,
            height: 65,

            child: Image.asset(
              'assets/images/health_shield.png',
              fit: BoxFit.contain,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.verified_user,
                  size: 50,
                  color: Color(0xFF0A5138),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          // ------------------------------------------------------
          // TEXT
          // ------------------------------------------------------
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Overall Hive Health',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: darkBrown,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Your hive is healthy and performing well.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(fontSize: 13.5, color: Color(0xFF555555)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ------------------------------------------------------
          // SCORE
          // ------------------------------------------------------
          SizedBox(
            width: 62,
            height: 62,

            child: Stack(
              alignment: Alignment.center,

              children: [
                CustomPaint(
                  size: const Size(62, 62),
                  painter: HealthScorePainter(),
                ),

                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      '87',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '/100',
                      style: TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// GRAPH TYPE
// ==================================================================

enum GraphType { green, blue, orange, purple }

// ==================================================================
// GRAPH PAINTER
// ==================================================================

class HealthGraphPainter extends CustomPainter {
  final GraphType type;

  HealthGraphPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    Color graphColor;

    switch (type) {
      case GraphType.green:
        graphColor = const Color(0xFF52B788);
        break;

      case GraphType.blue:
        graphColor = const Color(0xFF4C9BE8);
        break;

      case GraphType.orange:
        graphColor = const Color(0xFFF2A65A);
        break;

      case GraphType.purple:
        graphColor = const Color(0xFF9569D4);
        break;
    }

    final values = [
      0.55,
      0.45,
      0.51,
      0.42,
      0.48,
      0.35,
      0.40,
      0.32,
      0.44,
      0.39,
      0.48,
      0.36,
      0.29,
      0.37,
      0.28,
      0.34,
      0.25,
      0.39,
      0.31,
      0.42,
      0.29,
      0.35,
      0.25,
      0.40,
      0.33,
      0.46,
      0.37,
      0.42,
      0.34,
      0.43,
    ];

    final linePath = Path();
    final fillPath = Path();

    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height * values[i];

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

    final fillPaint = Paint()
      ..color = graphColor.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // --------------------------------------------------------------
    // GRAPH LINE
    // --------------------------------------------------------------

    final linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant HealthGraphPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}

// ==================================================================
// SCORE CIRCLE
// ==================================================================

class HealthScorePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 4;

    // BACKGROUND

    final backgroundPaint = Paint()
      ..color = const Color(0xFFE1E7E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius, backgroundPaint);

    // SCORE

    final scorePaint = Paint()
      ..color = const Color(0xFF63B76B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    const score = 0.87;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28318 * score,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant HealthScorePainter oldDelegate) {
    return false;
  }
}
