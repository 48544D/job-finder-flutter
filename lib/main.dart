import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/firebase_options.dart';
import 'package:job_finder/utils/terms_and_conditions.dart';
import 'package:job_finder/views/Hello.dart';
import 'package:job_finder/views/TermsAndConditionsButton%20.dart';
import 'package:job_finder/views/auth/account_type.dart';
import 'package:job_finder/views/auth/login.dart';
import 'package:job_finder/views/auth/register_employee.dart';
import 'package:job_finder/views/auth/register_recruiter.dart';
import 'package:job_finder/views/recruiter/job.dart';
import 'package:job_finder/views/recruiter/edit_job.dart';
import 'package:job_finder/views/recruiter/edit_profile.dart';
import 'package:job_finder/views/recruiter/post_job.dart';
import 'package:job_finder/views/recruiter/profile.dart';
import 'package:job_finder/views/user/edit_profil.dart';
import 'package:job_finder/views/user/home_page_user.dart';
import 'package:job_finder/views/user/job_details.dart';
import 'package:job_finder/views/user/profile.dart';
import 'package:job_finder/views/user/search.dart';

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
        home: const Hello(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const AccountTypeRegister(),
          '/register/recruiter': (context) => const RecruiterRegisterPage(),
          '/register/employee': (context) => const EmployeeRegisterPage(),
          // recruiter
          '/recruiter/profile': (context) => const RecruiterProfilePage(),
          '/recruiter/edit-profile': (context) => const EditProfilePage(),
          '/recruiter/post-job': (context) => const PostJobForm(),
          '/recruiter/posts/appliants': (context) => const AppliantsPage(),
          '/recruiter/edit-job': (context) => const EditJobPage(),
          // user
          '/user/profile': (context) => const UserProfilePage(),
          '/user/edit-profile': (context) => const EditUserProfilePage(),
          '/user/job_details': (context) => const JobDetails(),
          '/user/home': (context) => const HomePageUser(),
          '/TermsAndConditionsButton':(context) => TermsAndConditionsButton(),   
          });
  }
}
