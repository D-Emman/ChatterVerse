import 'package:chatterverse/constants/Constantcolors.dart';
import 'package:chatterverse/screens/Chatroom/chatroom.dart';
import 'package:chatterverse/screens/Feed/feed.dart';
import 'package:chatterverse/screens/Homepage/hompageHelpers.dart';
import 'package:chatterverse/screens/Profile/profile.dart';
import 'package:chatterverse/services/firebaseOperations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({super.key});
ConstantColors constantColors = ConstantColors();
final PageController homepageController = PageController();
int pageIndex = 0;

  void initState(){
    Provider.of<Firebaseoperations>(context, listen: false).initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homepageController,
          children: [
           Feed(),
           Chatroom(),
           Profile(),
          ],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page){
            setState(() {
              pageIndex = page;
            });
          },

        ),
        bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false).bottomNavbar(context, pageIndex, homepageController),
    );
  }
} 