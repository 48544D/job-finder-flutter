import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/auth/register_controller.dart';
import 'package:job_finder/utils/background.dart';

import 'package:job_finder/utils/scroll_view_height.dart';

class EmployeeRegisterPage extends StatefulWidget {
  
  const EmployeeRegisterPage({super.key});
  

  @override
  State<EmployeeRegisterPage> createState() => _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends State<EmployeeRegisterPage> {
  final controller = Get.put(RegisterController());

  late double innerHeight = MediaQuery.of(context).size.height;
  late ColorScheme _colorScheme;

  @override
  Widget build(BuildContext context) {
    _colorScheme = Theme.of(context).colorScheme;
    return Background(child: _body());
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          color: _colorScheme.onSecondary.withOpacity(0.6),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: ScrollViewWithHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image(
              image: const AssetImage('assets/images/logo.png'),
              height: innerHeight * 0.25,
            ),
            _mainSection(),
          ],
        ),
      ),
    );
  }

  Widget _mainSection() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _formSection(),
      ),
    );
  }

  Widget _formSection() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Register',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Create an account to continue',
            style: TextStyle(
              color: _colorScheme.onSurface.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstNameController,
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
                    prefixIcon: Icon(
                      Icons.person_2_sharp,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: controller.lastNameController,
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
                    prefixIcon: Icon(
                      Icons.person_2_sharp,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required';
              } else if (!value.isEmail) {
                return 'Invalid email';
              }
              return null;
            },
            // expands: false,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
              controller: controller.passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                } else if (value.length > 15) {
                  return 'Password must be at most 15 characters';
                }
                return null;
              },
              obscureText: controller.isPassword,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.password_sharp,
                    color: Colors.grey.shade800,
                  ),
                  suffixIcon: IconButton(
                    color: Colors.grey.shade800,
                    onPressed: () {
                      setState(() {
                        controller.isPassword = !controller.isPassword;
                      });
                    },
                    icon: Icon(controller.isPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ))),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.registerUser(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: const StadiumBorder(),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
