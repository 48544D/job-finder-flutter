import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationModel {
  final String id;
  final List<String> applicantsId;
  final String jobId;

  JobApplicationModel({
    required this.id,
    required this.applicantsId,
    required this.jobId,
  });

  Map<String, dynamic> toJson() {
    return {
      'applicantsId': applicantsId,
      'jobId': jobId,
    };
  }

  factory JobApplicationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return JobApplicationModel(
      id: document.id,
      applicantsId: List<String>.from(data['applicantsId']),
      jobId: data['jobId'],
    );
  }
}
