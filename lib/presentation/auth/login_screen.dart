import 'package:doc_upload/application/authBloc/auth_bloc.dart';
import 'package:doc_upload/application/authBloc/auth_event.dart';
import 'package:doc_upload/application/authBloc/auth_state.dart';
import 'package:doc_upload/infrastructure/provider/password_provider.dart';
import 'package:doc_upload/presentation/custom_widgets/app_string.dart';
import 'package:doc_upload/presentation/custom_widgets/button_common.dart';
import 'package:doc_upload/presentation/custom_widgets/common_textfield.dart';
import 'package:doc_upload/presentation/custom_widgets/signin_signup_textbutton.dart';
import 'package:doc_upload/utils/app_utils.dart';
import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController namecontroller = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  AuthProviderBloc authBloc = AuthProviderBloc();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final passwordVisibilityProvider =Provider.of<PasswordVisibilityProvider>(context);
    //final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return Scaffold(
        body: BlocConsumer<AuthProviderBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is AuthSuccessState) {
                //Handle the successState
                AppUtils.showSuccessMessage(state.message);
                Navigator.pushNamed(context, RoutesName.home);
              } else if (state is AuthErrorState) {
                // Handle error, show an error message, etc.
                AppUtils.showErrorMessage(state.error);
              }
            },
            builder: (context, state) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .095),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextfieldCommon(
                      size: MediaQuery.of(context).size,
                      controllerName: emailController,
                      focusNode: emailFocusNode,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      hintText: AppString.mailhint,
                      labelText: AppString.maillabel,
                      fromvalidator: (val) {
                        if (emailController.text.isEmpty) {
                          return AppString.mailempt;
                        }
                        if (!RegExp(AppString.mailregex)
                            .hasMatch(emailController.text)) {
                          return AppString.mailerr;
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        emailFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextfieldCommon(
                      size: MediaQuery.of(context).size,
                      controllerName: passController,
                      focusNode: passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisibilityProvider.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          passwordVisibilityProvider.togglePasswordVisibility();
                        },
                      ),
                      obscureText:
                          !passwordVisibilityProvider.isPasswordVisible,
                      hintText: AppString.passhint,
                      labelText: AppString.passlabel,
                      fromvalidator: (val) {
                        if (passController.text.isEmpty) {
                          return AppString.passempt;
                        }
                        if (!RegExp(AppString.passregex)
                            .hasMatch(passController.text)) {
                          return AppString.passerr;
                        }
                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * .095,
                          vertical: size.height * .015),
                      child: InkWell(
                        onTap: () {
                           showResetPasswordDialog();
                        },
                        child: const Text(
                          AppString.forgot,
                          style:
                              TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * .095,
                          vertical: size.height * .015),
                      child: ButtonCommon(
                          width: size.width * .53,
                          height: size.height * 0.05,
                          buttontxt: AppString.lgn,
                          press: () async {
                            if (emailController.text.isEmpty ||
                                passController.text.isEmpty) {
                              debugPrint(AppString.aldtls);
                            } else {
                              // await authProvider.loginUsingEmailAndPassword(context, emailController.text.toString(), passController.text.toString());
                              authBloc.add(
                                LoginEvent(
                                  emailController.text,
                                  passController.text,
                                ),
                              );
                            }
                          },
                          bgroundcolor: Colors.orange),
                    ),
                    SignInSignUp(
                      size: size,
                      accountinfo: AppString.noacount,
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * .095,
                          vertical: size.height * .010),
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, RoutesName.signUp, (route) => false);
                      },
                    )
                  ],
                ),
              );
            }));
  }

  void showResetPasswordDialog(){
    final resetpsdController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder:(context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                      controller: resetpsdController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (emailController.text.isEmpty) {
                          return AppString.mailempt;
                        }
                        if (!RegExp(AppString.mailregex)
                            .hasMatch(emailController.text)) {
                          return AppString.mailerr;
                        }
                        return null;
                      },
                    ),
              ],
            ),
          ),
          actions: [
           TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
            AuthProviderBloc().add(ResetPasswordEvent(resetpsdController.text.toString()));
            },
            child: const Text('Send'),
          ),
          ],
        );
      });
  }
}
