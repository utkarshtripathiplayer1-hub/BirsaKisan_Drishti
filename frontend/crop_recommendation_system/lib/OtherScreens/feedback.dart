import 'package:crop_recommendation_system/OtherScreens/dashboard.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text(
          AppLocalizations.of(context)!.feedback,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.feedbackDesc,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.05),
                ),
                SizedBox(height: 10,),
                Text(
                  AppLocalizations.of(context)!.feedbackDesc2,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: width * 0.04),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.eco, color: Colors.green, size: 30,),
                    SizedBox(width: 5),
                    Icon(Icons.eco, color: Colors.green, size: 30,),
                    SizedBox(width: 5),
                    Icon(Icons.eco, color: Colors.green, size: 30,),
                    SizedBox(width: 5),
                    Icon(Icons.eco, color: Colors.black, size: 30,),
                    SizedBox(width: 5),
                    Icon(Icons.eco, color: Colors.black, size: 30,),
                    SizedBox(width: 5),
                  ],
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
                    color: const Color.fromARGB(255, 208, 208, 208),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      // controller: FeedbackController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.review,
                        // contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
                      backgroundColor: Colors.green.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF067A34)),
                              SizedBox(width: 10),
                              Expanded(child: Text(AppLocalizations.of(context)!.feedbackSubmitted, style: TextStyle(fontSize: 20),)),
                            ],
                          ),
                          content: Text(AppLocalizations.of(context)!.feedbackSubmitDesc,),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade900,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.feedbackSubmission,
                      style: TextStyle(color: Colors.white),
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
