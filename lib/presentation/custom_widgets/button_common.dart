import 'package:flutter/material.dart';

class ButtonCommon extends StatelessWidget {
  final String buttontxt;
  final Function() press;
  final Color bgroundcolor;
  final Color? txtcolor;
  final double? width;
  final double? height;

  const ButtonCommon({
    super.key,
    required this.buttontxt,
    required this.press,
    required this.bgroundcolor,
    this.txtcolor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: ElevatedButton(
          onPressed: press,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgroundcolor,
          ),
          child: Text(
            buttontxt,
            style: TextStyle(fontSize: 18, color: txtcolor),
          ),
        ),
      ),
    );
  }
}
