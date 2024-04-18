import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserModel(
      userId: data?['userId'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      email: data?['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? accountType,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }

  // empty user
  static UserModel toEmpty() {
    return UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
    );
  }
}
