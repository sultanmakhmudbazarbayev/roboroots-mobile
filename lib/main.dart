import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/intro/intro_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure test devices (replace with your device ID from the log or by calling AdRequest.testDevices)
  final RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['262F40A7BFD32D617CC24AB16B716563'],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  MobileAds.instance.initialize(); // Initialize the Mobile Ads SDK
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Learning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
