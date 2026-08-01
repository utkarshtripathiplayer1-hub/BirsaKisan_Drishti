import 'package:auto_size_text/auto_size_text.dart';
import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import 'profile_controller.dart';
import 'profile_model.dart';

class UpdateProfilePage extends StatefulWidget {
  final CropProfile profile;

  const UpdateProfilePage({super.key, required this.profile});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final CropProfileController controller = CropProfileController();

  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController roleController;
  late TextEditingController educationController;
  late TextEditingController phoneController;

  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController districtController;
  late TextEditingController villageController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  late TextEditingController farmNameController;
  late TextEditingController farmSizeController;
  late TextEditingController soilTypeController;
  late TextEditingController irrigationMethodController;

  final List<String> genders = ["Male", "Female", "Other"];
  final List<String> role = ["Farmer", "Researcher"];

  final List<String> educationLevels = [
    "Primary",
    "Secondary",
    "Higher Secondary",
    "Diploma",
    "Graduate",
    "Post Graduate",
    "No Formal Education",
  ];

  final List<String> irrigationMethods = [
    "Drip Irrigation",
    "Sprinkler Irrigation",
    "Surface Irrigation",
    "Flood Irrigation",
    "Manual Irrigation",
  ];

  final List<String> soilTypes = [
    "Acidic Loam",
    "Alluvial Soil",
    "Black Soil",
    "Clay Loam",
    "Clayey",
    "Lateritic Soil",
    "Loam",
    "Loamy",
    "Sandy",
    "Sandy Loam",
  ];

  @override
  void initState() {
    super.initState();

    ageController = TextEditingController(
      text: widget.profile.basicInfo.age.toString(),
    );

    genderController = TextEditingController(
      text: widget.profile.basicInfo.gender,
    );

    roleController = TextEditingController(text: widget.profile.basicInfo.role);

    educationController = TextEditingController(
      text: widget.profile.basicInfo.education,
    );

    phoneController = TextEditingController(
      text: widget.profile.basicInfo.phone,
    );

    countryController = TextEditingController(
      text: widget.profile.location.country,
    );

    stateController = TextEditingController(
      text: widget.profile.location.state,
    );

    districtController = TextEditingController(
      text: widget.profile.location.district,
    );

    villageController = TextEditingController(
      text: widget.profile.location.village,
    );

    latitudeController = TextEditingController(
      text: widget.profile.location.latitude.toString(),
    );

    longitudeController = TextEditingController(
      text: widget.profile.location.longitude.toString(),
    );

    farmNameController = TextEditingController(
      text: widget.profile.farmInfo.farmName,
    );

    farmSizeController = TextEditingController(
      text: widget.profile.farmInfo.farmSize.toString(),
    );

    soilTypeController = TextEditingController(
      text: widget.profile.farmInfo.soilType,
    );

    irrigationMethodController = TextEditingController(
      text: widget.profile.farmInfo.irrigationMethod,
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    genderController.dispose();
    roleController.dispose();
    educationController.dispose();
    phoneController.dispose();

    countryController.dispose();
    stateController.dispose();
    districtController.dispose();
    villageController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    farmNameController.dispose();
    farmSizeController.dispose();
    soilTypeController.dispose();
    irrigationMethodController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green.shade900,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          AutoSizeText(
            title,
            minFontSize: 12,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(icon, color: Colors.green.shade900),

      filled: true,

      fillColor: Theme.of(context).colorScheme.surface,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.green.shade900),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.green.shade900, width: 2),
      ),
    );
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
        centerTitle: true,
        title: AutoSizeText(
          minFontSize: 10,
          "Update Your Profile",
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.green.shade900,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionTitle("Update Your Basic Info", Icons.person),

            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.green.shade900,
              child: Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: fieldDecoration("Age", Icons.cake),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue: genders.contains(genderController.text)
                  ? genderController.text
                  : null,

              decoration: fieldDecoration("Gender", Icons.people),

              icon: const Icon(Icons.keyboard_arrow_down_rounded),

              borderRadius: BorderRadius.circular(18),

              menuMaxHeight: 250,

              items: genders.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  genderController.text = value!;
                });
              },
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue: role.contains(roleController.text)
                  ? roleController.text
                  : null,

              decoration: fieldDecoration("Role", Icons.verified_user),

              icon: const Icon(Icons.keyboard_arrow_down_rounded),

              borderRadius: BorderRadius.circular(18),

              menuMaxHeight: 250,

              items: role.map((roles) {
                return DropdownMenuItem(value: roles, child: Text(roles));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  roleController.text = value!;
                });
              },
            ),
            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue: educationLevels.contains(educationController.text)
                  ? educationController.text
                  : null,
              decoration: fieldDecoration("Education", Icons.school),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              borderRadius: BorderRadius.circular(18),
              items: educationLevels.map((education) {
                return DropdownMenuItem(
                  value: education,
                  child: Text(education),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  educationController.text = value ?? "";
                });
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: fieldDecoration("Phone Number", Icons.phone),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                sectionTitle("Update Your Location", Icons.location_on),
                IconButton(
                  icon: Icon(Icons.my_location, color: Colors.green.shade900,),
                  onPressed: () async {
                    try {
                      Position position = await WeatherApiController().getCurrentLocation();
                      latitudeController.text = position.latitude
                          .toStringAsFixed(6);
                      longitudeController.text = position.longitude
                          .toStringAsFixed(6);
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),

            TextField(
              controller: countryController,
              decoration: fieldDecoration("Country", Icons.public),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: stateController,
              decoration: fieldDecoration("State", Icons.map),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: districtController,
              decoration: fieldDecoration("District", Icons.location_city),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: villageController,
              decoration: fieldDecoration("Village", Icons.home),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: fieldDecoration("Latitude", Icons.place),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: fieldDecoration("Longitude", Icons.explore),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
            sectionTitle("Update Your Farm Info", Icons.agriculture),

            TextField(
              controller: farmNameController,
              decoration: fieldDecoration("Farm Name", Icons.agriculture),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: farmSizeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: fieldDecoration(
                "Farm Size (Acres)",
                Icons.square_foot,
              ),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue: irrigationMethods.contains(soilTypeController.text)
                  ? soilTypeController.text
                  : null,
              decoration: fieldDecoration("Soil Type", Icons.grass),
              borderRadius: BorderRadius.circular(18),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: soilTypes.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  soilTypeController.text = value ?? "";
                });
              },
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              initialValue:
                  irrigationMethods.contains(irrigationMethodController.text)
                  ? irrigationMethodController.text
                  : null,
              decoration: fieldDecoration(
                "Irrigation Method",
                Icons.water_drop,
              ),
              borderRadius: BorderRadius.circular(18),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: irrigationMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  irrigationMethodController.text = value ?? "";
                });
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                onPressed: () async {
                  final updatedProfile = CropProfile(
                    user: widget.profile.user,

                    basicInfo: BasicInfo(
                      role: widget.profile.basicInfo.role,
                      age: int.parse(ageController.text),
                      gender: genderController.text,
                      education: educationController.text,
                      phone: phoneController.text,
                    ),

                    location: LocationInfo(
                      country: countryController.text,
                      state: stateController.text,
                      district: districtController.text,
                      village: villageController.text,
                      latitude: double.parse(latitudeController.text),
                      longitude: double.parse(longitudeController.text),
                    ),

                    farmInfo: FarmInfo(
                      farmName: farmNameController.text,
                      farmSize: double.parse(farmSizeController.text),
                      soilType: soilTypeController.text,
                      irrigationMethod: irrigationMethodController.text,
                    ),
                  );

                  try {
                    await controller.updateProfile(updatedProfile);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully"),
                      ),
                    );

                    Navigator.pop(context, true);
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },

                child: const Text(
                  "Update Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
