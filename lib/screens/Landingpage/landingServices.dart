import 'package:chatterverse/constants/Constantcolors.dart';
import 'package:chatterverse/screens/Homepage/homePage.dart';
import 'package:chatterverse/screens/Landingpage/landingUtils.dart';
import 'package:chatterverse/services/Authentication.dart';
import 'package:chatterverse/services/firebaseOperations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  ShowUserAvatar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ConstantColors().blueGreyColor,
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150.0),
            child: Divider(
              color: ConstantColors().whiteColor,
              thickness: 4.0,
            ),
          ),
          CircleAvatar(
            radius: 80.0,
            backgroundColor: ConstantColors().transparent,
            backgroundImage: FileImage(
              Provider.of<Landingutils>(context, listen: false).userAvatar,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  child: Text(
                    'Reselect',
                    style: TextStyle(
                      color: ConstantColors().whiteColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors().whiteColor,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Landingutils>(context, listen: false)
                        .pickUserAvatar(context, ImageSource.gallery);
                  },
                ),
                MaterialButton(
                  color: ConstantColors().blueColor,
                  child: Text(
                    'Confirm Image',
                    style: TextStyle(
                      color: ConstantColors().whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<Firebaseoperations>(context, listen: false)
                        .uploadUserAvatar(context)
                        .whenComplete(() {
                      signInSheet(context);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget passwordLessSignIn(BuildContext context) {
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            var s = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return  ListView(
                children: s!.docs.map((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.trashCan,
                        color: ConstantColors().redColor,
                      ),
                      onPressed: () {

                      },
                    ),
                    leading: CircleAvatar(
                      backgroundColor: ConstantColors().transparent,
                        // backgroundImage:
                        //     NetworkImage( documentSnapshot.data()['userimage'],
                        // ),
                        ),
                    subtitle: Text(
                      (documentSnapshot.data()
                          as Map<String, dynamic>)['userEmail'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ConstantColors().greenColor,
                          fontSize: 12),
                    ),
                    title: Text(
                        (documentSnapshot.data()
                            as Map<String, dynamic>)['userName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ConstantColors().greenColor)),
                  );
                }).toList(),
              );
            }
          }),
    );
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: ConstantColors().whiteColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter password...',
                        hintStyle: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      backgroundColor: ConstantColors().blueColor,
                      child: Icon(FontAwesomeIcons.check,
                          color: ConstantColors().whiteColor),
                      onPressed: () {
                        if (userEmailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(userEmailController.text,
                                  userPasswordController.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          }).catchError((errMsg) {
      Navigator.pop(context);
      // displayToastMessage(
      //     "Error: " + errMsg.toString(), context as BuildContext);
    });
                        } else {
                          warningText(context, 'Please fill all the fields');
                        }
                      })
                ],
              ),
              decoration: BoxDecoration(
                color: ConstantColors().blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ConstantColors().blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: ConstantColors().whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    // backgroundImage: FileImage(
                    //     Provider.of<Landingutils>(context, listen: false).getUserAvatar),
                    backgroundColor: ConstantColors().redColor,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter password...',
                        hintStyle: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: ConstantColors().redColor,
                        child: Icon(FontAwesomeIcons.check,
                            color: ConstantColors().whiteColor),
                        onPressed: () {
                          if (userEmailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(
                              userEmailController.text,
                              userPasswordController.text,
                            ).whenComplete((){
                              Provider.of<Firebaseoperations>(context, listen: false).createUserCollection(context, {
                                'useruid': Provider.of<Authentication>(context, listen: false).getUserid,
                                'useremail': userEmailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<Landingutils>(context, listen: false).getUserAvatarUrl,
                                // 'userpassword': userPasswordController.text,
                                // 'userfollowers': 0,
                                // 'userfollowing': 0,
                                // 'userposts': 0,
                                // 'userbio': 'Update your bio',
                                // 'userwebsite': 'Edit website',
                                // 'userphonenumber': 'Add Number',
                              });
                            })
                            .whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: HomePage(),
                                      type: PageTransitionType.bottomToTop));
                            }).catchError((errMsg) {
                              showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(errMsg.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

      Navigator.pop(context);
      // displayToastMessage(
      //     "Error: " + errMsg.toString(), context as BuildContext);
    });
                          } else {
                            warningText(context, 'Please fill all the fields');
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String error) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: ConstantColors().darkColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            color: ConstantColors().redColor,
            child: Center(
              child: Text(
                error,
                style: TextStyle(
                    color: ConstantColors().whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        });
  }
}
