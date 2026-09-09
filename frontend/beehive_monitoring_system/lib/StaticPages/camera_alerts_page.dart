import 'package:flutter/material.dart';

class CameraAlertsPage extends StatelessWidget {
  const CameraAlertsPage({super.key});

  // ==============================================================
  // COLORS
  // ==============================================================

  static const Color backgroundColor = Color(0xFFFFFEEA);
  static const Color headerColor = Color(0xFFE4C274);
  static const Color darkBrown = Color(0xFF5C4724);

  static const Color uploadColor = Color(0xFFF1DEA6);
  static const Color uploadBorderColor = Color(0xFFD8AA4F);

  static const Color alertRed = Color(0xFFFF2020);

  static const Color recentBorder = Color(0xFFD7A039);
  static const Color itemBorder = Color(0xFFE4C47A);

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
          'CAMERA & ALERTS',
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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // UPLOAD HIVE IMAGE
              // ==================================================

              _buildUploadHiveImage(),

              const SizedBox(height: 20),

              // ==================================================
              // ACTIVE ALERTS TITLE
              // ==================================================
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Active Alerts',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w500,
                    color: darkBrown,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // ACTIVE ALERT
              // ==================================================
              _buildActiveAlert(),

              const SizedBox(height: 20),

              // ==================================================
              // RECENT ALERTS HEADER
              // ==================================================
              _buildRecentAlertsHeader(),

              const SizedBox(height: 13),

              // ==================================================
              // RECENT ALERTS CONTAINER
              // ==================================================
              _buildRecentAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // UPLOAD HIVE IMAGE
  // ==============================================================

  Widget _buildUploadHiveImage() {
    return GestureDetector(
      onTap: () {
        // --------------------------------------------------------
        // Later you can open camera/gallery here.
        // --------------------------------------------------------
      },

      child: Container(
        width: double.infinity,
        height: 135,

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        decoration: BoxDecoration(
          color: uploadColor,

          border: Border.all(color: uploadBorderColor, width: 3),

          borderRadius: BorderRadius.circular(19),
        ),

        child: Row(
          children: [
            // ----------------------------------------------------
            // IMAGE / CAMERA ICON CIRCLE
            // ----------------------------------------------------

            Container(
              width: 100,
              height: 100,

              decoration: const BoxDecoration(
                color: Color(0xFFE0B65F),
                shape: BoxShape.circle,
              ),

              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.black,
                  size: 60,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ----------------------------------------------------
            // TEXT
            // ----------------------------------------------------
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Upload Hive Image',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: darkBrown,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Take a photo or upload from gallery',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: Color(0xFF5B554D)),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------
            // ARROW
            // ----------------------------------------------------
            const SizedBox(
              width: 30,
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  size: 43,
                  color: Color(0xFFA46B00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // ACTIVE ALERT
  // ==============================================================

  Widget _buildActiveAlert() {
    return Container(
      width: double.infinity,
      height: 120,

      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEACB),

        border: Border.all(color: alertRed, width: 1.8),

        borderRadius: BorderRadius.circular(27),

        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // ALERT ICON
          // ------------------------------------------------------

          SizedBox(
            width: 92,
            height: 92,

            child: Image.asset(
              'assets/images/temperature.png',
              fit: BoxFit.contain,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.thermostat,
                  size: 75,
                  color: Colors.red,
                );
              },
            ),
          ),

          const SizedBox(width: 15),

          // ------------------------------------------------------
          // ALERT INFORMATION
          // ------------------------------------------------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'High Hive Temperature',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: alertRed,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Hive 3',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),

                    const SizedBox(width: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // RECENT ALERTS HEADER
  // ==============================================================

  Widget _buildRecentAlertsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          Expanded(
            child: Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: darkBrown,
              ),
            ),
          ),

          Text(
            'View All',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // RECENT ALERTS CONTAINER
  // ==============================================================

  Widget _buildRecentAlerts() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(11, 24, 11, 28),

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: recentBorder, width: 1.8),

        borderRadius: BorderRadius.circular(38),
      ),

      child: Column(
        children: [
          // ======================================================
          // ALERT 1
          // ======================================================

          _recentAlertItem(
            title: 'High vibrations Detected',
            hive: 'Hive 2',
            time: '10:34 AM',
            iconPath: 'assets/images/fungal_risk.png',
          ),

          const SizedBox(height: 21),

          // ======================================================
          // ALERT 2
          // ======================================================
          _recentAlertItem(
            title: 'Varroa mite Detected',
            hive: 'Hive 5',
            time: '11:34 AM',
            iconPath: 'assets/images/disease_detected.png',
          ),

          const SizedBox(height: 21),

          // ======================================================
          // ALERT 3
          // ======================================================
          _recentAlertItem(
            title: 'High Temperature Detected',
            hive: 'Hive 8',
            time: '2 days ago',
            iconPath: 'assets/images/ventilation.png',
          ),

          const SizedBox(height: 21),

          // ======================================================
          // ALERT 4
          // ======================================================
          _recentAlertItem(
            title: 'High Temperature Detected',
            hive: 'Hive 5',
            time: '2 weeks ago',
            iconPath: 'assets/images/temperature.png',
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SINGLE RECENT ALERT
  // ==============================================================

  Widget _recentAlertItem({
    required String title,
    required String hive,
    required String time,
    required String iconPath,
  }) {
    return Container(
      width: double.infinity,
      height: 125,

      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),

      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),

        border: Border.all(color: itemBorder, width: 1.6),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // ICON
          // ------------------------------------------------------

          SizedBox(
            width: 70,
            height: 70,

            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.warning_amber_rounded, size: 50);
              },
            ),
          ),

          const SizedBox(width: 12),

          // ------------------------------------------------------
          // ALERT TEXT
          // ------------------------------------------------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // TITLE
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5),

                // HIVE + TIME
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hive,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF5B5B5B),
                      ),
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
