import 'package:get/get.dart';
import 'package:job_finder/models/job_applications.dart';
import 'package:job_finder/repo/job_applications_repository.dart';
// import 'package:job_finder/utils/authentication.dart';

class JobListController extends GetxController {
  static JobListController get instance => Get.find();
  final jobApplicationsRepo = JobApplicationsRepository();
  RxList<JobApplicationModel> jobs = <JobApplicationModel>[].obs;

  // fetchAppliedJobs() {
  //   final uid = Get.find<Authentication>().currentUser!.uid;
  //   jobs.value = jobApplicationsRepo.getJobApplicationsByUserId(uid);
  // }
}
