import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class JobController extends GetxController {
  static JobController get instance => Get.find();
  final authController = Get.put(Authentication());
  final jobsRepo = Get.put(JobRepository());

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  JobController() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
    salaryController = TextEditingController();
  }

  getJobById(String uid) {
    return jobsRepo.getJobById(uid);
  }

  void postJob() async {
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

      // save job data to firestore
      final uid = authController.currentUser!.uid;
      final job = JobModel(
          id: '',
          recruiterId: uid,
          title: titleController.text,
          description: descriptionController.text,
          location: locationController.text,
          salary: double.parse(salaryController.text),
          date: DateTime.now());
      jobsRepo.createJob(job);

      // clear text editing controllers
      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      salaryController.clear();

      // navigate to login page
      Get.snackbar('Success', 'Job posted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/recruiter/profile');
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  void deleteJob(String jobId) {
    try {
      jobsRepo.deleteJob(jobId);
      Get.snackbar('Success', 'Job deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      throw e;
    }
  }

  void updateJob(String jobId) async {
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

      // validate form
      if (!formKey.currentState!.validate()) {
        return;
      }

      // update job
      jobsRepo.updateJob(
        jobId,
        titleController.text,
        descriptionController.text,
        locationController.text,
        double.parse(salaryController.text),
      );

      // clear text editing controllers
      clearFields();

      Get.snackbar('Success', 'Job updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/recruiter/posts/appliants', arguments: jobId);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();
    salaryController.clear();
  }
}
