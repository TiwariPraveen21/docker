import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> checkAuthentication(BuildContext context) async {
    debugPrint(user.toString());

    await Future.delayed(const Duration(seconds: 3));

    if (user == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
    }
  }
}
