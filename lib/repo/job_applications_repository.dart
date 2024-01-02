import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/job_applications.dart';

class JobApplicationsRepository extends GetxController {
  static JobApplicationsRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> applyToJob(JobApplicationModel jobApplication) async {
    try {
      await _firestore
          .collection('jobApplications')
          .add(jobApplication.toJson());
    } catch (e) {
      // Handle any errors
      print('Error creating Job: $e');
      rethrow;
    }
  }

  Future<JobApplicationModel?> getJobApplicationByJobId(String jobId) async {
    try {
      final document = await _firestore
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .get();

      if (document.docs.isEmpty) {
        return null;
      }

      final data = document.docs
          .map((e) => JobApplicationModel.fromSnapshot(e))
          .toList();

      return data[0];
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }

  Future<List<JobApplicationModel>> getAllJobApplications(String uid) async {
    try {
      final document = await _firestore.collection('jobApplications').get();
      final data = document.docs
          .map((e) => JobApplicationModel.fromSnapshot(e))
          .toList();

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }
}
