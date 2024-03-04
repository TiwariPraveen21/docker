import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NotificationScreen extends StatefulWidget {
  final String type;
  final String id;
  final String? docLink;
  final String? documentType;
  const NotificationScreen(
      {super.key,
      required this.type,
      required this.id,
      this.docLink,
      this.documentType});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    debugPrint("My Link ${widget.docLink}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Notification Screen"),
      ),
      body: (widget.docLink != null &&
              widget.documentType != null &&
              widget.documentType == "image")
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("You Have uploaded a new document to your app 🥳",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10.0),
                          ),
                          child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/arow_loading.jpeg",
                              image: widget.docLink.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Notification Type :${widget.type}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Notification ID :${widget.id}")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : (widget.docLink != null &&
                  widget.documentType != null &&
                  widget.documentType == "pdf")
              ? SfPdfViewer.network(
                  widget.docLink!,
                  key: _pdfViewerKey,
                )
              : Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.deepOrange,
                                  Colors.purple
                                ]).createShader(bounds),
                            child: Text("Notification Type :${widget.type}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.deepOrange,
                                  Colors.purple
                                ]).createShader(bounds),
                            child: Text("Notification ID :${widget.id}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
