import 'dart:ui';

import 'package:flutter/material.dart';

class ContainerFilter extends StatelessWidget {
  const ContainerFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.transparent),
      ),
    );
  }
}
