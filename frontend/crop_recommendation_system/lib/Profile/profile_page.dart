import 'package:crop_recommendation_system/Profile/profile_controller.dart';
import 'package:crop_recommendation_system/Profile/update_profile_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _CropProfilePageState();
}

class _CropProfilePageState extends State<ProfilePage> {
  final CropProfileController controller = CropProfileController();

  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = controller.fetchProfile();
  }

  Widget buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(icon, size: 34, color: Colors.green.shade900),

                const SizedBox(width: 12),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  value.isEmpty ? "-" : value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Divider(color: Color(0xFFE9ECEF), thickness: .9, height: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final profile = controller.profile!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            child: Column(
              children: [
                //======================
                // PROFILE HEADER
                //======================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffF4FBF5),
                            width: 4,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 62,
                              backgroundImage: NetworkImage(
                                profile.user.picture,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Text(
                        profile.user.name,
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.3,
                          color: Colors.green.shade900,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        profile.user.email,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 26),

                      SizedBox(
                        width: 230,
                        height: 56,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit_outlined, size: 22),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(230, 56),
                            foregroundColor: Colors.green.shade900,
                            side: BorderSide(
                              color: Colors.green.shade900,
                              width: 1.7,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateProfilePage(
                                  profile: controller.profile!,
                                ),
                              ),
                            );

                            if (updated == true) {
                              setState(() {
                                _profileFuture = controller.fetchProfile();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                //======================
                // BASIC INFO
                //======================
                buildSectionCard(
                  icon: Icons.person,
                  title: "Basic Information",
                  children: [
                    buildInfoRow("Phone Number", profile.basicInfo.phone),

                    buildDivider(),

                    buildInfoRow("Age", profile.basicInfo.age.toString()),

                    buildDivider(),

                    buildInfoRow("Gender", profile.basicInfo.gender),

                    buildDivider(),

                    buildInfoRow("Education", profile.basicInfo.education),
                  ],
                ),

                const SizedBox(height: 22),

                //======================
                // LOCATION
                //======================
                buildSectionCard(
                  icon: Icons.location_on,
                  title: "Location",
                  children: [
                    buildInfoRow("Country", profile.location.country),

                    buildDivider(),

                    buildInfoRow("State", profile.location.state),

                    buildDivider(),

                    buildInfoRow("District", profile.location.district),

                    buildDivider(),

                    buildInfoRow("Village", profile.location.village),
                  ],
                ),

                const SizedBox(height: 22),

                //======================
                // FARM
                //======================
                buildSectionCard(
                  icon: Icons.handyman_outlined,
                  title: "Farm Information",
                  children: [
                    buildInfoRow("Farm Name", profile.farmInfo.farmName),

                    buildDivider(),

                    buildInfoRow(
                      "Farm Size",
                      "${profile.farmInfo.farmSize} Acres",
                    ),

                    buildDivider(),

                    buildInfoRow("Soil Type", profile.farmInfo.soilType),

                    buildDivider(),

                    buildInfoRow(
                      "Irrigation Method",
                      profile.farmInfo.irrigationMethod,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
