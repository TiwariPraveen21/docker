import 'dart:io';

abstract class FileUploadEvent {}

class SelectFileEvent extends FileUploadEvent {
  final File selectedFile;

  SelectFileEvent(this.selectedFile);
}
//For sharing uploaded document
class UploadSharingImageEvent extends FileUploadEvent{
  final String receiverMail;
   final String message;
   final String fileLink;

  UploadSharingImageEvent(this.receiverMail, this.message, this.fileLink);
}

// for sharing document from your device
class SaveShareFileEvent extends  FileUploadEvent{
  final String receiverMail;
  final String message;
  final File selectedFile;

  SaveShareFileEvent(this.receiverMail, this.message, this.selectedFile);
 
}

class FetchDataEvent extends FileUploadEvent{}

class DeleteDataEvent extends FileUploadEvent{
  final String docsId;
  DeleteDataEvent(this.docsId);
}