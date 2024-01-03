import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/utils/authentication.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id.toString())
          .set(user.toJson());
    } catch (e) {
      // Handle any errors
      print('Error creating user: $e');
      rethrow;
    }
  }

  userExists(String uid) {
    try {
      return _firestore.collection('users').doc(uid).get().then((value) {
        return value.exists;
      });
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final document = await _firestore.collection('users').doc(userId).get();

      return UserModel.fromSnapshot(document);
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      final document = await _firestore.collection('users').doc(uid).get();

      return UserModel.fromSnapshot(document);
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers(String uid) async {
    try {
      final document = await _firestore.collection('users').get();
      final data = document.docs.map((e) => UserModel.fromSnapshot(e)).toList();

      return data;
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
  }

  void updateUser(
      String firstName, String lastName, String email, String profilePicture) {
    final uid = Get.find<Authentication>().currentUser!.uid;
    _firestore.collection('users').doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
    });
  }
}