import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String img;
  const ImageViewer({super.key, required this.img});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeInImage.assetNetwork(
            placeholder: "assets/images/arow_loading.jpeg",
            image: widget.img,
            fit: BoxFit.cover,
          ),
        ));
  }
}
