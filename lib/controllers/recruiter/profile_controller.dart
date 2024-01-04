import 'package:firebase_auth/firebase_auth.dart';
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
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController companyController;
  late TextEditingController passwordController;
  bool isPassword = true;
  final formKey = GlobalKey<FormState>();
  late RecruiterModel recruiter;

  ProfileController() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    companyController = TextEditingController();
    passwordController = TextEditingController();
  }

  fillControllers() async {
    recruiter = await getRecruiterData();
    firstNameController.text = recruiter.firstName;
    lastNameController.text = recruiter.lastName;
    emailController.text = recruiter.email;
    companyController.text = recruiter.company;
  }

  getRecruiterData() async {
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
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      companyController.clear();
      passwordController.clear();

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
}
