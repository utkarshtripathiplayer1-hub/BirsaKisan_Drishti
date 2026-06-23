import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FAQS extends StatelessWidget {
  const FAQS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFEAEAEA),

      appBar: AppBar(
        title: AutoSizeText(
          AppLocalizations.of(context)!.faqsHeading,
          minFontSize: 15,
          maxLines: 1,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
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
            FAQCard(
              question: AppLocalizations.of(context)!.question1,
              answer: AppLocalizations.of(context)!.answer1,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question2,
              answer: AppLocalizations.of(context)!.answer2,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question3,
              answer: AppLocalizations.of(context)!.answer3,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question4,
              answer: AppLocalizations.of(context)!.answer4,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question5,
              answer: AppLocalizations.of(context)!.answer5,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question6,
              answer:AppLocalizations.of(context)!.answer6,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question7,
              answer: AppLocalizations.of(context)!.answer7,
            ),

            const SizedBox(height: 20),

            FAQCard(
              question: AppLocalizations.of(context)!.question8,
              answer: AppLocalizations.of(context)!.answer8,
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
