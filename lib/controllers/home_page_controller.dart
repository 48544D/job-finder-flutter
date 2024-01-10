import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:job_finder/repo/recruiter_repository.dart';
import 'package:job_finder/repo/user_repository.dart';
import 'package:job_finder/utils/authentication.dart';
import 'package:job_finder/views/auth/login.dart';
import 'package:job_finder/views/recruiter/profile.dart';
import 'package:job_finder/views/user/home_page_user.dart';
// import 'package:job_finder/views/user/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(Authentication());

    return FutureBuilder(
      future: isInternetConnected(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // there is no internet connection
          if (snapshot.data == false) {
            return const noInternetConnection();
          } else {
            // there is internet connection
            return StreamBuilder<User?>(
              stream: authController.authStateChanges,
              builder: (context, snapshot) {
                // loading the user
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  // user is not logged in
                  if (user == null) {
                    return const LoginPage();
                  } else {
                    return accountType();
                  }
                } else {
                  return const loadingAnimation();
                }
              },
            );
          }
        } else {
          return const loadingAnimation();
        }
      },
    );
  }

  // check if user is a recruiter or employee
  FutureBuilder<bool> accountType() {
    return FutureBuilder<bool>(
      future: isRecruiter(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // user is a recruiter
          if (snapshot.data == true) {
            return const RecruiterProfilePage();
          } else {
            // user is an employee
            return FutureBuilder<bool>(
              future: isEmployee(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return const HomePageUser();
                  } else {
                    return const LoginPage();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          }
        } else {
          return const loadingAnimation();
        }
      },
    );
  }

  // check if user is a recruiter
  Future<bool> isRecruiter() async {
    final recruiterRepo = Get.put(RecruiterRepository());
    final recruiter =
        await recruiterRepo.recruiterExists(Authentication().currentUser!.uid);
    return recruiter;
  }

  // check if user is an employee
  Future<bool> isEmployee() async {
    final userRepo = Get.put(UserRepository());
    final employee =
        await userRepo.userExists(Authentication().currentUser!.uid);
    return employee;
  }

  // check internet connection
  isInternetConnected() async {
    final result = await Connectivity().checkConnectivity();
    return !(result == ConnectivityResult.none);
  }
}

// loading animation
class loadingAnimation extends StatelessWidget {
  const loadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

// no internet connection
class noInternetConnection extends StatelessWidget {
  const noInternetConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No internet connection'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.offAll(const HomePage());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
