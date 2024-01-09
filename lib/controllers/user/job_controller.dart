import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/job_applications.dart';
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

      // form validation
      if (!formKey.currentState!.validate()) {
        return;
      }

      // save job application data to firestore
      final uid = authController.currentUser!.uid;
      final jobApplication = JobApplicationModel(
        id: '',
        applicantsId: [uid],
        jobId: jobId, acceptedApplicantsIds: [],  
      );  
      await jobApplicationsRepo.applyToJob(jobApplication);

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
    }
  }


}