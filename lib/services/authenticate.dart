// import 'package:clubhouse/utils/router.dart';
// import 'package:clubhouse/screens/home/home_screen.dart';
import 'package:club_house/pages/home/home_page.dart';
import 'package:club_house/pages/welcome/phone_number_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:club_house/util/history.dart';

class AuthService {
  /// returns the initial screen depending on the authentication results
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        print('hii');
        if (snapshot.hasData) {
          return PhoneNumberPage();
        } else {
          print(snapshot);
          return PhoneNumberPage();
        }
      },
    );
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
