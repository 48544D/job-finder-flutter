import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/repo/job_applications_repository.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class UserJobController extends GetxController {
  static UserJobController get instance => Get.find();
  final authController = Get.put(Authentication());
  final jobApplicationsRepo = Get.put(JobApplicationsRepository());
  final jobsRepo = Get.put(JobRepository());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getJobById(String uid) {
    return jobsRepo.getJobById(uid);
  }

  Stream<List<JobModel>> getAllJobs() {
    return jobsRepo.getAllJobs();
  }

  Stream<bool> isUserAppliedToJob(String jobId) {
    final userId = authController.currentUser!.uid;
    if (jobApplicationsRepo.getJobApplicationByJobId(jobId) == null) {
      return Stream.value(false);
    }
    return jobApplicationsRepo.getJobApplicationByJobId(jobId).map((event) {
      log('event.applicantsId.contains(userId) ${event.applicantsId.contains(userId)}');
      return event.applicantsId.contains(userId) ||
          event.acceptedApplicantsIds.contains(userId);
    });
  }

  void applyToJob(String jobId) async {
    try {
      // check internet connection
      final result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        Get.snackbar('Error', 'No internet connection',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return;
      }

      // save job application data to firestore
      final userId = authController.currentUser!.uid;
      await jobApplicationsRepo.applyToJob(userId, jobId);

      // navigate to user home page
      Get.snackbar('Success', 'Job application submitted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/user/home');
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      throw e;
    }
  }
}
