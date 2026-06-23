import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Birsa Kisan Drishti'**
  String get appName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @getOTP.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOTP;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @alreadyUser.
  ///
  /// In en, this message translates to:
  /// **'Already have an account ?'**
  String get alreadyUser;

  /// No description provided for @remember.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get remember;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feelsLike;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @manageFarm.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Farm'**
  String get manageFarm;

  /// No description provided for @myFarm.
  ///
  /// In en, this message translates to:
  /// **'My Farm'**
  String get myFarm;

  /// No description provided for @cropRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Crop Recommendation'**
  String get cropRecommendation;

  /// No description provided for @diseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get diseaseDetection;

  /// No description provided for @myCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop Recommendation'**
  String get myCrop;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @chatBot.
  ///
  /// In en, this message translates to:
  /// **'Chat Bot'**
  String get chatBot;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Your Profile'**
  String get updateProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @askChatbot.
  ///
  /// In en, this message translates to:
  /// **'Ask to our AI chatbot'**
  String get askChatbot;

  /// No description provided for @goToFAQs.
  ///
  /// In en, this message translates to:
  /// **'BirsaKisanDrishti FAQs'**
  String get goToFAQs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @faqsHeading.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqsHeading;

  /// No description provided for @liveSoilScan.
  ///
  /// In en, this message translates to:
  /// **'Live Soil Scan'**
  String get liveSoilScan;

  /// No description provided for @liveSoilScanDesc.
  ///
  /// In en, this message translates to:
  /// **'Get instant soil data from your soil sensor'**
  String get liveSoilScanDesc;

  /// No description provided for @manualSoilData.
  ///
  /// In en, this message translates to:
  /// **'Enter Soil Data'**
  String get manualSoilData;

  /// No description provided for @manualSoilDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your soil values manually'**
  String get manualSoilDataDesc;

  /// No description provided for @uploadReport.
  ///
  /// In en, this message translates to:
  /// **'Upload Soil Report'**
  String get uploadReport;

  /// No description provided for @uploadReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload your existing soil test report'**
  String get uploadReportDesc;

  /// No description provided for @bookSoilCollection.
  ///
  /// In en, this message translates to:
  /// **'Book Soil Collection'**
  String get bookSoilCollection;

  /// No description provided for @bookSoilCollectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule a soil sample collection from farm'**
  String get bookSoilCollectionDesc;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image \n or \n click the live image'**
  String get uploadImage;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @chatWelcomeMsg.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your AI farming companion. Whether you need help with crop diseases, fertilizer recommendations, weather information, or best farming practices, I\'m here to help. Ask me anything! You can chat with me in your preferred language'**
  String get chatWelcomeMsg;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Input Your Query'**
  String get typeMessage;

  /// No description provided for @caption.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming Toolkit'**
  String get caption;

  /// No description provided for @caption2.
  ///
  /// In en, this message translates to:
  /// **'AI powered assistant to improve your crop yield.'**
  String get caption2;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming Features'**
  String get features;

  /// No description provided for @cropDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-based crop suggestion using N, P, K, pH and weather.'**
  String get cropDesc;

  /// No description provided for @diseaseDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan plant leaves for real-time disease diagnosis.'**
  String get diseaseDetectionDesc;

  /// No description provided for @waterReq.
  ///
  /// In en, this message translates to:
  /// **'Water Requirement'**
  String get waterReq;

  /// No description provided for @waterReqDesc.
  ///
  /// In en, this message translates to:
  /// **'Shows irrigation requirement for selected crops.'**
  String get waterReqDesc;

  /// No description provided for @weatherForecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// No description provided for @weatherForecastDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart weather insights for better planning.'**
  String get weatherForecastDesc;

  /// No description provided for @marketPriceFeature.
  ///
  /// In en, this message translates to:
  /// **'Market Price Insight'**
  String get marketPriceFeature;

  /// No description provided for @marketPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Real-time mandi prices with market trends.'**
  String get marketPriceDesc;

  /// No description provided for @govtSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get govtSchemes;

  /// No description provided for @govtSchemesDesc.
  ///
  /// In en, this message translates to:
  /// **'Eligibility details and application guidance.'**
  String get govtSchemesDesc;

  /// No description provided for @cropCalendar.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Crop Calendar'**
  String get cropCalendar;

  /// No description provided for @cropCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Month-wise sowing and harvesting schedule.'**
  String get cropCalendarDesc;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Farming Task Reminder'**
  String get reminder;

  /// No description provided for @reminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for irrigation, sowing and harvesting.'**
  String get reminderDesc;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'How does disease detection work?'**
  String get question1;

  /// No description provided for @answer1.
  ///
  /// In en, this message translates to:
  /// **'Using AI image recognition, you just need to take a clear photo of the affected leaf with your phone camera, and the app compares it with thousands of known disease images to detect the problem. After detection, it shows likely causes, suggested treatments, and basic prevention tips in simple language.'**
  String get answer1;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'How is water requirement calculated?'**
  String get question2;

  /// No description provided for @answer2.
  ///
  /// In en, this message translates to:
  /// **'The app estimates water requirement by combining crop type, soil moisture, local temperature, humidity, and recent rainfall data. Using standard irrigation formulas, it converts this into an easy schedule like \'water every 3 days\' so farmers can plan irrigation without doing any calculations.'**
  String get answer2;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'Are market prices updated daily?'**
  String get question3;

  /// No description provided for @answer3.
  ///
  /// In en, this message translates to:
  /// **'Mandi prices in the app are refreshed several times a day using government and trusted market data sources to keep rates current. During busy trading hours, prices may update as frequently as every few minutes so farmers can decide the best time and place to sell.'**
  String get answer3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'Does the app work offline?'**
  String get question4;

  /// No description provided for @answer4.
  ///
  /// In en, this message translates to:
  /// **'Key information already loaded on the device, like saved recommendations and last-viewed tips, can be accessed even without internet. Features that need live data, such as new weather forecasts or fresh mandi prices, will update automatically the next time the phone is online.'**
  String get answer4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'Can farmers check government schemes?'**
  String get question5;

  /// No description provided for @answer5.
  ///
  /// In en, this message translates to:
  /// **'The app shows recent agriculture schemes and subsidies from official portals, focusing on those useful for small and marginal farmers. For each scheme, farmers can quickly see who is eligible, important benefits, and basic steps to apply.'**
  String get answer5;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'Is my data safe?'**
  String get question6;

  /// No description provided for @answer6.
  ///
  /// In en, this message translates to:
  /// **'Only the minimum information needed to run the service is collected, and it is stored using standard security practices similar to other modern apps. Personal data is never sold, and any sharing (for example with government platforms or partners) happens only to provide core services and in line with data protection rules.'**
  String get answer6;

  /// No description provided for @question7.
  ///
  /// In en, this message translates to:
  /// **'How can I use AI to predict crop yield?'**
  String get question7;

  /// No description provided for @answer7.
  ///
  /// In en, this message translates to:
  /// **'Using AI models, historical yield data, and local weather patterns, the app gives an estimated yield range for the recommended crop. This estimate is meant as guidance to help with planning and is not a guarantee, since actual yield also depends on field practices and unexpected weather.'**
  String get answer7;

  /// No description provided for @question8.
  ///
  /// In en, this message translates to:
  /// **'Does the app support regional languages?'**
  String get question8;

  /// No description provided for @answer8.
  ///
  /// In en, this message translates to:
  /// **'The app supports multiple Indian languages commonly spoken by farmers so they can read information in a familiar script. Farmers can change language anytime from settings, and important labels and buttons are translated for easier use.'**
  String get answer8;

  /// No description provided for @aboutusDesc1.
  ///
  /// In en, this message translates to:
  /// **'-Your Smart Farming Companion'**
  String get aboutusDesc1;

  /// No description provided for @aboutusDesc2.
  ///
  /// In en, this message translates to:
  /// **'BirsaKisanDrishti is an innovative Al-powered farming assistant built to help farmers make smarter decisions. Our mission is to boost crop yield, maximize profit, and simplify farming through technology.'**
  String get aboutusDesc2;

  /// No description provided for @provided.
  ///
  /// In en, this message translates to:
  /// **'What We Provide'**
  String get provided;

  /// No description provided for @smartCrop.
  ///
  /// In en, this message translates to:
  /// **'Smart Crop\nRecommendation'**
  String get smartCrop;

  /// No description provided for @soilInsight.
  ///
  /// In en, this message translates to:
  /// **'Satellite\nBased Soil\nInsights'**
  String get soilInsight;

  /// No description provided for @soilParameters.
  ///
  /// In en, this message translates to:
  /// **'Uses soil parameters (N,P,K,pH)'**
  String get soilParameters;

  /// No description provided for @aiFarming.
  ///
  /// In en, this message translates to:
  /// **'AI Farming\nAssistance'**
  String get aiFarming;

  /// No description provided for @fertilizerRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer\nRecommendation'**
  String get fertilizerRecommendation;

  /// No description provided for @waterRequired.
  ///
  /// In en, this message translates to:
  /// **'Water\nRequirement\nGuide'**
  String get waterRequired;

  /// No description provided for @weatherPrediction.
  ///
  /// In en, this message translates to:
  /// **'Weather\nBased Soil\nInsights'**
  String get weatherPrediction;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get mission;

  /// No description provided for @missionDesc.
  ///
  /// In en, this message translates to:
  /// **'Empowering every farmer with AI-driven knowledge to increase productivity and sustainability'**
  String get missionDesc;

  /// No description provided for @feedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'We would love to hear your feedback'**
  String get feedbackDesc;

  /// No description provided for @feedbackDesc2.
  ///
  /// In en, this message translates to:
  /// **'How Would You Rate Us?'**
  String get feedbackDesc2;

  /// No description provided for @shareThoughts.
  ///
  /// In en, this message translates to:
  /// **'Share Your Thoughts'**
  String get shareThoughts;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Write your review here'**
  String get review;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback Submitted'**
  String get feedbackSubmitted;

  /// No description provided for @feedbackSubmitDesc.
  ///
  /// In en, this message translates to:
  /// **'Your feedback is successfully submitted. we respect and care your feedback. Our team will look into it.'**
  String get feedbackSubmitDesc;

  /// No description provided for @feedbackSubmission.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmission;

  /// No description provided for @soilDetails.
  ///
  /// In en, this message translates to:
  /// **'Soil Details'**
  String get soilDetails;

  /// No description provided for @fetchDetails.
  ///
  /// In en, this message translates to:
  /// **'Fetch Soil Details'**
  String get fetchDetails;

  /// No description provided for @enterN.
  ///
  /// In en, this message translates to:
  /// **'Enter Nitrogen Value'**
  String get enterN;

  /// No description provided for @enterP.
  ///
  /// In en, this message translates to:
  /// **'Enter Phosphorous Value'**
  String get enterP;

  /// No description provided for @enterK.
  ///
  /// In en, this message translates to:
  /// **'Enter Potassium Value'**
  String get enterK;

  /// No description provided for @enterPh.
  ///
  /// In en, this message translates to:
  /// **'Enter pH Value'**
  String get enterPh;

  /// No description provided for @enterTemp.
  ///
  /// In en, this message translates to:
  /// **'Enter Temperature'**
  String get enterTemp;

  /// No description provided for @enterHumidity.
  ///
  /// In en, this message translates to:
  /// **'Enter Humidity'**
  String get enterHumidity;

  /// No description provided for @enterRainfall.
  ///
  /// In en, this message translates to:
  /// **'Enter Rainfall'**
  String get enterRainfall;

  /// No description provided for @enterMoisture.
  ///
  /// In en, this message translates to:
  /// **'Enter Soil Moisture'**
  String get enterMoisture;

  /// No description provided for @enterSoilType.
  ///
  /// In en, this message translates to:
  /// **'Enter Soil Type'**
  String get enterSoilType;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Birsa Kisan Drishti'**
  String get welcomeMessage;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @chatBotMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your AI farming companion. Whether you need help with crop diseases, fertilizer recommendations, weather information, or best farming practices, I\'m here to help. Ask me anything! You can chat with me in your preferred language'**
  String get chatBotMessage;

  /// No description provided for @unknownDisease.
  ///
  /// In en, this message translates to:
  /// **'Unknown Disease'**
  String get unknownDisease;

  /// No description provided for @mortalityRate.
  ///
  /// In en, this message translates to:
  /// **'Mortality Rate'**
  String get mortalityRate;

  /// No description provided for @cropType.
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get cropType;

  /// No description provided for @diseaseStage.
  ///
  /// In en, this message translates to:
  /// **'Disease Stage'**
  String get diseaseStage;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @weatherCondition.
  ///
  /// In en, this message translates to:
  /// **'Weather Conditions'**
  String get weatherCondition;

  /// No description provided for @precaution.
  ///
  /// In en, this message translates to:
  /// **'Precautions'**
  String get precaution;

  /// No description provided for @organicCure.
  ///
  /// In en, this message translates to:
  /// **'Cure: Organic'**
  String get organicCure;

  /// No description provided for @inOrganicCure.
  ///
  /// In en, this message translates to:
  /// **'Cure: InOrganic'**
  String get inOrganicCure;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location service disabled'**
  String get locationDisabled;

  /// No description provided for @tryAgainLocation.
  ///
  /// In en, this message translates to:
  /// **'Try again after enabling location service'**
  String get tryAgainLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied'**
  String get locationPermissionDenied;

  /// No description provided for @renameChat.
  ///
  /// In en, this message translates to:
  /// **'Rename Chat'**
  String get renameChat;

  /// No description provided for @deleteConvo.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get deleteConvo;

  /// No description provided for @deleteConvoDesc.
  ///
  /// In en, this message translates to:
  /// **'This chat will not be available after deletion.'**
  String get deleteConvoDesc;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failDeleteConvo.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete conversation'**
  String get failDeleteConvo;

  /// No description provided for @failLoadConvo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversation'**
  String get failLoadConvo;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask Anything'**
  String get askAnything;

  /// No description provided for @getRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendation'**
  String get getRecommendation;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @yeildProduction.
  ///
  /// In en, this message translates to:
  /// **'Yeild Production'**
  String get yeildProduction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'as',
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'or',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
