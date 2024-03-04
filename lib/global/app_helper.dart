import 'dart:io';
import 'package:doc_upload/application/homeBloc/home_bloc.dart';
import 'package:doc_upload/application/homeBloc/home_event.dart';
import 'package:doc_upload/presentation/custom_widgets/app_string.dart';
import 'package:doc_upload/utils/app_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

String docType = "Image";
String docUrl = "";
final _auth = FirebaseAuth.instance;

void showCustomDialog(BuildContext context, File file) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final msgController = TextEditingController();
  FileUploadBloc fileUploadBloc2 = FileUploadBloc();
  final mobileController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context,) {
      return AlertDialog(
        title: const Text('Share File'),
        content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getFileIcon(file),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (mobileController.text.isEmpty) {
                        return AppString.mobilempt;
                      }
                      if (!RegExp(AppString.mobilegex)
                          .hasMatch(mobileController.text)) {
                        return AppString.mobileerr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: msgController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (msgController.text.isEmpty ||
                          msgController.text == "") {
                        return AppString.msgerror;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (_auth.currentUser!.email ==
                    emailController.text.toString()) {
                  AppUtils.showErrorMessage("You can no send data to yourself");
                  Navigator.of(context).pop();
                } else {
                  fileUploadBloc2.add(SaveShareFileEvent(
                      emailController.text.toString(),
                      msgController.text.toString(),
                      file));

                  Navigator.of(context).pop();
                  // Send WhatsApp message
                  String phoneNumber = mobileController.text.toString().trim();
                  String message = '${_auth.currentUser!
                      .email} send you a document';
                  await sendWhatsAppMessage(phoneNumber, message);
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );
}

Widget getFileIcon(File file) {
  String fileName = file.path
      .split('/')
      .last;
  if (fileName.endsWith('.pdf')) {
    docType = "pdf";
    return const Icon(Icons.picture_as_pdf, size: 100);
  } else if (fileName.endsWith('.jpg') ||
      fileName.endsWith('.jpeg') ||
      fileName.endsWith('.png')) {
    docType = "image";
    return Image.file(file, height: 100, width: 200);
  } else {
    return const Icon(Icons.insert_drive_file, size: 50);
  }
}

void showConfirmationDialog(BuildContext prevContext, File file,
    FilePickerResult? result) {
  showDialog(
    context: prevContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Upload'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: getFileIcon(file),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to upload this document?',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<FileUploadBloc>(context).add(SelectFileEvent(File(result!.files.single.path!)));

               Navigator.of(context).pop(true);
            },
            child: const Text('Upload'),
          ),
        ],
      );
    },
  );
}

void showCustomShareDialog(BuildContext context, String imglink, String type) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final msgController = TextEditingController();
  final mobileController = TextEditingController();
  FileUploadBloc fileUploadBloc2 = FileUploadBloc();
  docType = type;

  showDialog(
    context: context,
    builder: (BuildContext context,) {
      return AlertDialog(
        title: const Text('Share File'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == "image") Image.network(imglink),
                if (type == "pdf")
                  const Icon(
                    Icons.picture_as_pdf,
                    size: 100,
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (mobileController.text.isEmpty) {
                      return AppString.mobilempt;
                    }
                    if (!RegExp(AppString.mobilegex)
                        .hasMatch(mobileController.text)) {
                      return AppString.mobileerr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: msgController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (msgController.text.isEmpty ||
                        msgController.text == "") {
                      return AppString.msgerror;
                    }
                    return null;
                  },
                ),
              ],
            ),
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
              if (formKey.currentState!.validate()) {
                // If try to send document to yourself
                if (_auth.currentUser!.email ==
                    emailController.text.toString()) {
                  AppUtils.showErrorMessage("You cannot send data to yourself");
                }
                // If sending document to other
                else {
                  fileUploadBloc2.add(UploadSharingImageEvent(
                    emailController.text.toString(),
                    msgController.text.toString(),
                    imglink,
                  ));
                  Navigator.of(context).pop();
                  // Send WhatsApp message
                  String phoneNumber = mobileController.text.toString().trim();
                  String message = 'Hello, check out this document: $imglink';
                  await sendWhatsAppMessage(phoneNumber, message);
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );
}

Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
  // Encode the message
  debugPrint("My number $phoneNumber");
  String encodedMessage = Uri.encodeFull(message);

  // Construct the WhatsApp URL
  debugPrint("going to number");
  String url = 'https://wa.me/$phoneNumber?text=$encodedMessage';

  // Check if WhatsApp is installed on the device
  if (await canLaunchUrl(Uri.parse(url))) {
    debugPrint("opening");
    // Open WhatsApp with the pre-filled message
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}


// void showCustomShareDialog(BuildContext context, String imglink, String type) {
//     final emailController = TextEditingController();
//     final msgController = TextEditingController();
//     FileUploadBloc fileUploadBloc2 = FileUploadBloc();
//     docType = type;
//     showDialog(
//       context: context,
//       builder: (
//         BuildContext context,
//       ) {
//         return AlertDialog(
//           title: const Text('Share File'),
//           content: SingleChildScrollView(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//              if(type == "image")
//              Image.network(imglink),
//              if(type == "pdf")
//              const Icon(Icons.picture_as_pdf,size: 100,),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: msgController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Message',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           )),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if(_auth.currentUser!.email == emailController.text.toString()){
//                   AppUtils.showErrorMessage("You can no send data to yourself");
//                   Navigator.of(context).pop();
//                 }
//                 else{
//                fileUploadBloc2.add(UploadSharingImageEvent(
//                     emailController.text.toString(),
//                     msgController.text.toString(),
//                      imglink));

//                 Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Send'),
//             ),
//           ],
//         );
//       },
//     );
//   }