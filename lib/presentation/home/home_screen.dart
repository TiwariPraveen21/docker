import 'dart:io';
import 'package:doc_upload/application/authBloc/auth_bloc.dart';
import 'package:doc_upload/application/authBloc/auth_event.dart';
import 'package:doc_upload/application/authBloc/auth_state.dart';
import 'package:doc_upload/application/homeBloc/home_bloc.dart';
import 'package:doc_upload/application/homeBloc/home_event.dart';
import 'package:doc_upload/application/homeBloc/home_state.dart';
import 'package:doc_upload/domain/models/documents_data_model.dart';
import 'package:doc_upload/global/app_helper.dart';
import 'package:doc_upload/utils/firebase_utils.dart';
import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilePickerResult? result;
  FilePickerResult? result2;

  @override
  void initState() {
    fetchHandling();
    super.initState();
    FirebaseUtils().setupFirebaseMessaging(context);
    FirebaseUtils().setupInteractMessage(context);
  }

  void fetchHandling() {
    BlocProvider.of<FileUploadBloc>(context).add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    AuthProviderBloc authBloc = AuthProviderBloc();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Screen"),
        actions: [
          BlocConsumer<AuthProviderBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {},
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  authBloc.add(LogoutEvent());
                  Navigator.pushNamed(context, RoutesName.login);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              );
            },
          ),

          IconButton(
            onPressed:() {
              Navigator.pushNamed(context, RoutesName.changepassword);
            }, 
            icon:const Icon(Icons.lock_reset, color: Colors.white))
        ],
      ),
      body: BlocConsumer<FileUploadBloc, FileUploadState>(
        listener: (context, state) {
          debugPrint("sjdiojdiwojdopewdjwed ${state.runtimeType}");
          if (state is FileUploaded) {
            fetchHandling();
          }
        },
        builder: (context, state) {
          if (state is FetchDataState) {
            return StreamBuilder<List<DocumentModel>>(
              stream: state.getData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _buildDocumentList(snapshot.data!);
                }
              },
            );
          } else if (state is FileUploading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileUploadInitial) {
            return const Center(
              child: Text("Loading.."),
            );
          }
          return const Text("No Data");
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 10.0,
            left: 30.0,
            child: FloatingActionButton(
              heroTag: 'uploadButton',
              onPressed: () async {
                result =
                    await FilePicker.platform.pickFiles(allowMultiple: false);

                if (result == null) {
                  debugPrint("No file selected");
                } else {
                  // ignore: use_build_context_synchronously
                  showConfirmationDialog(
                      context, File(result!.files.single.path!), result!);
                }
              },
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            child: FloatingActionButton(
              heroTag: 'shareButton',
              onPressed: () async {
                result2 =
                    await FilePicker.platform.pickFiles(allowMultiple: false);
                if (result2 == null) {
                  debugPrint("No file selected");
                } else {
                  // ignore: use_build_context_synchronously
                  showCustomDialog(context, File(result2!.files.single.path!));
                }
              },
              child: const Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(List<DocumentModel> data) {
    List<DocumentModel> reversedList = List.from(data.reversed);
    return ListView.builder(
      itemCount: reversedList.length,
      //reverse: true,
      itemBuilder: (context, index) {
        final document = reversedList[index];
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Share and view Icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (document.senderId == document.receiverId)
                      IconButton(
                        onPressed: () {
                          showCustomShareDialog(context, document.fileLink,
                              document.documentType);
                        },
                        icon: const Icon(Icons.share),
                      ),
                    IconButton(
                      onPressed: () {
                        if (document.documentType == "pdf") {
                          Navigator.pushNamed(context, RoutesName.docView,
                              arguments: {'filelink': document.fileLink});
                        }
                        if (document.documentType == "image") {
                          Navigator.pushNamed(context, RoutesName.imgView,
                              arguments: {'filelink': document.fileLink});
                        }
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),

                    IconButton(
                      onPressed: () {
                        FileUploadBloc().add(DeleteDataEvent(document.docId)); 
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),

              //document view
              if (document.documentType == "image")
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/arow_loading.jpeg",
                    image: document.fileLink,
                    fit: BoxFit.cover,
                  ),
                ),
              if (document.documentType == "pdf")
                const SizedBox(
                  height: 200,
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 200,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),

              // Upload and share floating action button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Sender: ${document.senderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text('Receiver: ${document.receiverId}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
