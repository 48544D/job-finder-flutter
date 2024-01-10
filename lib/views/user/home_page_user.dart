import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/controllers/user/job_controller.dart';
import 'package:job_finder/controllers/user/profile_controller.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/utils/background.dart';
import 'package:job_finder/utils/scroll_view_height.dart';
import 'package:job_finder/views/user/profile.dart';
import 'package:job_finder/views/user/search.dart';



class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  
  @override
  Widget build(BuildContext context) {
    return Background(child: _body(context));
  }

  Widget _body(context) {
    final jobController = Get.put(UserJobController());

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
                _SearchBar(),
                _jobList(jobController),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        context,
        ['Home', 'Profile'],
        [Icons.house, Icons.person],
        // ['Home', 'Profile', 'Search'],
        // [Icons.house, Icons.person, Icons.search],
        'Home',
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
            Navigator.popAndPushNamed(context, '/login');
          },
        )
      ],
      
    );
    
  }

  Widget _SearchBar(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchPage());
              },
              child: Icon(Icons.search),
            ),

    );
  }

  Widget _jobList(userjobController) {
    double innerHeight = MediaQuery.of(context).size.height * 0.5;

    SizedBox bottomCardHeader() {
      return const SizedBox(
        width: double.infinity,
        child: Text('JOBS',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w500,
            )),
      );
    }

    GestureDetector jobCard(JobModel job) {
      return GestureDetector(
        onTap: () {
          Get.toNamed('/user/job_details', arguments: {
            'jobId': job.id,
            'showApplyButton': true,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      job.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                job.location,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 15,
                ),
              ),
              Text(
                '${job.salary.toString()} DH',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Posted at: ${job.date.toString().substring(0, 10)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        bottomCardHeader(),
        const SizedBox(height: 15),
        // jobs list
        StreamBuilder(
            stream: userjobController.getAllJobs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const loadingAnimation();
              } else {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No jobs yet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                List jobs = snapshot.data as List;
                if (jobs.isNotEmpty) {
                  return Column(mainAxisSize: MainAxisSize.max, children: [
                    for (var job in jobs)
                      Column(
                        children: [
                          jobCard(job),
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
                        'No jobs yet',
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
    );
  }
}

Widget CustomBottomNavigationBar(BuildContext context, List<String> items,
    List<IconData> icons, String selectedItem) {
  double displayWidth = MediaQuery.of(context).size.width;

  return Container(
      height: displayWidth * 0.16,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: InkWell(
                    onTap: () {
                      if (items[index] == selectedItem) return;

                      if (items[index] == 'Home') {
                        Get.off('/user/home');
                      } else if (items[index] == 'Profile') {
                        Get.offNamed('/user/profile');
                      }
                      HapticFeedback.lightImpact();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: items[index] == selectedItem
                              ? displayWidth * 0.32
                              : displayWidth * 0.18,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height: items[index] == selectedItem
                                ? displayWidth * .13
                                : 0,
                            width: items[index] == selectedItem
                                ? displayWidth * .32
                                : 0,
                            decoration: BoxDecoration(
                                color: items[index] == selectedItem
                                    ? Colors.deepPurple.withOpacity(.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: items[index] == selectedItem
                              ? displayWidth * .31
                              : displayWidth * .18,
                          alignment: Alignment.center,
                          child: Stack(children: [
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  width: items[index] == selectedItem
                                      ? displayWidth * .13
                                      : 0,
                                ),
                                AnimatedOpacity(
                                  opacity: items[index] == selectedItem ? 1 : 0,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Text(
                                    items[index] == selectedItem
                                        ? items[index]
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  width: items[index] == selectedItem
                                      ? displayWidth * .03
                                      : 20,
                                ),
                                Icon(
                                  icons[index],
                                  size: displayWidth * .08,
                                  color: items[index] == selectedItem
                                      ? Colors.deepPurple
                                      : Colors.black26,
                                )
                              ],
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                )),
      ));
}
