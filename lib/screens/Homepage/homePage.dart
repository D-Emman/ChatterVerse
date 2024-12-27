import 'package:chatterverse/constants/Constantcolors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  // const HomePage({super.key});
ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.blueGreyColor,
    );
  }
}