import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool emailVerified;
  final bool phoneEnrolled;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.emailVerified,
    required this.phoneEnrolled,
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
      phoneNumber: data?['phoneNumber'] ?? '',
      emailVerified: data?['emailVerified'] ?? false,
      phoneEnrolled: data?['phoneEnrolled'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'phoneEnrolled': phoneEnrolled,
    };
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? accountType,
    String? phoneNumber,
    bool? emailVerified,
    bool? phoneEnrolled,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneEnrolled: phoneEnrolled ?? this.phoneEnrolled,
    );
  }

  // empty user
  static UserModel toEmpty() {
    return UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      emailVerified: false,
      phoneEnrolled: false,
    );
  }
}
