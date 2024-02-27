import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  late File? selectedCV;

  Stream<UserModel> getUserData() {
    final uid = authController.currentUser!.uid;
    return userRepo.getUserById(uid);
  }
  // Stream getUserCv(){
  //   final uid = authController.currentUser!.uid;
  //   return userRepo.getUserCv(uid);
  // }
  
  String url ="";
  pickCV() async{
    try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
    File pick = File(result!.files.single.path.toString());
    String fileName = result.files[0].name;
    final uid = authController.currentUser!.uid;
    var file = pick.readAsBytesSync();
    // Check if the user already has a CV
      var userCvSnapshot = await FirebaseFirestore.instance
          .collection("CVs")
          .where("id", isEqualTo: uid)
          .get();

      if (userCvSnapshot.docs.isNotEmpty) {
        // If the user has a CV, delete the old CV
        await FirebaseStorage.instance
            .refFromURL(userCvSnapshot.docs.first['url'])
            .delete();
        await userCvSnapshot.docs.first.reference.delete();
      }
      // Upload the new CV
    var pdfFile = FirebaseStorage.instance.ref().child("CVs/$fileName");
    UploadTask task = pdfFile.putData(file);
    TaskSnapshot snapshot = await task.whenComplete(() {});
    url = await snapshot.ref.getDownloadURL();
    if (url != null) {
    await FirebaseFirestore.instance
    .collection("CVs")
    .doc()
    .set({
          "id": uid,
          "name": fileName,
          "url": url,
        });
        Get.snackbar('Success', 'CV upload successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Error', 'CV upload failed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    }
  } catch (e) {
    // Handle any errors during file picking
    print("Error picking file: $e");
    Get.snackbar('Error', 'File picking failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }
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
