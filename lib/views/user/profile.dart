import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/controllers/recruiter/job_controller.dart';
import 'package:job_finder/controllers/recruiter/profile_controller.dart';
import 'package:job_finder/controllers/user/job_controller.dart';
import 'package:job_finder/controllers/user/profile_controller.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/utils/background.dart';
import 'package:job_finder/utils/scroll_view_height.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Background(child: _body(context));
  }

  Widget _body(context) {
    final userprofilecontroller = Get.put(UserProfileController());
    final userjobController = Get.put(UserJobController());
    final jobR=Get.put(JobController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScrollViewWithHeight(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
          ),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _appbar(),
                _topCard(userprofilecontroller),
                _bottomCard(userprofilecontroller,userjobController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    double height = MediaQuery.of(context).size.height;
    final userProfilecontroller = Get.put(UserProfileController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: const AssetImage('assets/images/logo.png'),
          height: height * 0.1,
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          color: Colors.white,
          onPressed: () {
            userProfilecontroller.logout();
          },
        )
      ],
    );
  }

  Widget _topCard(controller) {
    double height = MediaQuery.of(context).size.height;

    Positioned userInfo(double innerHeight, UserModel user) {
      return Positioned(
        bottom: 30,
        left: 0,
        right: 0,
        child: Container(
          height: innerHeight * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: innerHeight * 0.2),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Edit profile button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/user/edit-profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Positioned profilePicture(double innerHeight, UserModel user) {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: innerHeight * 0.4,
            width: innerHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              // Add a placeholder image or default avatar
              image: DecorationImage(
                image: NetworkImage(user.profilePicture),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    Container topCardContent(
      double height,
      Positioned Function(double innerHeight, UserModel user) userInfo,
      UserModel user,
      Positioned Function(double innerHeight, UserModel user) profilePicture,
    ) {
      return Container(
        height: height * 0.4,
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;

          return Stack(
            children: [
              userInfo(innerHeight, user),
              profilePicture(innerHeight, user),
            ],
          );
        }),
      );
    }

    return FutureBuilder(
      future: controller.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data as UserModel;
            return topCardContent(height, userInfo, user, profilePicture);
          } else {
              return const HomePage();
          }
        } else {
          return const loadingAnimation();
        }
      },
    );
  }
  

  Widget _bottomCard(userprofilecontroller,userjobController) {
    double innerHeight = MediaQuery.of(context).size.height * 0.5;

    Row bottomCardHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your applied',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              )),
          IconButton(
              onPressed: () {
                Get.toNamed('/user/job_list');
              },
              icon: const Icon(Icons.add_circle_outline,
                  color: Colors.deepPurple)),
        ],
      );
    }
     GestureDetector jobCard(String jobId, String jobTitle, String jobLocation,
        double jobSalary, DateTime jobDate) {
      return GestureDetector(
        onLongPress: () {},
        onTap: () {
          Get.toNamed('/user/job_Card', arguments: jobId);
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      jobTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applied on: ${jobDate.toString().substring(0, 10)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      jobLocation,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      jobSalary.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

   return Container(
      constraints: BoxConstraints(
        minHeight: innerHeight,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, -2),
            )
          ]),
      child: Column(
        children: [
          bottomCardHeader(),
          // jobs list
          FutureBuilder(
              future: userprofilecontroller.getUserJobs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List jobs = snapshot.data as List;
                  if (jobs.isNotEmpty) {
                    return Column(mainAxisSize: MainAxisSize.max, children: [
                      for (var job in jobs)
                        Column(
                          children: [
                            jobCard(job.id, job.title, job.location, job.salary,
                                job.date),
                            const SizedBox(height: 10),
                          ],
                        ),
                    ]);
                  } else {
                    return Container(
                      constraints: BoxConstraints(
                        minHeight: innerHeight * 0.4,
                      ),
                      child: const Center(
                        child: Text(
                          'No jobs applied yet',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const loadingAnimation();
                }
              }),
        ],
      ),
    );
  }
}