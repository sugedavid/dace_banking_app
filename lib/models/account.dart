import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String accountId;
  final String accountNumber;
  final String createdAt;
  final String updatedAt;
  final String amount;
  final String accountType;
  final String sortCode;
  final String currency;
  final String firstName;
  final String lastName;
  final String? email;
  final String userId;

  AccountModel({
    required this.accountId,
    required this.accountNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.amount,
    required this.accountType,
    required this.sortCode,
    required this.currency,
    required this.firstName,
    required this.lastName,
    required this.userId,
    this.email,
  });

  factory AccountModel.fromDocument(DocumentSnapshot document) {
    return AccountModel(
      accountId: document['accountId'] ?? '',
      accountNumber: document['accountNumber'] ?? '',
      createdAt: document['createdAt'] ?? '',
      updatedAt: document['updatedAt'] ?? '',
      amount: document['amount'] ?? '0.00',
      accountType: document['accountType'] ?? '',
      sortCode: document['sortCode'] ?? '',
      currency: document['currency'] ?? '',
      firstName: document['firstName'] ?? '',
      lastName: document['lastName'] ?? '',
      email: document['email'] ?? '',
      userId: document['userId'] ?? '',
    );
  }

  factory AccountModel.fromMap(Map<String, dynamic> data) {
    return AccountModel(
      accountId: data['accountId'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      amount: data['amount'] ?? '0.00',
      accountType: data['accountType'] ?? '',
      sortCode: data['sortCode'] ?? '',
      currency: data['currency'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'accountNumber': accountNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'amount': amount,
      'accountType': accountType,
      'sortCode': sortCode,
      'currency': currency,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userId': userId,
    };
  }

  // empty account
  static AccountModel toEmpty() {
    return AccountModel(
      accountId: '',
      accountNumber: '',
      createdAt: '',
      updatedAt: '',
      amount: '0.00',
      accountType: '',
      sortCode: '',
      currency: '£',
      firstName: '',
      lastName: '',
      email: '',
      userId: '',
    );
  }
}
