import 'package:doc_upload/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool?> registerUserWithEmailPassword(String email, String password) async{
    bool? res;
    await auth.createUserWithEmailAndPassword(email: email, password: password)
    .then((value) async {
      res = true;
      debugPrint("Success SignUp");
      // Send verification email
       await sendVerificationEmail(); 
    }).onError((error, stackTrace) {
      debugPrint("Error While SignUp $error");
      res = false;

    });
    return res;
  }

  Future<void> sendVerificationEmail() async {
    await auth.currentUser!.sendEmailVerification();
    AppUtils.showSuccessMessage("Verification email sent");
  }


  Future<bool?> logOut() async {
    bool? res;
    await auth.signOut().then((value) {
      debugPrint("Logout Success");
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

//Methos to login using email password

Future<bool?> loginUsingEmailAndPassword(String email, String password) async {
  bool? res;
  debugPrint("Email :$email \n Password: $password");
  await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  ).then((value) async{
    await auth.currentUser!.reload();
     // Handle the case when the user's email is verified
    if (value.user!.emailVerified) {
      debugPrint("User logged in successfully");
      res = true;
    } 
     // Handle the case when the user's email is not verified
    else {
      AppUtils.showSuccessMessage("User's email is not verified");
      res = false;
    }
  }).onError((error, stackTrace) {
    res = false;
    debugPrint("Error is $error");
  });

  return res;
}
Future<bool?> resetPassword(String email) async {
  bool? res;
  try {
    await auth.sendPasswordResetEmail(email: email);
    res = true;
    debugPrint("Password reset email sent");
  } catch (e) {
    res = false;
    debugPrint("Failed to send password reset email: $e");
  }
  return res;
}


Future<bool> changePassword(String currentPassword, String newPassword) async {
  try {
    User? user = auth.currentUser;
    if (user != null) {
      // Reauthenticate the user using the provided current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      // Change the user's password
      await user.updatePassword(newPassword);
      return true; 
    } else {
      debugPrint('User not signed in');
      return false;
    }
  } catch (e) {
   AppUtils.showErrorMessage('Error changing password');
    return false;
  }
}

// //Method to send otp
//   Future<String?> sendOtp(String phoneNumber) async {
//     String? res;
//     debugPrint("Going to send otp on $phoneNumber");
//     await auth.verifyPhoneNumber(
//         phoneNumber: "+91$phoneNumber",
//         verificationCompleted: (_) {
//           debugPrint("Verification is completed");
//         },
//         verificationFailed: (e) {
//           debugPrint("Error while sending otp $e");
//         },
//         codeSent: (String verificationId, int? token) {
//           debugPrint("Verification code is $verificationId");
//           res = verificationId;
//         },
//         codeAutoRetrievalTimeout: (e) {
//           debugPrint("Error is $e");
//         });
//     debugPrint("OTP sent Success $res");
//     return res;
//   }

//   // Method to verifyOtp
//   Future<bool?> verifyOtp(String verification, String otp) async {
//     bool? res;
//     final  credential = PhoneAuthProvider.credential(
//         verificationId: verification, smsCode: otp);
//     await auth.signInWithCredential(credential).then((value) async {
//       debugPrint("OTP Matched response is $value");
//       res = true;
//     }).onError((error, stackTrace) {
//       debugPrint("Failed Matching OTP $error");
//       res = false;
//     });
//     return res;
//   }


}
