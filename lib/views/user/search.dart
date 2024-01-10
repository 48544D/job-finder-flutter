import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/user/job_controller.dart';
import 'package:job_finder/models/jobs.dart';

class SearchPage extends SearchDelegate<String> {
  final UserJobController userjobController = Get.find();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context));
  }

  @override
  Widget buildResults(BuildContext context) {
    final Stream<List<JobModel>> jobsStream = userjobController.getAllJobs();

    return StreamBuilder<List<JobModel>>(
      stream: jobsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final List<JobModel> jobs = snapshot.data ?? [];

          if (query.isNotEmpty &&
              jobs.any((job) => job.title.toLowerCase().contains(query.toLowerCase()))) {
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final JobModel job = jobs[index];
                if (job.title.toLowerCase().contains(query.toLowerCase())) {
                  return ListTile(
                    title: Text(job.title),
                    onTap: () {
                      // Handle the tap on the result
                      Get.toNamed('/user/job_details', arguments: {
                      'jobId': job.id,
                      'showApplyButton': true,
                    });
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          } else {
            return Center(
              child: Text("No results found"),
            );
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    final Stream<List<JobModel>> jobsStream = userjobController.getAllJobs();

    return StreamBuilder<List<JobModel>>(
      stream: jobsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final List<JobModel> jobs = snapshot.data ?? [];

          if (query.isNotEmpty &&
              jobs.any((job) => job.title.toLowerCase().contains(query.toLowerCase()))) {
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final JobModel job = jobs[index];
                if (job.title.toLowerCase().contains(query.toLowerCase())) {
                  return ListTile(
                    title: Text(job.title),
                    onTap: () {
                      // Handle the tap on the result
                      Get.toNamed('/user/job_details', arguments: {
                      'jobId': job.id,
                      'showApplyButton': true,
                    });
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          } else {
            return Center(
              child: Text("No results found"),
            );
          }
        }
      },
    );
    
  }
}
