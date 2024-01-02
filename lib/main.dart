import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/firebase_options.dart';
import 'package:job_finder/views/auth/account_type.dart';
import 'package:job_finder/views/auth/login.dart';
import 'package:job_finder/views/auth/register_employee.dart';
import 'package:job_finder/views/auth/register_recruiter.dart';
import 'package:job_finder/views/recruiter/appliants_page.dart';
import 'package:job_finder/views/recruiter/edit_profile.dart';
import 'package:job_finder/views/recruiter/post_job.dart';
import 'package:job_finder/views/recruiter/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Job Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const AccountTypeRegister(),
          '/register/recruiter': (context) => const RecruiterRegisterPage(),
          '/register/employee': (context) => const EmployeeRegisterPage(),
          '/recruiter/profile': (context) => const RecruiterProfilePage(),
          '/recruiter/edit-profile': (context) => EditProfilePage(),
          '/recruiter/post-job': (context) => const PostJobForm(),
          '/recruiter/posts/appliants': (context) => const AppliantsPage(),
        });
  }
}
