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
  final jobsApp = Get.put(JobApplicationsRepository());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late UserModel user;

  @override
  void onInit() {
    super.onInit();
    getUserData().then((value) {
      user = value;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
    });
  }

  getUserData() {
    final uid = authController.currentUser!.uid;
    return userRepo.getUserById(uid);
  }

    getRecruiterJobs() {
    final uid = authController.currentUser!.uid;
    return jobsApp.getAllJobApplications(uid);
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
      userRepo.updateUser(
        user.id,
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );
      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offNamed('/user/profile');
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }
}
