import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_upload/application/homeBloc/home_event.dart';
import 'package:doc_upload/application/homeBloc/home_state.dart';
import 'package:doc_upload/infrastructure/repo_impl/home_repo_impl.dart';
import 'package:doc_upload/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final homeRepo = HomeRepoAPI();
  String? imgUrl;

  FileUploadBloc() : super(FileUploadInitial()) {

  on<FetchDataEvent>((event, emit){
   try{
     emit(FileUploading());
    emit(FetchDataState(homeRepo.getAllData()));
   }catch(error){
    
    AppUtils.showErrorMessage("Unable to fetch Data try again");
   }
  });

    on<SelectFileEvent>((event, emit)async{
     try{
        emit(FileUploading());
        debugPrint("**************${state.runtimeType}");
          final currentUser = auth.currentUser;
          if (currentUser != null){
           await homeRepo.uploadDocFile(event.selectedFile);
            emit(FileUploaded());
            debugPrint("**************${state.runtimeType}");
     }}catch(error){
      AppUtils.showErrorMessage("Error while Uploading Document");
     }
    });
    

    // on<SelectedShareImageEvent>((event, emit)async{
    //   emit(SharingFileSelected(event.selectedFile));
      
    // });
    on<SaveShareFileEvent>((event, emit) async{
     try{
    if (auth.currentUser != null){
        emit(FileUploading());
         debugPrint("#############${state.runtimeType}");
         imgUrl =  await homeRepo.uploadSharingDocFile(event.selectedFile);
          await  homeRepo.uploadSharedDocData(imgUrl: imgUrl, receiverMail: event.receiverMail, msg: event.message);
          emit(FileUploaded());
           debugPrint("#############${state.runtimeType}");
      }
    }
    catch(error){
     AppUtils.showErrorMessage("Error while Uploading File");
    }
    });

    on<UploadSharingImageEvent>((event, emit)async{
    try{
     if (auth.currentUser != null){
        emit(FileUploading());
         debugPrint("@@@@@@@@@@@@${state.runtimeType}");
          await  homeRepo.uploadSharedDocData(imgUrl: event.fileLink, receiverMail: event.receiverMail, msg: event.message);
          AppUtils.showSuccessMessage("Docment shared to ${event.receiverMail} sucessfully");
          emit(FileUploaded());
           debugPrint("@@@@@@@@@@@@${state.runtimeType}");
      }
    }catch(error){
      debugPrint(error.toString());
     AppUtils.showErrorMessage("Error while sharing document, Try again");
    }
    });

    on<DeleteDataEvent>((event, emit)async{
     try{
      await homeRepo.deleteData(event.docsId);
      AppUtils.showSuccessMessage("Docment deleted successfully");
     }catch(error){
      debugPrint(error.toString());
     AppUtils.showErrorMessage("Error while deleting document, Try again");
     }
    });
  }
}













  // on<FileUploadEvent>((event, emit) async {
    //   try {
    //     if (event is SelectFileEvent) {
    //       emit(FileSelected(event.selectedFile));
    //     } 
    //     else if (event is UploadFileEvent){
    //       emit(FileUploading());
    //       final currentUser = auth.currentUser;
    //       if (currentUser != null){
    //        await homeRepo.uploadDocFile(event.file);
    //         emit(FileUploaded());
    //       }
    //     }
    //   } catch (e) {
    //     emit(FileUploadFailure());
    //   }
    // });
