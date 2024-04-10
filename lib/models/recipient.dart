import 'package:cloud_firestore/cloud_firestore.dart';

class RecipientModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String sortCode;
  final String accountNumber;
  final String accountId;
  final String? email;

  RecipientModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.sortCode,
    required this.accountNumber,
    required this.accountId,
    this.email,
  });

  factory RecipientModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return RecipientModel(
      userId: data?['userId'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      sortCode: data?['sortCode'] ?? '',
      accountNumber: data?['accountNumber'] ?? '',
      accountId: data?['accountId'] ?? '',
      email: data?['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'sortCode': sortCode,
      'accountNumber': accountNumber,
      'accountId': accountId,
      'email': email,
    };
  }

  factory RecipientModel.fromMap(Map<String, dynamic> data) {
    return RecipientModel(
      userId: data['userId'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      sortCode: data['sortCode'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      accountId: data['accountId'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'sortCode': sortCode,
      'accountNumber': accountNumber,
      'accountId': accountId,
      'email': email,
    };
  }

  RecipientModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? sortCode,
    String? accountNumber,
    String? accountId,
    String? email,
  }) {
    return RecipientModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sortCode: sortCode ?? this.sortCode,
      accountNumber: accountNumber ?? this.accountNumber,
      accountId: accountId ?? this.accountId,
      email: email ?? this.email,
    );
  }

  // empty recipient
  static RecipientModel toEmpty() {
    return RecipientModel(
      userId: '',
      firstName: '',
      lastName: '',
      sortCode: '',
      accountNumber: '',
      accountId: '',
      email: '',
    );
  }
}
