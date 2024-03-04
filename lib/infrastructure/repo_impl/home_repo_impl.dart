import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_upload/domain/models/documents_data_model.dart';
import 'package:doc_upload/global/app_helper.dart';
import 'package:doc_upload/utils/app_utils.dart';
import 'package:doc_upload/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseKey {
  static const String postKey = "documents";
  static const String userKey = "MyDocs";
}

class HomeRepoAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final myEmail = FirebaseAuth.instance.currentUser!.email;
  final storePostRef =
      FirebaseFirestore.instance.collection(FirebaseKey.postKey);
  final storeUserRef =
      FirebaseFirestore.instance.collection(FirebaseKey.userKey);

  Future<String?> uploadDocFile(File file) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String timeId = DateTime.now().microsecondsSinceEpoch.toString();
    debugPrint("Upload Image api called");
    Reference ref =
        FirebaseStorage.instance.ref().child("uploads").child(uid + timeId);
    return await uploadFileWithReference(ref, file);
  }

  // Upload image on given reference and image link will be return
  Future<String?> uploadFileWithReference(Reference ref, File file) async {
    await ref.putFile(File(file.path));
    String imUrl = "";
    await ref.getDownloadURL().then((value) async {
      debugPrint("Image url is $value");
      imUrl = value;
      docUrl = value;
      await uploadDocData(value);
    }).onError((error, stackTrace) {
      AppUtils.showErrorMessage("Error while uploading Documents");
    });

    debugPrint('Going to send notification');
    if (FirebaseUtils.fcmToken != "") {
      sendNotification();
    }
    debugPrint('send notification successflly');
    debugPrint("Post Image url is:$imUrl");

    return imUrl;
  }

  Future<bool?> uploadDocData(String imgUrl) async {
    bool? res;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String timeId = DateTime.now().microsecondsSinceEpoch.toString();
    await storeUserRef
        .doc("myuploades")
        .collection(_auth.currentUser!.email!)
        .doc(uid + timeId)
        .set(
          DocumentModel(
            senderId: _auth.currentUser!.email!,
            receiverId: _auth.currentUser!.email!,
            fileLink: imgUrl,
            message: "",
            documentType: docType,
            docId: uid+timeId
            )
           .toMap(),
        )
        .then((value) {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });

    return res;
  }

  // for uploading shared Image

  Future<String?> uploadSharingDocFile(File file) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String timeId = DateTime.now().microsecondsSinceEpoch.toString();
    debugPrint("Upload Image api called");
    Reference ref =
        FirebaseStorage.instance.ref().child("uploads").child(uid + timeId);
    return await uploadSharedFileWithReference(ref, file);
  }

  // Upload image on given reference and image link will be return
  Future<String?> uploadSharedFileWithReference(
      Reference ref, File file) async {
    await ref.putFile(File(file.path));
    String imUrl = "";
    await ref.getDownloadURL().then((value) {
      debugPrint("Image url is $value");
      imUrl = value;
    }).onError((error, stackTrace) {
      AppUtils.showErrorMessage("Error while uploading Documents");
    });
    debugPrint("Post Image url is:$imUrl");
    return imUrl;
  }

  Future<bool?> uploadSharedDocData(
      {required imgUrl, required receiverMail, required String msg}) async {
    bool? res;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String timeId = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      //First upload sharing data to  MySharedDo collection
      await storeUserRef
          .doc("MySharedDoc")
          .collection(_auth.currentUser!.email!)
          .doc(uid + timeId)
          .set(
            DocumentModel(
             senderId: _auth.currentUser!.email!,
             receiverId: receiverMail,
             fileLink: imgUrl,
             message: msg,
             documentType: docType,
             docId: uid+timeId
             )
             .toMap(),
          );

      // Save sharing data to receivers myuploades collection
      await storeUserRef
          .doc("myuploades")
          .collection(receiverMail)
          .doc(uid + timeId)
          .set(
            DocumentModel(
            senderId: _auth.currentUser!.email!,
            receiverId: receiverMail,
            fileLink: imgUrl,
            message: msg,
            documentType: docType,
            docId: uid+timeId
            )
            .toMap(),
          );
    } catch (error) {
      AppUtils.showErrorMessage("Error while uploading Data");
    }

    return res;
  }

// get all the data
  Stream<List<DocumentModel>> getAllData() {
    debugPrint("checking*************************** $docUrl");
    return storeUserRef
        .doc("myuploades")
        .collection(_auth.currentUser!.email!)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => DocumentModel.fromMap(doc.data()))
            .toList());
  }

  // Delete particular data
Future<bool?> deleteData(String docsID) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await storeUserRef
        .doc("myuploades")
        .collection(_auth.currentUser!.email!)
        .doc(docsID)
        .get();

    // Check if the document exists before deleting
    if (documentSnapshot.exists) {
      await documentSnapshot.reference.delete();
      return true;
    } else {
      debugPrint('Document does not exist');
      return false; 
    }
  } catch (e) {
    debugPrint('Error deleting data: $e');
    return false; 
  }
}

  Future<void> sendNotification() async {
    var data = {
      'to': FirebaseUtils.fcmToken.toString(),
      'priority': 'high',
      'notification': {'title': 'Praveen Tiwari', 'body': 'added new document'},
      'data': {
        'type': 'document',
        'docId': '42506',
        'docLink': docUrl,
        'doctype': docType
      }
    };
    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
              "Key=AAAAxK6HAfM:APA91bFo_xrmBs8kv5BH8uHmuA7UpTWVFzgFHS0RAPic8Svu_tauVRAA95aGyiAZDj7nHcl2FhdNXicI89xkqGIB3er8xGqEvHysz069OYs94Vs9SuiaZesPaBtxIzx1YN3apaUhYBZ_"
        },
        body: jsonEncode(data));
  }
}
