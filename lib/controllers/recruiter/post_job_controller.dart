import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class PostJobController extends GetxController {
  static PostJobController get instance => Get.find();
  final authController = Get.put(Authentication());
  final jobsRepo = Get.put(JobRepository());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  void logout() {
    Authentication().signOut();
    Get.toNamed('/login');
  }
}
