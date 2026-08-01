import 'package:beehive_monitoring_system/OtherScreens/dashboard.dart';
import 'package:beehive_monitoring_system/feedBack/feedback_service.dart';
import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  double ratedValue = 3;
  final TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCB73).withValues(alpha: 0.59),
        title: Text(
          AppLocalizations.of(context)!.feedback,
          style: TextStyle(
            color: Color(0xFF574422),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF574422),
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.feedbackDesc,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.05,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.feedbackDesc2,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  maxRating: 5,
                  glowColor: Color(0xFF574422),
                  glow: true,
                  glowRadius: 2,
                  itemCount: 5,
                  updateOnDrag: false,
                  direction: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      const Icon(Icons.local_florist, color: Color(0xFF574422), size: 34),
                  onRatingUpdate: (double value) {
                    ratedValue = value;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.shareThoughts,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 233, 210),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF574422), // Border color
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      controller: commentController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.review,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  width: width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFFFCB73,
                      ).withValues(alpha: 0.59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF574422),
                        width: 1.5,
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (commentController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your feedback."),
                                ),
                              );
                              return;
                            }

                            try {
                              setState(() {
                                isLoading = true;
                              });

                              await FeedbackService.submitFeedback(
                                rating: ratedValue.toInt(),
                                comment: commentController.text.trim(),
                              );

                              if (!context.mounted) return;

                              setState(() {
                                isLoading = false;
                              });

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF574422),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.feedbackSubmitted,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.feedbackSubmitDesc,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFFCB73,
                                        ).withValues(alpha: 0.59),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Color(0xFF574422),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.feedbackSubmission,
                            style: const TextStyle(color: Color(0xFF574422), fontSize: 20),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
