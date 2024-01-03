import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/models/recruiter.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/repo/recruiter_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final authController = Get.put(Authentication());
  final recruiterRepo = Get.put(RecruiterRepository());
  final jobsRepo = Get.put(JobRepository());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late RecruiterModel recruiter;

  @override
  void onInit() {
    super.onInit();
    getRecruiterData().then((value) {
      recruiter = value;
      firstNameController.text = recruiter.firstName;
      lastNameController.text = recruiter.lastName;
      emailController.text = recruiter.email;
      companyController.text = recruiter.company;
    });
  }

  getRecruiterData() {
    final uid = authController.currentUser!.uid;
    return recruiterRepo.getRecruiter(uid);
  }

  getRecruiterJobs() {
    final uid = authController.currentUser!.uid;
    return jobsRepo.getJobsByRecruiter(uid);
  }

  void logout() {
    Authentication().signOut();
    const HomePage();
  }

  void updateProfile() {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      recruiterRepo.updateRecruiter(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        companyController.text,
      );
      Get.snackbar('Success', 'Profile updated successfully',
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
      Get.offNamed('/recruiter/profile');
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }
}
