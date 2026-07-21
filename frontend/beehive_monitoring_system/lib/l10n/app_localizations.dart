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

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @chatBot.
  ///
  /// In en, this message translates to:
  /// **'Chat Bot'**
  String get chatBot;

  /// No description provided for @chatBotMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your AI farming companion. Whether you need help with crop diseases, fertilizer recommendations, weather information, or best farming practices, I\'m here to help. Ask me anything! You can chat with me in your preferred language'**
  String get chatBotMessage;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @hiveOverview.
  ///
  /// In en, this message translates to:
  /// **'Hive Overview'**
  String get hiveOverview;

  /// No description provided for @sensorReading.
  ///
  /// In en, this message translates to:
  /// **'Sensor Reading'**
  String get sensorReading;

  /// No description provided for @hiveGraph.
  ///
  /// In en, this message translates to:
  /// **'Hive Graph'**
  String get hiveGraph;

  /// No description provided for @cameraAlerts.
  ///
  /// In en, this message translates to:
  /// **'Camera Alerts'**
  String get cameraAlerts;

  /// No description provided for @aboutusDesc1.
  ///
  /// In en, this message translates to:
  /// **'-Your Smart Farming Companion'**
  String get aboutusDesc1;

  /// No description provided for @aboutusDesc2.
  ///
  /// In en, this message translates to:
  /// **'AI-powered beekeeping platform enabling real time hive monitoring, early disease detection, and smarter honey production decisions.'**
  String get aboutusDesc2;

  /// No description provided for @provided.
  ///
  /// In en, this message translates to:
  /// **'What We Provide'**
  String get provided;

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

  /// No description provided for @liveMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live Monitoring'**
  String get liveMonitoring;

  /// No description provided for @hiveHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Hive Health Score'**
  String get hiveHealthScore;

  /// No description provided for @imageAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Image Analysis'**
  String get imageAnalysis;

  /// No description provided for @smartAlerts.
  ///
  /// In en, this message translates to:
  /// **'Smart Alerts'**
  String get smartAlerts;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @provideReport.
  ///
  /// In en, this message translates to:
  /// **'Provides Report'**
  String get provideReport;

  /// No description provided for @qrManagement.
  ///
  /// In en, this message translates to:
  /// **'QR based hive'**
  String get qrManagement;

  /// No description provided for @mitesdetection.
  ///
  /// In en, this message translates to:
  /// **'Mites Detection'**
  String get mitesdetection;

  /// No description provided for @deviceManagement.
  ///
  /// In en, this message translates to:
  /// **'Device Management'**
  String get deviceManagement;

  /// No description provided for @guideAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Guide & Support'**
  String get guideAndSupport;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Smart BeeKeeping Features'**
  String get features;

  /// No description provided for @keyFeaturedesc1.
  ///
  /// In en, this message translates to:
  /// **'Track real-time data from all sensors'**
  String get keyFeaturedesc1;

  /// No description provided for @keyFeaturedesc2.
  ///
  /// In en, this message translates to:
  /// **'AI-powered health score to evaluate condition'**
  String get keyFeaturedesc2;

  /// No description provided for @keyFeaturedesc3.
  ///
  /// In en, this message translates to:
  /// **'Get instant alerts for abnormal conditions'**
  String get keyFeaturedesc3;

  /// No description provided for @keyFeaturedesc4.
  ///
  /// In en, this message translates to:
  /// **'Watch live hive activity and record important events'**
  String get keyFeaturedesc4;

  /// No description provided for @keyFeaturedesc5.
  ///
  /// In en, this message translates to:
  /// **'Generate detailed reports and gain insights'**
  String get keyFeaturedesc5;

  /// No description provided for @keyFeaturedesc6.
  ///
  /// In en, this message translates to:
  /// **'Manage your sensors , devices and connectivity in one place'**
  String get keyFeaturedesc6;

  /// No description provided for @keyFeaturedesc7.
  ///
  /// In en, this message translates to:
  /// **'Visualize temperature, humidity,gas level and more'**
  String get keyFeaturedesc7;

  /// No description provided for @keyFeaturedesc8.
  ///
  /// In en, this message translates to:
  /// **'Access helpful resources and get expert support'**
  String get keyFeaturedesc8;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'How do I set up a new apiary in the app?'**
  String get question1;

  /// No description provided for @answer1.
  ///
  /// In en, this message translates to:
  /// **'Setting up a new apiary is simple and only takes a few minutes. Navigate to Settings → Apiary Management → Add New Apiary and complete the guided setup process. Enter your apiary\'s basic information, verify the location, and specify the number of hives. Once the setup is complete, the application automatically creates a unique QR code for each hive. These QR codes help you quickly access individual hive information, monitor sensor data, and manage multiple hives efficiently.'**
  String get answer1;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'Why do I need to provide my apiary location?'**
  String get question2;

  /// No description provided for @answer2.
  ///
  /// In en, this message translates to:
  /// **'The location of your apiary enables the application to deliver   more accurate monitoring and recommendations. By using your geographic location, the app can fetch local weather conditions, estimate environmental risks, provide location-specific alerts, and improve AI-based predictions for hive health. You can either allow automatic GPS detection or manually enter your location details during the setup process.'**
  String get answer2;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'What is the purpose of the QR code generated for each hive?'**
  String get question3;

  /// No description provided for @answer3.
  ///
  /// In en, this message translates to:
  /// **'Every hive is assigned a unique QR code during the setup process. Scanning this QR code instantly opens the complete profile of that hive, including live sensor readings, health score, historical graphs, inspection records, AI analysis, and recent alerts. This eliminates the need to search manually and makes managing multiple hives faster and more organized.'**
  String get answer3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'What can I see in the Sensor Reading section?'**
  String get question4;

  /// No description provided for @answer4.
  ///
  /// In en, this message translates to:
  /// **'The Sensor Reading section displays real-time data collected from the IoT sensors installed inside the hive. You can monitor brood temperature, overall temperature, humidity, hive weight, vibration levels, carbon dioxide concentration, VOC gases, and hazard detection. Each parameter also includes historical graphs that allow you to compare changes over different time periods such as Live, 1 Hour, 6 Hours, 7 Days, and 1 Month.'**
  String get answer4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'Why are some sensor values highlighted in different colors?'**
  String get question5;

  /// No description provided for @answer5.
  ///
  /// In en, this message translates to:
  /// **'The application uses a color-based status system to help users quickly identify hive conditions.Green indicates that the sensor reading is within the optimal range.Yellow suggests that the value is approaching a critical threshold and should be monitored.Red indicates that immediate attention may be required because the reading has exceeded the safe operating range.'**
  String get answer5;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'Why am I receiving alerts from the application?'**
  String get question6;

  /// No description provided for @answer6.
  ///
  /// In en, this message translates to:
  /// **'The application continuously monitors all connected sensors in real time. If any parameter exceeds its safe operating range, an alert is generated automatically. Examples include unusually high temperatures, abnormal vibration patterns, poor ventilation, increased CO₂ levels, or possible disease detection. Each alert includes a description of the issue and AI-generated recommendations to help you resolve it quickly'**
  String get answer6;

  /// No description provided for @question7.
  ///
  /// In en, this message translates to:
  /// **'How does the Camera & Alerts feature work?'**
  String get question7;

  /// No description provided for @answer7.
  ///
  /// In en, this message translates to:
  /// **'The Camera & Alerts module combines image analysis with smart notifications. Users can upload hive images for AI-based analysis. The application uses deep learning models to identify bee activity, detect potential diseases, and recognize abnormalities within the hive. All detected issues are displayed alongside sensor-based alerts so users can make informed decisions about hive management.'**
  String get answer7;

  /// No description provided for @question8.
  ///
  /// In en, this message translates to:
  /// **'How does the AI Assistant help me?'**
  String get question8;

  /// No description provided for @answer8.
  ///
  /// In en, this message translates to:
  /// **'The AI Assistant acts as your virtual beekeeping companion. It explains sensor readings, interprets alerts, answers questions about hive conditions, recommends corrective actions, and helps users understand the information displayed throughout the application. The assistant is available anytime from the main dashboard and is designed to simplify hive management for both beginners and experienced beekeepers.'**
  String get answer8;
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
