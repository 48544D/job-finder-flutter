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

  getAppliants(String jobId) async {
    try {
      JobApplicationModel? jobApplication =
          await jobApplicationsRepo.getJobApplicationByJobId(jobId);

      List appliantsId = jobApplication?.applicantsId ?? [];
      if (appliantsId.isEmpty) {
        return [];
      }

      List<UserModel> appliants = [];
      for (var i = 0; i < appliantsId.length; i++) {
        final appliant = await userRepo.getUserById(appliantsId[i]);
        appliants.add(appliant);
      }

      return appliants;
    } catch (e) {
      print('Error getting appliants: $e');
      rethrow;
    }
  }

  Future<JobModel> getJob(String jobId) async {
    try {
      final job = await jobRepo.getJobById(jobId);
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

  getAcceptedAppliants(String jobId) async {
    try {
      JobApplicationModel? jobApplication =
          await jobApplicationsRepo.getJobApplicationByJobId(jobId);

      List acceptedApplicantsIds = jobApplication?.acceptedApplicantsIds ?? [];
      if (acceptedApplicantsIds.isEmpty) {
        return [];
      }

      List<UserModel> acceptedAppliants = [];
      for (var i = 0; i < acceptedApplicantsIds.length; i++) {
        final acceptedAppliant =
            await userRepo.getUserById(acceptedApplicantsIds[i]);
        acceptedAppliants.add(acceptedAppliant);
      }

      return acceptedAppliants;
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
