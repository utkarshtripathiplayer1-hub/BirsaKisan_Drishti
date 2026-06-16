import 'package:crop_recommendation_system/CropRecommendation/crop_input_page.dart';
import 'package:flutter/material.dart';

class CropPage extends StatelessWidget {
  const CropPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget featureCard({
      required BuildContext context,
      required Widget page,
      required String imagePath,
      required String title,
      required String description,
      required Color colors,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(imagePath, width: 120, height: 120),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colors,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),

                    const SizedBox(height: 15),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7EF0B0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, size: 35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crop Recommendation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        backgroundColor: Colors.green.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),

              featureCard(
                context: context,
                page: CropInputPage(),
                imagePath: "assets/images/soil_sensor.png",
                title: "Live Soil Scan",
                description: "Get instant soil data from your soil sensor",
                colors: Color(0xFF067A34),
              ),

              SizedBox(height: 10),

              featureCard(
                context: context,
                page: CropInputPage(),
                imagePath: "assets/images/soil_data.png",
                title: "Enter Soil Data",
                description: "Enter your soil values manually",
                colors: Color(0xFF013465),
              ),

              SizedBox(height: 10),

              featureCard(
                context: context,
                page: CropInputPage(),
                imagePath: "assets/images/upload_data.png",
                title: "Upload Soil Report",
                description: "Upload your existing soil test report",
                colors: Color(0xFF013365),
              ),

              SizedBox(height: 10),

              featureCard(
                context: context,
                page: CropInputPage(),
                imagePath: "assets/images/collect_data.png",
                title: "Book Soil Collection",
                description: "Schedule a soil sample collection from farm",
                colors: Color(0xFF5C0844),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
