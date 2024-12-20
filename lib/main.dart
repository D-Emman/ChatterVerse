import 'package:chatterverse/screens/Landingpage/landingHelpers.dart';
import 'package:chatterverse/screens/Splashscreen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/Constantcolors.dart';

void main() {
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
          ChangeNotifierProvider(create: (_) => LandingHelpers())
        ]);
  }
}
