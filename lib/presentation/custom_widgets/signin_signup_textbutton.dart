import 'package:flutter/material.dart';
class SignInSignUp extends StatelessWidget {
  const SignInSignUp(
      {super.key,
      required this.size,
      required this.accountinfo,
      this.margin,
      this.onTap});

  final Size size;
  final String accountinfo;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          accountinfo,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2661FA)),
        ),
      ),
    );
  }
}
