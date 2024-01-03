import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/recruiter/job_controller.dart';
import 'package:job_finder/utils/scroll_view_height.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({super.key});

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final jobController = Get.put(JobController());
  final jobId = Get.arguments;

  @override
  void initState() {
    super.initState();
    jobController.getJobById(jobId).then((job) {
      log('job: $job');
      jobController.titleController.text = job.title;
      jobController.descriptionController.text = job.description;
      jobController.locationController.text = job.location;
      jobController.salaryController.text = job.salary.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Job',
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
      body: ScrollViewWithHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: jobController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Job',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 16.0),
                Text(
                  'Edit this job information',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.title,
                      color: Colors.deepPurple,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  controller: jobController.titleController,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'Salary',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Colors.deepPurple,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a salary';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid salary';
                    }
                    return null;
                  },
                  controller: jobController.salaryController,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.deepPurple,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  controller: jobController.locationController,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade800,
                        width: 2,
                      ),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Colors.deepPurple,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: jobController.descriptionController,
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
                      jobController.updateJob(jobId);
                      Get.back();
                    },
                    child: const Text('Save',
                        style:
                            TextStyle(fontSize: 20, color: Colors.deepPurple)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
