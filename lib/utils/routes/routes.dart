import 'package:doc_upload/presentation/auth/login_screen.dart';
import 'package:doc_upload/presentation/auth/signup_screen.dart';
import 'package:doc_upload/presentation/home/change_password.dart';
import 'package:doc_upload/presentation/home/home_screen.dart';
import 'package:doc_upload/presentation/home/imag_viewer.dart';
import 'package:doc_upload/presentation/home/pdf_viewer.dart';
import 'package:doc_upload/presentation/notification/notification_screen.dart';
import 'package:doc_upload/presentation/splash_screen.dart';
import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());

      case RoutesName.signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignupScreen());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());

      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());

      case RoutesName.docView:
        Map<String, dynamic> doc = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                PdfViewerScreen(fileLink: doc['filelink']));

      case RoutesName.imgView:
        Map<String, dynamic> imgV = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ImageViewer(img: imgV['filelink']));

      case RoutesName.changepassword:
      return MaterialPageRoute(builder:(context) => const ChangePasswordScreen());
      
      case RoutesName.notificationView:
      Map<String,dynamic> notification = settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen(
              type:notification['type'],id:
               notification['id'],
                docLink: notification['docLink'],
                documentType: notification['doctype'],
               ));


      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No Route Defined"),
            ),
          );
        });
    }
  }
}
