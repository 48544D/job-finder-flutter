import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:job_finder/models/user.dart';

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

  Stream<UserModel> getUserById(String userId) {
    try {
      final document = _firestore.collection('users').doc(userId).snapshots();
      final data = document.map((e) => UserModel.fromSnapshot(e));

      return data;
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



// Future<List<UserModel>> updateUser(String uid)async{
//   try{
//     final document = await _firestore.collection('users').get();
//     final data = document.docs.map((e) => UserModel.fromSnapshot(e)).toList();
//     return data;
//   }catch(e){
//     print('Error updating user: $e');
//     rethrow;
//   }
// }
  
    Future<UserModel> updateUserById(String userId) async {
      try {
      final document = await _firestore.collection('users').doc(userId).get();

      return UserModel.fromSnapshot(document);
    } catch (e) {
      // Handle any errors
      print('Error getting user: $e');
      rethrow;
    }
    }
}
