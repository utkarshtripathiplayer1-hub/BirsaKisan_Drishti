import 'package:flutter/material.dart';

class FAQS extends StatelessWidget {
  const FAQS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),

      appBar: AppBar(
        title: const Text(
          "FAQs",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF049B3A),
        iconTheme: const IconThemeData(color: Colors.white, size: 30, weight: 40.0),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: Column(
          children: [
            const FAQCard(
              question: "How does disease detection work?",
              answer:
                  "Using AI image recognition, you just need to take a clear photo of the affected leaf with your phone camera, and the app compares it with thousands of known disease images to detect the problem. After detection, it shows likely causes, suggested treatments, and basic prevention tips in simple language.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "How is water requirement calculated?",
              answer:
                  "The app estimates water requirement by combining crop type, soil moisture, local temperature, humidity, and recent rainfall data. Using standard irrigation formulas, it converts this into an easy schedule like 'water every 3 days' so farmers can plan irrigation without doing any calculations.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "Are market prices updated daily?",
              answer:
                  "Mandi prices in the app are refreshed several times a day using government and trusted market data sources to keep rates current. During busy trading hours, prices may update as frequently as every few minutes so farmers can decide the best time and place to sell.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "Does the app work offline?",
              answer:
                  "Key information already loaded on the device, like saved recommendations and last-viewed tips, can be accessed even without internet. Features that need live data, such as new weather forecasts or fresh mandi prices, will update automatically the next time the phone is online.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "Can farmers check government schemes?",
              answer:
                  "The app shows recent agriculture schemes and subsidies from official portals, focusing on those useful for small and marginal farmers. For each scheme, farmers can quickly see who is eligible, important benefits, and basic steps to apply.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "Is my data safe?",
              answer:
                  "Only the minimum information needed to run the service is collected, and it is stored using standard security practices similar to other modern apps. Personal data is never sold, and any sharing (for example with government platforms or partners) happens only to provide core services and in line with data protection rules.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "How can I use AI to predict crop yield?",
              answer:
                  "Using AI models, historical yield data, and local weather patterns, the app gives an estimated yield range for the recommended crop. This estimate is meant as guidance to help with planning and is not a guarantee, since actual yield also depends on field practices and unexpected weather.",
            ),

            const SizedBox(height: 20),

            const FAQCard(
              question: "Does the app support regional languages?",
              answer:
                  "The app supports multiple Indian languages commonly spoken by farmers so they can read information in a familiar script. Farmers can change language anytime from settings, and important labels and buttons are translated for easier use.",
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  const FAQCard({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            answer,
            style: const TextStyle(
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
