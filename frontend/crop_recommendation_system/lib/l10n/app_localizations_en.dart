// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Birsa Kisan Drishti';

  @override
  String get name => 'Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get getOTP => 'Get OTP';

  @override
  String get otp => 'OTP';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get logout => 'Logout';

  @override
  String get alreadyUser => 'Already have an account ?';

  @override
  String get remember => 'Remember Me';

  @override
  String get humidity => 'Humidity';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get wind => 'Wind';

  @override
  String get pressure => 'Pressure';

  @override
  String get manageFarm => 'Manage Your Farm';

  @override
  String get myFarm => 'My Farm';

  @override
  String get cropRecommendation => 'Crop Recommendation';

  @override
  String get diseaseDetection => 'Disease Detection';

  @override
  String get myCrop => 'Crop Recommendation';

  @override
  String get marketPrices => 'Market Prices';

  @override
  String get chatBot => 'Chat Bot';

  @override
  String get settings => 'Settings';

  @override
  String get updateProfile => 'Update Your Profile';

  @override
  String get language => 'Language';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get askChatbot => 'Ask to our AI chatbot';

  @override
  String get goToFAQs => 'BirsaKisanDrishti FAQs';

  @override
  String get aboutUs => 'About us';

  @override
  String get logOut => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get feedback => 'Feedback';

  @override
  String get faqsHeading => 'FAQs';

  @override
  String get liveSoilScan => 'Live Soil Scan';

  @override
  String get liveSoilScanDesc => 'Get instant soil data from your soil sensor';

  @override
  String get manualSoilData => 'Enter Soil Data';

  @override
  String get manualSoilDataDesc => 'Enter your soil values manually';

  @override
  String get uploadReport => 'Upload Soil Report';

  @override
  String get uploadReportDesc => 'Upload your existing soil test report';

  @override
  String get bookSoilCollection => 'Book Soil Collection';

  @override
  String get bookSoilCollectionDesc =>
      'Schedule a soil sample collection from farm';

  @override
  String get uploadImage => 'Upload image \n or \n click the live image';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get chatWelcomeMsg =>
      'Hello! I\'m your AI farming companion. Whether you need help with crop diseases, fertilizer recommendations, weather information, or best farming practices, I\'m here to help. Ask me anything! You can chat with me in your preferred language';

  @override
  String get typeMessage => 'Input Your Query';

  @override
  String get caption => 'Smart Farming Toolkit';

  @override
  String get caption2 => 'AI powered assistant to improve your crop yield.';

  @override
  String get features => 'Smart Farming Features';

  @override
  String get cropDesc =>
      'AI-based crop suggestion using N, P, K, pH and weather.';

  @override
  String get diseaseDetectionDesc =>
      'Scan plant leaves for real-time disease diagnosis.';

  @override
  String get waterReq => 'Water Requirement';

  @override
  String get waterReqDesc => 'Shows irrigation requirement for selected crops.';

  @override
  String get weatherForecast => 'Weather Forecast';

  @override
  String get weatherForecastDesc =>
      'Smart weather insights for better planning.';

  @override
  String get marketPriceFeature => 'Market Price Insight';

  @override
  String get marketPriceDesc => 'Real-time mandi prices with market trends.';

  @override
  String get govtSchemes => 'Government Schemes';

  @override
  String get govtSchemesDesc => 'Eligibility details and application guidance.';

  @override
  String get cropCalendar => 'Seasonal Crop Calendar';

  @override
  String get cropCalendarDesc => 'Month-wise sowing and harvesting schedule.';

  @override
  String get reminder => 'Farming Task Reminder';

  @override
  String get reminderDesc => 'Reminders for irrigation, sowing and harvesting.';

  @override
  String get question1 => 'How does disease detection work?';

  @override
  String get answer1 =>
      'Using AI image recognition, you just need to take a clear photo of the affected leaf with your phone camera, and the app compares it with thousands of known disease images to detect the problem. After detection, it shows likely causes, suggested treatments, and basic prevention tips in simple language.';

  @override
  String get question2 => 'How is water requirement calculated?';

  @override
  String get answer2 =>
      'The app estimates water requirement by combining crop type, soil moisture, local temperature, humidity, and recent rainfall data. Using standard irrigation formulas, it converts this into an easy schedule like \'water every 3 days\' so farmers can plan irrigation without doing any calculations.';

  @override
  String get question3 => 'Are market prices updated daily?';

  @override
  String get answer3 =>
      'Mandi prices in the app are refreshed several times a day using government and trusted market data sources to keep rates current. During busy trading hours, prices may update as frequently as every few minutes so farmers can decide the best time and place to sell.';

  @override
  String get question4 => 'Does the app work offline?';

  @override
  String get answer4 =>
      'Key information already loaded on the device, like saved recommendations and last-viewed tips, can be accessed even without internet. Features that need live data, such as new weather forecasts or fresh mandi prices, will update automatically the next time the phone is online.';

  @override
  String get question5 => 'Can farmers check government schemes?';

  @override
  String get answer5 =>
      'The app shows recent agriculture schemes and subsidies from official portals, focusing on those useful for small and marginal farmers. For each scheme, farmers can quickly see who is eligible, important benefits, and basic steps to apply.';

  @override
  String get question6 => 'Is my data safe?';

  @override
  String get answer6 =>
      'Only the minimum information needed to run the service is collected, and it is stored using standard security practices similar to other modern apps. Personal data is never sold, and any sharing (for example with government platforms or partners) happens only to provide core services and in line with data protection rules.';

  @override
  String get question7 => 'How can I use AI to predict crop yield?';

  @override
  String get answer7 =>
      'Using AI models, historical yield data, and local weather patterns, the app gives an estimated yield range for the recommended crop. This estimate is meant as guidance to help with planning and is not a guarantee, since actual yield also depends on field practices and unexpected weather.';

  @override
  String get question8 => 'Does the app support regional languages?';

  @override
  String get answer8 =>
      'The app supports multiple Indian languages commonly spoken by farmers so they can read information in a familiar script. Farmers can change language anytime from settings, and important labels and buttons are translated for easier use.';

  @override
  String get aboutusDesc1 => '-Your Smart Farming Companion';

  @override
  String get aboutusDesc2 =>
      'BirsaKisanDrishti is an innovative Al-powered farming assistant built to help farmers make smarter decisions. Our mission is to boost crop yield, maximize profit, and simplify farming through technology.';

  @override
  String get provided => 'What We Provide';

  @override
  String get smartCrop => 'Smart Crop\nRecommendation';

  @override
  String get soilInsight => 'Satellite\nBased Soil\nInsights';

  @override
  String get soilParameters => 'Uses soil parameters (N,P,K,pH)';

  @override
  String get aiFarming => 'AI Farming\nAssistance';

  @override
  String get fertilizerRecommendation => 'Fertilizer\nRecommendation';

  @override
  String get waterRequired => 'Water\nRequirement\nGuide';

  @override
  String get weatherPrediction => 'Weather\nBased Soil\nInsights';

  @override
  String get mission => 'Our Mission';

  @override
  String get missionDesc =>
      'Empowering every farmer with AI-driven knowledge to increase productivity and sustainability';

  @override
  String get feedbackDesc => 'We would love to hear your feedback';

  @override
  String get feedbackDesc2 => 'How Would You Rate Us?';

  @override
  String get shareThoughts => 'Share Your Thoughts';

  @override
  String get review => 'Write your review here';

  @override
  String get feedbackSubmitted => 'Feedback Submitted';

  @override
  String get feedbackSubmitDesc =>
      'Your feedback is successfully submitted. we respect and care your feedback. Our team will look into it.';

  @override
  String get feedbackSubmission => 'Submit Feedback';

  @override
  String get soilDetails => 'Soil Details';

  @override
  String get fetchDetails => 'Fetch Soil Details';

  @override
  String get enterN => 'Enter Nitrogen Value';

  @override
  String get enterP => 'Enter Phosphorous Value';

  @override
  String get enterK => 'Enter Potassium Value';

  @override
  String get enterPh => 'Enter pH Value';

  @override
  String get enterTemp => 'Enter Temperature';

  @override
  String get enterHumidity => 'Enter Humidity';

  @override
  String get enterRainfall => 'Enter Rainfall';

  @override
  String get enterMoisture => 'Enter Soil Moisture';

  @override
  String get enterSoilType => 'Enter Soil Type';

  @override
  String get send => 'Send';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get welcomeMessage => 'Welcome to Birsa Kisan Drishti';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get chatBotMessage =>
      'Hello! I\'m your AI farming companion. Whether you need help with crop diseases, fertilizer recommendations, weather information, or best farming practices, I\'m here to help. Ask me anything! You can chat with me in your preferred language';

  @override
  String get unknownDisease => 'Unknown Disease';

  @override
  String get mortalityRate => 'Mortality Rate';

  @override
  String get cropType => 'Crop Type';

  @override
  String get diseaseStage => 'Disease Stage';

  @override
  String get severity => 'Severity';

  @override
  String get overview => 'Overview';

  @override
  String get weatherCondition => 'Weather Conditions';

  @override
  String get precaution => 'Precautions';

  @override
  String get organicCure => 'Cure: Organic';

  @override
  String get inOrganicCure => 'Cure: InOrganic';

  @override
  String get locationDisabled => 'Location service disabled';

  @override
  String get tryAgainLocation => 'Try again after enabling location service';

  @override
  String get locationPermissionDenied =>
      'Location permissions are permanently denied';

  @override
  String get renameChat => 'Rename Chat';

  @override
  String get deleteConvo => 'Delete Conversation';

  @override
  String get deleteConvoDesc =>
      'This chat will not be available after deletion.';

  @override
  String get error => 'Error';

  @override
  String get failDeleteConvo => 'Failed to delete conversation';

  @override
  String get failLoadConvo => 'Failed to load conversation';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get typing => 'Typing...';

  @override
  String get askAnything => 'Ask Anything';

  @override
  String get getRecommendation => 'Get Recommendation';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get yeildProduction => 'Yeild Production';
}
