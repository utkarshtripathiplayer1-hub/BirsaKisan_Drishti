import 'package:beehive_monitoring_system/StaticPages/hive_graph_page3.dart';
import 'package:flutter/material.dart';

class HiveGraphPage2 extends StatelessWidget {
  const HiveGraphPage2({super.key});

  // ==============================================================
  // COLORS
  // ==============================================================

  static const Color backgroundColor = Color(0xFFFFFEEA);
  static const Color headerColor = Color(0xFFE4C274);
  static const Color darkBrown = Color(0xFF5C4724);

  static const Color borderColor = Color(0xFFD7A039);
  static const Color buttonColor = Color(0xFFEBD293);

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

          icon: const Icon(Icons.arrow_back, color: darkBrown, size: 24),
        ),

        titleSpacing: 0,

        title: const Text(
          'HIVE GRAPH',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),

        centerTitle: true,
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(13, 4, 13, 25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ==================================================
              // TIME FILTER
              // ==================================================

              _buildTimeFilter(),

              const SizedBox(height: 6),

              // ==================================================
              // DATE SELECTOR
              // ==================================================
              _buildDateSelector(),

              const SizedBox(height: 20),

              // ==================================================
              // FIRST GRAPH
              // ==================================================
              _buildGraphCard(imagePath: 'assets/images/brood_humidity.png'),

              const SizedBox(height: 10),

              // ==================================================
              // SECOND GRAPH
              // ==================================================
              _buildGraphCard(imagePath: 'assets/images/honey_graph.png'),

              const SizedBox(height: 18),

              // ==================================================
              // OTHER GRAPHS BUTTON
              // ==================================================
              _buildOtherGraphsButton(context),
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
      height: 28,

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1),

        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _timeOption('Hours'),
          _verticalDivider(),
          _timeOption('Days'),
          _verticalDivider(),
          _timeOption('Weeks'),
          _verticalDivider(),
          _timeOption('Months'),
        ],
      ),
    );
  }

  // ==============================================================
  // TIME OPTION
  // ==============================================================

  Widget _timeOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),

      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1, color: Colors.black),
      ),
    );
  }

  // ==============================================================
  // VERTICAL DIVIDER
  // ==============================================================

  Widget _verticalDivider() {
    return Container(width: 1, height: 27, color: Colors.black);
  }

  // ==============================================================
  // DATE SELECTOR
  // ==============================================================

  Widget _buildDateSelector() {
    return Container(
      width: 185,
      height: 27,

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1.5),

        borderRadius: BorderRadius.circular(15),

        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // CALENDAR ICON
          // ------------------------------------------------------

          const SizedBox(width: 10),

          const Icon(Icons.calendar_month, size: 15, color: Color(0xFFE0A500)),

          const SizedBox(width: 7),

          // ------------------------------------------------------
          // DATE
          // ------------------------------------------------------
          const Expanded(
            child: Text(
              'May 21, 2026',
              style: TextStyle(fontSize: 14, color: Color(0xFF5B554D)),
            ),
          ),

          // ------------------------------------------------------
          // DROPDOWN
          // ------------------------------------------------------
          const Icon(
            Icons.keyboard_arrow_down,
            size: 23,
            color: Color(0xFFA46B00),
          ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }

  // ==============================================================
  // GRAPH CARD
  // ==============================================================

  Widget _buildGraphCard({required String imagePath}) {
    return Container(
      width: double.infinity,

      height: 223,

      padding: const EdgeInsets.all(7),

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: borderColor, width: 1.2),

        borderRadius: BorderRadius.circular(19),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),

        child: Image.asset(
          imagePath,

          width: double.infinity,
          height: double.infinity,

          fit: BoxFit.contain,

          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Graph image not found',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==============================================================
  // OTHER GRAPHS BUTTON
  // ==============================================================

  Widget _buildOtherGraphsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // --------------------------------------------------------
        // REDIRECT TO OTHER GRAPHS PAGE
        // --------------------------------------------------------

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HiveGraphPage3()),
        );
      },

      child: Container(
        width: 168,
        height: 43,

        decoration: BoxDecoration(
          color: buttonColor,

          border: Border.all(color: const Color(0xFF8B6B32), width: 1),

          borderRadius: BorderRadius.circular(11),

          boxShadow: const [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              'Other Graphs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: darkBrown,
              ),
            ),

            const SizedBox(width: 12),

            const Icon(Icons.arrow_forward, size: 24, color: darkBrown),
          ],
        ),
      ),
    );
  }
}
