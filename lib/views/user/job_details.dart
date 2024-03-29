import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/user/job_controller.dart';
import 'package:job_finder/models/jobs.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  final jobId = Get.arguments['jobId'];
  final showApplyButton = Get.arguments['showApplyButton'];
  final jobController = Get.put(UserJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
            stream: jobController.getJobById(jobId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final job = snapshot.data as JobModel;
                final isUserApplied = jobController.isUserAppliedToJob(jobId);

                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        job.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Posted at :${job.date.toString().substring(0, 10)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "${job.salary.toInt()} DH",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        job.location,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 20,
                            height: 1.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 15,
                          ),
                        ),
                        // horizontal line
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                              width: 100,
                              height: 1.0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            job.description,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // apply to job button
                    showApplyButton == false
                        ? const SizedBox()
                        : SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                isUserApplied.listen((event) {
                                  if (event == true) {
                                    Get.snackbar('Error',
                                        'You already applied to this job',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.TOP);
                                    return;
                                  } else {
                                    Get.toNamed('/user/home');
                                    jobController.applyToJob(jobId);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isUserApplied == false
                                    ? Colors.deepPurple
                                    : Colors.deepPurple.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Apply to job',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
