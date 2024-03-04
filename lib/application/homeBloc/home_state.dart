import 'dart:io';
import 'package:doc_upload/domain/models/documents_data_model.dart';

abstract class FileUploadState {}

//For uploading docs
class FileUploadInitial extends FileUploadState {
  // final Stream<List<DocumentModel>> getData;
  //
  // FileUploadInitial(this.getData);
}

class FileSelected extends FileUploadState {
  final File selectedFile;

  FileSelected(this.selectedFile);
}

class FileUploading extends FileUploadState {}

class FileUploaded extends FileUploadState {}

class FileUploadFailure extends FileUploadState {}

//For Sharing docs
// class SharingFileSelected extends FileUploadState{
//   final File selectedFile;

//   SharingFileSelected(this.selectedFile);
// }

class FetchDataState extends FileUploadState{
 final Stream<List<DocumentModel>> getData;
  FetchDataState(this.getData);
}