class DocumentModel {
  final String senderId;
  final String receiverId;
  final String fileLink;
  final String message;
  final String documentType;
  final String docId;

  DocumentModel({
    required this.senderId,
    required this.receiverId,
    required this.fileLink,
    required this.message,
    required this.documentType, 
    required this.docId
  });

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      fileLink: map['file_link'] ?? '',
      message: map['message'] ?? '',
      documentType: map['document_type'],
      docId: map['doc_type'] 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'file_link': fileLink,
      'message': message,
      'document_type': documentType,
      'doc_type':docId
    };
  }
}
