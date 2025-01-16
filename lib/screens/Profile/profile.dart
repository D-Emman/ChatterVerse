

import 'package:chatterverse/constants/Constantcolors.dart';
import 'package:chatterverse/screens/Profile/profileHelpers.dart';
import 'package:chatterverse/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(EvaIcons.settings2Outline,
              color: constantColors.lightBlueColor),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon:
                Icon(EvaIcons.logOutOutline, color: constantColors.greenColor),
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false).logOutDialog(context);
            },
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
            text: TextSpan(
          text: 'My',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Profile',
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new Column(
                      children: [
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .headerProfile(
                                context, snapshot as DocumentSnapshot<Object?>),
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .divider(),
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .middleProfile(
                                context, snapshot as DocumentSnapshot<Object?>),
                        Provider.of<ProfileHelpers>(context, listen: false)
                            .footerProfile(
                                context, snapshot as DocumentSnapshot<Object?>),
                      ],
                    );
                  }
                },
              )),
        ),
      ),
    );
  }
}
