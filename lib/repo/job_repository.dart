import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/jobs.dart';

class JobRepository extends GetxController {
  static JobRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createJob(JobModel job) async {
    try {
      await _firestore.collection('jobs').add(job.toJson());
    } catch (e) {
      // Handle any errors
      print('Error creating Job: $e');
      rethrow;
    }
  }

  JobExists(String uid) {
    try {
      return _firestore.collection('jobs').doc(uid).get().then((value) {
        return value.exists;
      });
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }

  Stream<JobModel> getJobById(String uid) {
    try {
      final document = _firestore.collection('jobs').doc(uid).snapshots();
      final data = document.map((e) => JobModel.fromSnapshot(e));

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }

  Stream<List<JobModel>> getJobsByRecruiter(String uid) {
    try {
      final document = _firestore
          .collection('jobs')
          .where('recruiterId', isEqualTo: uid)
          .snapshots();
      final data = document.map((e) => e.docs.map((e) {
            return JobModel.fromSnapshot(e);
          }).toList());

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }
  Stream<List<JobModel>> getAllJobs() {
    try {
      final document = _firestore
          .collection('jobs')
          .snapshots();
      final data = document.map((e) => e.docs.map((e) {
            return JobModel.fromSnapshot(e);
          }).toList());

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }

  // Future<List<JobModel>> getAllJobs() async {
  //   try {
  //     final document = await _firestore.collection('jobs').get();
  //     final data = document.docs.map((e) => JobModel.fromSnapshot(e)).toList();

  //     return data;
  // }

  void deleteJob(String jobId) {
    try {
      _firestore.collection('jobs').doc(jobId).delete();
    } catch (e) {
      // Handle any errors
      print('Error deleting Job: $e');
      throw e;
    }
  }

  void updateJob(String jobId, String jobTitle, String jobDescription,
      String jobLocation, double jobSalary) {
    try {
      _firestore.collection('jobs').doc(jobId).update({
        'title': jobTitle,
        'description': jobDescription,
        'location': jobLocation,
        'salary': jobSalary,
      });
    } catch (e) {
      // Handle any errors
      print('Error updating Job: $e');
      rethrow;
    }
  }
}
