import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/recruiter.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/repo/recruiter_repository.dart';
import 'package:job_finder/repo/user_repository.dart';
import 'package:job_finder/utils/authentication.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  bool isPassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
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

      // firebase authentication
      await Authentication().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // save user data to firestore
      final user = UserModel(
        id: Authentication().currentUser!.uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        profilePicture:
            'https://ui-avatars.com/api/?name=${firstNameController.text}+${lastNameController.text}',
      );

      final userRepo = Get.put(UserRepository());
      await userRepo.createUser(user);

      // clear text editing controllers
      emailController.clear();
      passwordController.clear();
      firstNameController.clear();
      lastNameController.clear();

      // navigate to login page
      Get.snackbar('Success', 'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle any errors
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      }
    }
  }

  Future<void> registerRecruiter() async {
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

      // firebase authentication
      await Authentication().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // save user data to firestore
      final recruiter = RecruiterModel(
        id: Authentication().currentUser!.uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        profilePicture:
            'https://ui-avatars.com/api/?name=${firstNameController.text}+${lastNameController.text}',
        company: companyController.text,
      );

      final recruiterRepo = Get.put(RecruiterRepository());
      await recruiterRepo.createUser(recruiter);

      // clear text editing controllers
      emailController.clear();
      passwordController.clear();
      firstNameController.clear();
      lastNameController.clear();
      companyController.clear();

      // navigate to login page
      Get.snackbar('Success', 'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle any errors
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar('Error', 'The account already exists for that email.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      }
    }
  }
}
