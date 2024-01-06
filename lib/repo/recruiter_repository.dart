import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/recruiter.dart';
import 'package:job_finder/utils/authentication.dart';

class RecruiterRepository extends GetxController {
  static RecruiterRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRecruiter(RecruiterModel recruiter) async {
    try {
      await _firestore
          .collection('recruiters')
          .doc(recruiter.id.toString())
          .set(recruiter.toJson());
    } catch (e) {
      // Handle any errors
      print('Error creating user: $e');
      rethrow;
    }
  }

  recruiterExists(String uid) {
    try {
      return _firestore.collection('recruiters').doc(uid).get().then((value) {
        return value.exists;
      });
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  Stream<RecruiterModel> getRecruiter(String uid) {
    try {
      final document = _firestore.collection('recruiters').doc(uid).snapshots();
      final data = document.map((e) => RecruiterModel.fromSnapshot(e));

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<List<RecruiterModel>> getAllRecruiters(String uid) async {
    try {
      final document = await _firestore.collection('recruiters').get();
      final data =
          document.docs.map((e) => RecruiterModel.fromSnapshot(e)).toList();

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  void updateRecruiter(
      String firstName, String lastName, String email, String company) {
    final uid = Get.find<Authentication>().currentUser!.uid;
    _firestore.collection('recruiters').doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'company': company,
    });
  }
}
