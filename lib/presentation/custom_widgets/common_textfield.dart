import 'package:flutter/material.dart';

class TextfieldCommon extends StatelessWidget {
  final Size size;
  final TextEditingController controllerName;
  final FocusNode? focusNode;
  final String? Function(String?)? fromvalidator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? labelText;
  final void Function(String)? onFieldSubmitted;
  final bool obscureText;
  final TextInputAction? textInputAction;

  const TextfieldCommon({
    super.key, 
    required this.size,
    required this.controllerName,
    this.focusNode,
    this.fromvalidator,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.labelText,
    this.onFieldSubmitted,
    required this.obscureText, 
    this.textInputAction, 
     
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.8,
      child: TextFormField(
        onTapOutside: (value) {
          FocusScope.of(context).unfocus();
          },
        focusNode: focusNode,
        textInputAction:textInputAction,
        controller: controllerName,
        validator: fromvalidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText,
        decoration: InputDecoration( 
          hintText: hintText,
          labelText: labelText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
