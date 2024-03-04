import 'package:doc_upload/application/homeBloc/home_bloc.dart';
import 'package:doc_upload/firebase_options.dart';
import 'package:doc_upload/infrastructure/provider/password_provider.dart';
import 'package:doc_upload/utils/routes/routes.dart';
import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


@pragma("vm:entry-point")
Future<void> _setupFirebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_setupFirebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FileUploadBloc>(
      create: (context) => FileUploadBloc(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PasswordVisibilityProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ConfirmPasswordVisibilityProvider(),
          ),
        ],
        child: MaterialApp(
          title: "Info Profile",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  elevation: 1,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  backgroundColor: Color(0xFF344955)),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF344955)),
              cardTheme: const CardTheme(surfaceTintColor: Colors.lightBlue),
              dialogTheme: const DialogTheme(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white)),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}
