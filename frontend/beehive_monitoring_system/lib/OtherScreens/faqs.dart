import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FAQS extends StatelessWidget {
  const FAQS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF574422),
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
        title: AutoSizeText(
          minFontSize: 15,
          AppLocalizations.of(context)!.faqsHeading,
          style: TextStyle(
            color: Color(0xFF574422),
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        backgroundColor: const Color(0xFFC98D26).withValues(alpha: 0.59),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              answer: AppLocalizations.of(context)!.answer6,
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

  const FAQCard({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Color(0xFFC98D26), // Sets the border color
          width: 2.0, // Sets the border thickness
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(answer, style: const TextStyle(fontSize: 15, height: 1.35)),
        ],
      ),
    );
  }
}
