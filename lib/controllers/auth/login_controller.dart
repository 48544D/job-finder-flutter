import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/utils/authentication.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
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
      await Authentication().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // clear text editing controllers
      emailController.clear();
      passwordController.clear();

      // navigate to home page
      Get.off(const HomePage());
    } catch (e) {
      if (e is FirebaseAuthException) {
        Get.snackbar('Error', e.message!,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return;
      }

      print('Error logging in: $e');
      rethrow;
    }
  }
}
