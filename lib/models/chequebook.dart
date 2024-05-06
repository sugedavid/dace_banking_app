import 'package:cloud_firestore/cloud_firestore.dart';

class ChequeBookModel {
  final String id;
  final String accountNumber;
  final String createdAt;
  final String title;
  final String address;
  final String postCode;
  final String userId;

  ChequeBookModel({
    required this.id,
    required this.accountNumber,
    required this.createdAt,
    required this.title,
    required this.address,
    required this.postCode,
    required this.userId,
  });

  factory ChequeBookModel.fromDocument(DocumentSnapshot document) {
    return ChequeBookModel(
      id: document['id'] ?? '',
      accountNumber: document['accountNumber'] ?? '',
      createdAt: document['createdAt'] ?? '',
      title: document['title'] ?? '',
      address: document['address'] ?? '0.00',
      postCode: document['postCode'] ?? '',
      userId: document['userId'] ?? '',
    );
  }

  factory ChequeBookModel.fromMap(Map<String, dynamic> data) {
    return ChequeBookModel(
      id: data['id'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      createdAt: data['createdAt'] ?? '',
      title: data['title'] ?? '',
      address: data['address'] ?? '0.00',
      postCode: data['postCode'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'createdAt': createdAt,
      'title': title,
      'address': address,
      'postCode': postCode,
      'userId': userId,
    };
  }

  // empty chque
  static ChequeBookModel toEmpty() {
    return ChequeBookModel(
      id: '',
      accountNumber: '',
      createdAt: '',
      title: '',
      address: '',
      postCode: '',
      userId: '',
    );
  }
}
