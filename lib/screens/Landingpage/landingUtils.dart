import 'dart:io';

import 'package:chatterverse/constants/Constantcolors.dart';
import 'package:chatterverse/screens/Landingpage/landingServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Landingutils with ChangeNotifier {
  final picker = ImagePicker();
  var userAvatar;
  File get getUserAvatar => userAvatar;
  var userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        ? print('Select Image')
        : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.path);
    
    // ignore: unnecessary_null_comparison
    userAvatar != null
      ? Provider.of<LandingService>(context, listen: false).ShowUserAvatar(context) : print('Image upload error');
    notifyListeners();
  }

Future selectAvatarOptionsSheet(BuildContext context) async{
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors().blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 150.0), child: Divider(thickness: 4.0, color: ConstantColors().whiteColor),),
                Row(
                  children: [
                    MaterialButton(
                  onPressed: () {
                    pickUserAvatar(context, ImageSource.gallery)
                        .whenComplete(() {
                      Navigator.pop(context);
                      Provider.of<LandingService>(context, listen: false)
                          .ShowUserAvatar(context);
                    });
                  },
                  child: Text('Gallery',
                      style: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
                MaterialButton(
                  onPressed: () {
                    pickUserAvatar(context, ImageSource.camera)
                        .whenComplete(() {
                      Navigator.pop(context);
                      Provider.of<LandingService>(context, listen: false)
                          .ShowUserAvatar(context);
                    });
                  },
                  child: const Text('Camera',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                )
                  ],
                ),
                
              ],
            ),
          );
        });
  }

}
