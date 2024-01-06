import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/repo/job_applications_repository.dart';
import 'package:job_finder/repo/user_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class UserProfileController extends GetxController {
  static UserProfileController get instance => Get.find();
  final authController = Get.put(Authentication());
  final userRepo = Get.put(UserRepository());
  final jobsAppRep = Get.put(JobApplicationsRepository());
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
fillControllers() async {
    user = await getUserData();
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
  }
  getUserData() async{
    final uid = authController.currentUser!.uid;
    return userRepo.getUserById(uid);
  }

   getUserJobs() {
    final uid = authController.currentUser!.uid;
    return jobsAppRep.getAllJobApplications(uid);
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
