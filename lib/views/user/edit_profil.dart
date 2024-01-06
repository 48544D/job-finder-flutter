import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/user/profile_controller.dart';
import 'package:job_finder/utils/scroll_view_height.dart';
import 'package:file_picker/file_picker.dart';
import 'package:job_finder/views/user/profile.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({Key? key}) : super(key: key);

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final profileController = Get.put(UserProfileController());
    final uid = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your profile',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ScrollViewWithHeight(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: profileController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 16.0),
                Text(
                  'Edit your profile information',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: profileController.firstNameController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: profileController.lastNameController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: profileController.emailController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 10,
                      ),
                      side: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                    ),
                    // onPressed: () {
                    //   // Save changes
                    //   profileController.updateProfile();
                    //   Get.back();
                    // },
                    onPressed: () async {
                              var result = await FilePicker.platform.pickFiles(type: FileType.custom);
                              if (result != null) {
                                File cv = File(result.files.single.path!);
                                profileController.updateUser(uid);
                              }

                      Get.back();
                    },
                    child: const Text('Save',
                        style:
                            TextStyle(fontSize: 20, color: Colors.deepPurple)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
