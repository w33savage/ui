// import 'package:clubhouse/utils/router.dart';
// import 'package:clubhouse/screens/home/home_screen.dart';
import 'dart:io';

import 'package:club_house/pages/home/home_page.dart';
import 'package:club_house/pages/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:club_house/util/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  /// returns the initial screen depending on the authentication results
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return WelcomePage();
        }
      },
    );
  }

  createUser(_firstNameController, _lastNameController) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = _auth.currentUser;

    final collection = FirebaseFirestore.instance.collection('users');
    await collection.add(
      {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'uid': _user.uid
      },
    );
  }

  updateUser(updateRequestData) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      final User _user = _auth.currentUser;

      final QuerySnapshot filteredUsers = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'uid',
            isEqualTo: _user.uid,
          )
          .get();

      final List<DocumentSnapshot> userData = filteredUsers.docs;

      final String currentActiveUserId = userData[0].id;

      // if (isAuthUser) {
      //   print(updateRequestData);
      //   if (updateRequestData["displayName"] != null) {
      //     print(updateRequestData);
      //     await _user.updateDisplayName(updateRequestData["displayName"]);
      //   } else if (updateRequestData["displayName"] != null) {
      //     await _user.updatePhotoURL(updateRequestData["photoURL"]);
      //   }
      // } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentActiveUserId)
          .update(updateRequestData);
      // }
    } catch (e) {
      throw e;
    }
  }

  uploadProfilePic(_image) async {
    final User _user = _auth.currentUser;

    Reference reference = storage.ref().child("profileImages/${_user.uid}");

    //Upload the file to firebase
    await reference.putFile(File(_image.path));

    // Future<String> url = res.ref.getDownloadURL();
  }

  getUid() {
    final User _user = _auth.currentUser;
    return _user.uid;
  }

  getProfilePic() async {
    final User _user = _auth.currentUser;

    Reference reference = storage.ref().child("profileImages/${_user.uid}");
    var downloadUrl = await reference.getDownloadURL();
    // //String url = (await reference.getDownloadURL()).toString();
    return new NetworkImage(downloadUrl);
  }

  /// This method is used to logout the `FirebaseUser`
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// This method is used to login the user
  ///  `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
  /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
  signIn(BuildContext context, AuthCredential authCreds) async {
    final User user =
        (await FirebaseAuth.instance.signInWithCredential(authCreds)).user;

    // AuthResult result = (await FirebaseAuth.instance
    //     .signInWithCredential(authCreds)) as AuthResult;

    if (user != null) {
      print('user data $user');
      History.pushPageReplacement(context, HomePage());
    } else {
      print("Error");
    }
  }

  /// get the `smsCode` from the user
  /// when used different phoneNumber other than the current (running) device
  /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
  signInWithOTP(BuildContext context, smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    print('authcredz $authCreds');
    signIn(context, authCreds);
  }
}

mixin AuthResult {
  get user => null;
}
