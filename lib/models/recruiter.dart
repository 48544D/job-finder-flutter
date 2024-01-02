import 'package:cloud_firestore/cloud_firestore.dart';

class RecruiterModel {
  String company;
  String id;
  String firstName;
  String lastName;
  String email;
  String profilePicture;

  RecruiterModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.company,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'company': company,
    };
  }

  factory RecruiterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return RecruiterModel(
      id: document.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      profilePicture: data['profilePicture'],
      company: data['company'],
    );
  }
}
