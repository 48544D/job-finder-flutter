import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/repo/job_applications_repository.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/repo/user_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class UserProfileController extends GetxController {
  static UserProfileController get instance => Get.find();
  final authController = Get.put(Authentication());
  final userRepo = Get.put(UserRepository());
  final jobApplicationsRepo = Get.put(JobApplicationsRepository());
  final jobsRepo = Get.put(JobRepository());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPassword = false;
  final formKey = GlobalKey<FormState>();
  late UserModel user;

  Stream<UserModel> getUserData() {
    final uid = authController.currentUser!.uid;
    return userRepo.getUserById(uid);
  }

  Stream<List<JobModel>> getUserJobs() async* {
    final uid = authController.currentUser!.uid;
    Stream<List<String>> userJobIds =
        jobApplicationsRepo.getJobsIdsByUserId(uid);

    await for (List<String> jobIds in userJobIds) {
      List<JobModel> jobs = [];
      for (String jobId in jobIds) {
        JobModel job = await jobsRepo.getJobById(jobId).first;
        jobs.add(job);
      }
      yield jobs;
    }
  }

  void logout() {
    Authentication().signOut();
    const HomePage();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void updateProfile() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Create a credential with the user's email and password
      await authController.updateEmail(
          email: emailController.text, password: passwordController.text);

      userRepo.updateUser(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );

      // clear text editing controllers
      clearFields();

      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/user/profile');
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

//   // Create a credential with the user's email and password
//   final credential = EmailAuthProvider.credential(
//     email: emailController.text,
//     password: passwordController.text,
//   );

//   // Reauthenticate
//   await authController.currentUser!.reauthenticateWithCredential(credential);

//   // Update the password
//   await authController.currentUser!.updatePassword(newPassword);
