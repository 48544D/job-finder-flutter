import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/controllers/recruiter/job_controller.dart';
import 'package:job_finder/controllers/recruiter/profile_controller.dart';
import 'package:job_finder/models/recruiter.dart';
import 'package:job_finder/utils/background.dart';

import 'package:job_finder/utils/scroll_view_height.dart';

class RecruiterProfilePage extends StatefulWidget {
  const RecruiterProfilePage({super.key});

  @override
  State<RecruiterProfilePage> createState() => RecruiterProfilePageState();
}

class RecruiterProfilePageState extends State<RecruiterProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Background(child: _body(context));
  }

  Widget _body(context) {
    final profileController = Get.put(ProfileController());
    final jobController = Get.put(JobController());

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
              // height: innerHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _appbar(),
                  // const SizedBox(height: 20),
                  _topCard(profileController),
                  // const SizedBox(height: 10),
                  _bottomCard(profileController, jobController),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _appbar() {
    double height = MediaQuery.of(context).size.height;
    final controller = Get.put(ProfileController());

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
            controller.logout();
            const HomePage();
          },
        )
      ],
    );
  }

  Widget _topCard(controller) {
    double height = MediaQuery.of(context).size.height;

    Positioned recruiterInfo(double innerHeight, RecruiterModel recruiter) {
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
              ]),
          child: Column(children: [
            SizedBox(height: innerHeight * 0.2),
            Text(
              '${recruiter.firstName} ${recruiter.lastName}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              recruiter.company,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            // Edit profile button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/recruiter/edit-profile');
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
          ]),
        ),
      );
    }

    Positioned profilePicture(double innerHeight, RecruiterModel recruiter) {
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
              image: DecorationImage(
                image: NetworkImage(recruiter.profilePicture),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    Container topCardContent(
        double height,
        Positioned Function(double innerHeight, RecruiterModel recruiter)
            recruiterInfo,
        RecruiterModel recruiter,
        Positioned Function(double innerHeight, RecruiterModel recruiter)
            profilePicture) {
      return Container(
        height: height * 0.4,
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;

          return Stack(
            children: [
              recruiterInfo(innerHeight, recruiter),
              profilePicture(innerHeight, recruiter)
            ],
          );
        }),
      );
    }

    return StreamBuilder(
        stream: controller.getRecruiterData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const loadingAnimation();
          } else {
            if (snapshot.hasData) {
              RecruiterModel recruiter = snapshot.data as RecruiterModel;

              return topCardContent(
                  height, recruiterInfo, recruiter, profilePicture);
            } else {
              return const HomePage();
            }
          }
        }));
  }

  Widget _bottomCard(profileController, jobController) {
    double innerHeight = MediaQuery.of(context).size.height * 0.5;

    Row bottomCardHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your Posts',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              )),
          IconButton(
              onPressed: () {
                Get.toNamed('/recruiter/post-job');
              },
              icon: const Icon(Icons.add_circle_outline,
                  color: Colors.deepPurple)),
        ],
      );
    }

    GestureDetector jobCard(String jobId, String jobTitle, String jobLocation,
        double jobSalary, DateTime jobDate) {
      return GestureDetector(
        onTap: () {
          Get.toNamed('/recruiter/posts/appliants', arguments: jobId);
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
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Delete Job',
                          middleText:
                              'Are you sure you want to delete this job?',
                          textConfirm: 'Yes',
                          textCancel: 'No',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            jobController.deleteJob(jobId);
                            Get.close(1);
                          },
                          onCancel: () {
                            Get.close(1);
                          },
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red)),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posted on: ${jobDate.toString().substring(0, 10)}',
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

    // Container searchBar() {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 10,
    //     ),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(20),
    //       color: Colors.grey[200],
    //     ),
    //     child: Row(
    //       children: [
    //         const Expanded(
    //           child: TextField(
    //             decoration: InputDecoration(
    //               hintText: 'Search',
    //               border: InputBorder.none,
    //               fillColor: Colors.grey,
    //             ),
    //           ),
    //         ),
    //         IconButton(
    //           icon: const Icon(
    //             Icons.search,
    //             color: Colors.deepPurple,
    //           ),
    //           onPressed: () {},
    //         ),
    //       ],
    //     ),
    //   );
    // }

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
          // const SizedBox(height: 10),
          // searchBar(),
          const SizedBox(height: 10),
          // jobs list
          StreamBuilder(
              stream: profileController.getRecruiterJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const loadingAnimation();
                } else {
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
                          'No jobs posted yet',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
