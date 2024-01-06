import 'dart:developer';

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
  final formKey = GlobalKey<FormState>();
  late UserModel user;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getUserData().then((value) {
  //     firstNameController.text = value.firstName;
  //     lastNameController.text = value.lastName;
  //     emailController.text = value.email;
  //     //File cv=value.cv;

  //   });
  // }

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
      log('jobIds: $jobIds');
      for (String jobId in jobIds) {
        log('jobId: $jobId');
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

  updateUser(uid) async {
    final uid = authController.currentUser!.uid;
    return userRepo.updateUserById(uid);
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
