import 'package:flutter/material.dart';
import 'crop_recommend_controller.dart';
import 'crop_output_page.dart';

class CropInputPage extends StatefulWidget {
  const CropInputPage({super.key});

  @override
  State<CropInputPage> createState() => _CropInputPageState();
}

class _CropInputPageState extends State<CropInputPage> {
  final controller = CropRecommendController();

  final nController = TextEditingController();
  final pController = TextEditingController();
  final kController = TextEditingController();
  final phController = TextEditingController();

  final soilMoistureController = TextEditingController();

  final temperatureController = TextEditingController();

  final humidityController = TextEditingController();

  final rainfallController = TextEditingController();

  final soilTypeController = TextEditingController();

  bool isLoading = false;

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await controller.recommendCrop(
        n: double.parse(nController.text),
        p: double.parse(pController.text),
        k: double.parse(kController.text),
        ph: double.parse(phController.text),
        soilMoisture: double.parse(soilMoistureController.text),
        temperature: double.parse(temperatureController.text),
        humidity: double.parse(humidityController.text),
        rainfall: double.parse(rainfallController.text),
        soilType: soilTypeController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CropOutputPage(response: result)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Crop Recommendation",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 5, color: Color.fromARGB(255, 214, 214, 214)),

            /// TOP IMAGE
            SizedBox(
              height: height * 0.25,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),

                child: Image.asset(
                  "assets/images/crops.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -45),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 25, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: const Text(
                                "Soil Details",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Fetch Soil Details",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        buildCustomField(
                          controller: nController,
                          hint: "Enter Nitrogen Value",
                          iconText: "N",
                        ),

                        buildCustomField(
                          controller: pController,
                          hint: "Enter Phosphorous Value",
                          iconText: "P",
                        ),

                        buildCustomField(
                          controller: kController,
                          hint: "Enter Potassium Value",
                          iconText: "K",
                        ),

                        buildCustomField(
                          controller: phController,
                          hint: "Enter pH Value",
                          iconText: "pH",
                        ),

                        buildCustomField(
                          controller: temperatureController,
                          hint: "Enter Temperature",
                          iconText: "T",
                        ),

                        buildCustomField(
                          controller: humidityController,
                          hint: "Enter Humidity",
                          iconText: "H",
                        ),

                        buildCustomField(
                          controller: rainfallController,
                          hint: "Enter Rainfall",
                          iconText: "R",
                        ),

                        buildCustomField(
                          controller: soilMoistureController,
                          hint: "Enter Soil Moisture",
                          iconText: "SM",
                        ),

                        buildCustomField(
                          controller: soilTypeController,
                          hint: "Enter Soil Type",
                          iconText: "ST",
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: width * 0.8,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            onPressed: isLoading ? null : submit,

                            child: Text(
                              isLoading ? "Loading..." : "Get Recommendation",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomField({
    required TextEditingController controller,
    required String hint,
    required String iconText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1EFEF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,

            hintText: hint,

            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  iconText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }
}
