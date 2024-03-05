import 'package:cloud_firestore/cloud_firestore.dart';

import 'account.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String accountType;
  final List<AccountModel> accounts;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.accountType,
    required this.accounts,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<AccountModel> accounts = [];
    if (data?['accounts'] != null) {
      accounts = List<AccountModel>.from(
        (data?['accounts'] as List).map(
          (accountData) => AccountModel.fromMap(accountData),
        ),
      );
    }

    return UserModel(
      userId: data?['userId'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      email: data?['email'] ?? '',
      accountType: data?['accountType'] ?? '',
      accounts: accounts,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'accountType': accountType,
      'accounts': accounts.map((account) => account.toMap()).toList(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? accountType,
    List<AccountModel>? accounts,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      accountType: accountType ?? this.accountType,
      accounts: accounts ?? this.accounts,
    );
  }
}
