import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_finder/models/job_applications.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class JobApplicationsRepository extends GetxController {
  static JobApplicationsRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> applyToJob(String userId, String jobId) async {
    try {
      final document = await _firestore
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .get();

      if (document.docs.isNotEmpty) {
        final data = document.docs.single.data();
        final applicantsId = data['applicantsId'];
        applicantsId.add(userId);
        await _firestore
            .collection('jobApplications')
            .doc(document.docs.single.id)
            .update({'applicantsId': applicantsId});
      } else {
        await _firestore.collection('jobApplications').add({
          'jobId': jobId,
          'applicantsId': [userId],
          'acceptedApplicantsIds': []
        });
      }
    } catch (e) {
      // Handle any errors
      print('Error creating Job: $e');
      rethrow;
    }
  }

  Stream<JobApplicationModel> getJobApplicationByJobId(String jobId) {
    try {
      final document = _firestore
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .snapshots();
      final data = document.map((e) => e.docs.map((e) {
            return JobApplicationModel.fromSnapshot(e);
          }).single);

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting Job: $e');
      rethrow;
    }
  }

  Stream<List<String>> getJobsIdsByUserId(String userId) async* {
    try {
      final CollectionReference jobApplicationsCollection =
          _firestore.collection('jobApplications');

      Stream<List<String>> acceptedApplicantsStream = jobApplicationsCollection
          .where('acceptedApplicantsIds', arrayContains: userId)
          .snapshots()
          .map((querySnapshot) =>
              querySnapshot.docs.map((doc) => doc['jobId'] as String).toList());

      Stream<List<String>> applicantsStream = jobApplicationsCollection
          .where('applicantsId', arrayContains: userId)
          .snapshots()
          .map((querySnapshot) =>
              querySnapshot.docs.map((doc) => doc['jobId'] as String).toList());

      // Combine both streams manually
      StreamController<List<String>> controller =
          StreamController<List<String>>();

      StreamSubscription<List<String>> acceptedApplicantsSubscription;
      StreamSubscription<List<String>> applicantsSubscription;

      acceptedApplicantsSubscription =
          acceptedApplicantsStream.listen((List<String> jobIds) {
        controller.add(jobIds);
      });

      applicantsSubscription = applicantsStream.listen((List<String> jobIds) {
        controller.add(jobIds);
      });

      // Cancel subscriptions when stream is closed
      controller.onCancel = () {
        acceptedApplicantsSubscription.cancel();
        applicantsSubscription.cancel();
      };

      await for (List<String> mergedJobIds in controller.stream) {
        yield mergedJobIds;
      }
    } catch (e) {
      // Handle any errors
      print('Error getting Jobs: $e');
      throw e;
    }
  }

  Future<List<JobApplicationModel>> getAllJobApplications() async {
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

  confirmAppliant(String jobId, String id) async {
    try {
      await _firestore
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .get()
          .then((value) {
        final document = value.docs.single;
        final data = document.data();
        final applicantsId = data['applicantsId'];
        final acceptedApplicantsIds = data['acceptedApplicantsIds'];
        applicantsId.remove(id);
        acceptedApplicantsIds.add(id);
        _firestore.collection('jobApplications').doc(document.id).update({
          'applicantsId': applicantsId,
          'acceptedApplicantsIds': acceptedApplicantsIds
        });
      });
    } catch (e) {
      print('Error confirming appliant: $e');
      rethrow;
    }
  }

  unconfirmAppliant(String jobId, String id) async {
    try {
      await _firestore
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .get()
          .then((value) {
        final document = value.docs.single;
        final data = document.data();
        final applicantsId = data['applicantsId'];
        final acceptedApplicantsIds = data['acceptedApplicantsIds'];
        acceptedApplicantsIds.remove(id);
        applicantsId.add(id);
        _firestore.collection('jobApplications').doc(document.id).update({
          'applicantsId': applicantsId,
          'acceptedApplicantsIds': acceptedApplicantsIds
        });
      });
    } catch (e) {
      print('Error confirming appliant: $e');
      rethrow;
    }
  }
}
