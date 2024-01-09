import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/models/recruiter.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/repo/recruiter_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final authController = Get.put(Authentication());
  final recruiterRepo = Get.put(RecruiterRepository());
  final jobsRepo = Get.put(JobRepository());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassword = true;
  final formKey = GlobalKey<FormState>();
  late RecruiterModel recruiter;

  Stream<RecruiterModel> getRecruiterData() {
    final uid = authController.currentUser!.uid;
    return recruiterRepo.getRecruiter(uid);
  }

  Stream<List<JobModel>> getRecruiterJobs() {
    final uid = authController.currentUser!.uid;
    return jobsRepo.getJobsByRecruiter(uid);
  }

  void logout() {
    Authentication().signOut();
  }

  void updateProfile() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Create a credential with the user's email and password
      await authController.updateEmail(
          email: emailController.text, password: passwordController.text);

      recruiterRepo.updateRecruiter(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        companyController.text,
      );

      // clear text editing controllers
      clearFields();

      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/recruiter/profile');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
          Get.snackbar('Error', 'Invalid password',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);

          return;
        }
      }
      throw e;
    }
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    companyController.clear();
    passwordController.clear();
  }
}
