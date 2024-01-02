import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String id;
  String recruiterId;
  String title;
  String description;
  String location;
  double salary;
  DateTime date;

  JobModel({
    required this.id,
    required this.recruiterId,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'recruiterId': recruiterId,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'date': date,
    };
  }

  factory JobModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return JobModel(
      id: document.id,
      recruiterId: data['recruiterId'],
      title: data['title'],
      description: data['description'],
      location: data['location'],
      salary: data['salary'].toDouble(),
      date: data['date'].toDate(),
    );
  }
}
