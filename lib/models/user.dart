import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String accountType;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.accountType,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      email: data?['email'] ?? '',
      accountType: data?['accountType'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'accountType': accountType,
    };
  }
}
