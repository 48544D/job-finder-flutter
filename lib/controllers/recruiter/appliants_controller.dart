import 'package:get/get.dart';
import 'package:job_finder/models/job_applications.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/repo/job_applications_repository.dart';
import 'package:job_finder/repo/job_repository.dart';
import 'package:job_finder/repo/user_repository.dart';

class AppliantsController extends GetxController {
  static AppliantsController get instance => Get.find();
  final jobApplicationsRepo = Get.put(JobApplicationsRepository());
  final userRepo = Get.put(UserRepository());
  final jobRepo = Get.put(JobRepository());

  Stream<List<UserModel>> getAppliants(String jobId) async* {
    try {
      Stream<JobApplicationModel> jobApplication =
          jobApplicationsRepo.getJobApplicationByJobId(jobId);

      await for (JobApplicationModel jobApplication in jobApplication) {
        List<String> appliantsIds = jobApplication.applicantsId;

        List<UserModel> users = [];
        for (String userId in appliantsIds) {
          UserModel user = await userRepo.getUserById(userId).first;
          users.add(user);
        }

        yield users;
      }
    } catch (e) {
      print('Error getting appliants: $e');
      rethrow;
    }
  }

  Stream<JobModel> getJob(String jobId) {
    try {
      final job = jobRepo.getJobById(jobId);
      return job;
    } catch (e) {
      print('Error getting job: $e');
      rethrow;
    }
  }

  confirmAppliant(String jobId, String id) async {
    try {
      await jobApplicationsRepo.confirmAppliant(jobId, id);
    } catch (e) {
      print('Error confirming appliant: $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> getAcceptedAppliants(String jobId) async* {
    try {
      Stream<JobApplicationModel> jobApplication =
          jobApplicationsRepo.getJobApplicationByJobId(jobId);

      await for (JobApplicationModel jobApplication in jobApplication) {
        List<String> acceptedIds = jobApplication.acceptedApplicantsIds;

        List<UserModel> users = [];
        for (String userId in acceptedIds) {
          UserModel user = await userRepo.getUserById(userId).first;
          users.add(user);
        }

        yield users;
      }
    } catch (e) {
      print('Error getting appliants: $e');
      rethrow;
    }
  }

  unconfirmAppliant(String jobId, String id) async {
    try {
      await jobApplicationsRepo.unconfirmAppliant(jobId, id);
    } catch (e) {
      print('Error unconfirming appliant: $e');
      rethrow;
    }
  }
}
