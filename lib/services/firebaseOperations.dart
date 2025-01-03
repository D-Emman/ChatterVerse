import 'package:chatterverse/screens/Landingpage/landingUtils.dart';
import 'package:chatterverse/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Firebaseoperations with ChangeNotifier {
   // UploadTask imageUploadTask;
  var imageUploadTask;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<Landingutils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<Landingutils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('Image uploaded!');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<Landingutils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'the user profile avatar url => $Provider.of<LandingUtils>(context, listen: false).userAvatarUrl');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserid)
        .set(
      data
    );
  }
}
