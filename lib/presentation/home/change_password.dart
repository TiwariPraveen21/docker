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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confpasswordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode cnfpassFocusNode = FocusNode();

  AuthProviderBloc authBloc = AuthProviderBloc();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final passwordVisibilityProvider = Provider.of<PasswordVisibilityProvider>(context);
    final cpasswordVisibilityProvider = Provider.of<ConfirmPasswordVisibilityProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlocConsumer<AuthProviderBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is AuthSuccessState) {
                //Handle the successState
                 Navigator.pushNamed(context, RoutesName.home);
                 AppUtils.showSuccessMessage(state.message);
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  //User Name textfield

                  TextfieldCommon(
                    size: MediaQuery.of(context).size,
                    controllerName: passwordController,
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.next,
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
                    obscureText: !passwordVisibilityProvider.isPasswordVisible,
                    hintText: AppString.changepasshint,
                    labelText: AppString.changepasslabel,
                    fromvalidator: (val) {
                      if (passwordController.text.isEmpty) {
                        return AppString.passempt;
                      }
                      if (!RegExp(AppString.passregex)
                          .hasMatch(passwordController.text)) {
                        return AppString.passerr;
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      passwordFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(cnfpassFocusNode);
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextfieldCommon(
                    size: MediaQuery.of(context).size,
                    controllerName: confpasswordController,
                    focusNode: cnfpassFocusNode,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cpasswordVisibilityProvider.isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        cpasswordVisibilityProvider
                            .toggleConfirmPasswordVisibility();
                      },
                    ),
                    obscureText:!cpasswordVisibilityProvider.isConfirmPasswordVisible,
                    hintText: AppString.conchangepasshint,
                    labelText: AppString.conchangepasslabel,
                    fromvalidator: (val) {
                      if (passwordController.text.isEmpty) {
                        return AppString.cpassempt;
                      }
                      if (passwordController.text ==
                          confpasswordController.text) {
                        return AppString.changepsderror;
                      }
                      if (!RegExp(AppString.cpassregex)
                          .hasMatch(passwordController.text)) {
                        return AppString.cpasserr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * .095,
                        vertical: size.height * .013),
                    child: ButtonCommon(
                        width: size.width * .55,
                        height: size.height * 0.05,
                        buttontxt: AppString.changebtn,
                        press: () async {
                          if (_formKey.currentState!.validate()) {
                            authBloc.add(
                             ChangePasswordEvent(
                              passwordController.text.toString().trim(), 
                              confpasswordController.text.toString().trim()
                             )
                            );
                          }
                        },
                        bgroundcolor: Colors.orange),
                  ),
                  SignInSignUp(
                    size: size,
                    accountinfo: AppString.yespassword,
                    margin: EdgeInsets.symmetric(
                        horizontal: size.width * .095,
                        vertical: size.height * .010),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RoutesName.home, (route) => false);
                    },
                  )
                ],
              ));
            }),
      ),
    );
  }
}
