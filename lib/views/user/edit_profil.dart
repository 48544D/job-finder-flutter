import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/user/profile_controller.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/utils/scroll_view_height.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final profileController = Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
  }

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
            Get.back();
            profileController.clearFields();
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ScrollViewWithHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: editForm(),
        ),
      ),
    );
  }

  StreamBuilder editForm() {
    return StreamBuilder(
        stream: profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            profileController.user = snapshot.data as UserModel;
            profileController.firstNameController.text =
                profileController.user.firstName;
            profileController.lastNameController.text =
                profileController.user.lastName;
            profileController.emailController.text =
                profileController.user.email;

            return Form(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: profileController.firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(
                              Icons.person_2_sharp,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: profileController.lastNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(
                              Icons.person_2_sharp,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: profileController.emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
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
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: profileController.passwordController,
                    obscureText: profileController.isPassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        labelText: 'Confirm your password',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.deepPurple,
                        ),
                        suffixIcon: IconButton(
                          color: Colors.grey.shade800,
                          onPressed: () {
                            setState(() {
                              profileController.isPassword =
                                  !profileController.isPassword;
                            });
                          },
                          icon: Icon(profileController.isPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                  child: Icon(Icons.upload_file),
                  onPressed: profileController.pickCV,
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
                      onPressed: () {
                        // Save changes
                        profileController.updateProfile();
                      },
                      child: const Text('Save',
                          style: TextStyle(
                              fontSize: 20, color: Colors.deepPurple)),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
