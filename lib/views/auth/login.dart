import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/auth/login_controller.dart';
import 'package:job_finder/utils/background.dart';
import 'dart:ui';

import 'package:job_finder/utils/scroll_view_height.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ColorScheme _colorScheme;
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    _colorScheme = Theme.of(context).colorScheme;
    return Background(child: _body());
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScrollViewWithHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _topSection(),
            _bottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _topSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      child: const Image(image: AssetImage('assets/images/logo.png')),
    );
  }

  Widget _bottomSection() {
    return Card(
      color: Colors.white,
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
        children: [
          Text(
            'Login',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Please sign in to continue',
            style: TextStyle(
              color: _colorScheme.onSurface.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: controller.emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller.passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required';
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
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      controller.isPassword = !controller.isPassword;
                    });
                  },
                  icon: Icon(controller.isPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                )),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.login();
            },
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
              'Login',
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
                'Don\'t have an account?',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/register');
                },
                child: const Text(
                  'Sign Up',
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
