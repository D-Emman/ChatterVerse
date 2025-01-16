import 'package:chatterverse/screens/Homepage/hompageHelpers.dart';
import 'package:chatterverse/screens/Landingpage/landingHelpers.dart';
import 'package:chatterverse/screens/Landingpage/landingServices.dart';
import 'package:chatterverse/screens/Landingpage/landingUtils.dart';
import 'package:chatterverse/screens/Profile/profileHelpers.dart';
import 'package:chatterverse/screens/Splashscreen/splashScreen.dart';
import 'package:chatterverse/services/Authentication.dart';
import 'package:chatterverse/services/firebaseOperations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/Constantcolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD1Gf6VxT1Bf_NrNdko1ie59iR-3gsPeew",
      appId: "1:913820375459:android:9707f771225c72598a2216" ,
      messagingSenderId: "913820375459" ,
      projectId: "chatterverse-42945",
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: constantColors.blueColor),
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => Landingutils()),
          ChangeNotifierProvider(create: (_) => Firebaseoperations()),  
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => LandingService()),
        ]);
  }
}
 