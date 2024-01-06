import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  // File? cv; // File CV

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    // this.cv,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      // 'cv': cv?.path, // Store the file path in Firestore
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserModel(
      id: document.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      // cv:data['cv'],
      profilePicture: data['profilePicture'],
    );
  }
}
