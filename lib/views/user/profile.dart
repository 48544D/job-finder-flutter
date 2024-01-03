import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/home_page_controller.dart';
import 'package:job_finder/controllers/recruiter/profile_controller.dart';
import 'package:job_finder/controllers/user/profile_controller.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/utils/background.dart';
import 'package:job_finder/utils/scroll_view_height.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Background(child: _body(context));
  }

  Widget _body(context) {
    final controller = Get.put(UserProfileController());

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
                _topCard(controller),
                _bottomCard(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    double height = MediaQuery.of(context).size.height;
    final controller = Get.put(ProfileController());

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
            controller.logout();
          },
        )
      ],
    );
  }

  Widget _topCard(controller) {
    double height = MediaQuery.of(context).size.height;

    Positioned userInfo(double innerHeight, UserModel user) {
      return Positioned(
        bottom: 30,
        left: 0,
        right: 0,
        child: Container(
          height: innerHeight * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: innerHeight * 0.2),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Add more user information as needed
            ],
          ),
        ),
      );
    }

    Positioned profilePicture(double innerHeight, UserModel user) {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: innerHeight * 0.4,
            width: innerHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              // Add a placeholder image or default avatar
              image: DecorationImage(
                image: NetworkImage(user.profilePicture),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    Container topCardContent(
      double height,
      Positioned Function(double innerHeight, UserModel user) userInfo,
      UserModel user,
      Positioned Function(double innerHeight, UserModel user) profilePicture,
    ) {
      return Container(
        height: height * 0.4,
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;

          return Stack(
            children: [
              userInfo(innerHeight, user),
              profilePicture(innerHeight, user),
            ],
          );
        }),
      );
    }

    return FutureBuilder(
      future: controller.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data as UserModel;
            return topCardContent(height, userInfo, user, profilePicture);
          } else {
            // Handle case when user data is not available
            return const Center(child: Text('Error loading user data'));
          }
        } else {
          return const loadingAnimation();
        }
      },
    );
  }

  Widget _bottomCard(controller) {
    double innerHeight = MediaQuery.of(context).size.height * 0.5;

    Row bottomCardHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your Posts',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              )),
          IconButton(
              onPressed: () {
                Get.toNamed('/user/jobs');
              },
              icon: const Icon(Icons.add_circle_outline,
                  color: Colors.deepPurple)),
        ],
      );
    }
    return Container(
       constraints: BoxConstraints(
                        minHeight: innerHeight * 0.4,
                      ),
                      child: const Center(
                        child: Text(
                          'No jobs posted yet',
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


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfilePage extends StatelessWidget {
//   final String userId;

//   ProfilePage({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // User's photo
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/images/logo.png'),
//             ),
//             SizedBox(height: 16),
//             // User's information
//             StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 var userData = snapshot.data!.data();
//                 return Column(
//                   children: [
//                     Text(
//                       userData['name'],
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       userData['occupation'],
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             // User's posts
//             Text(
//               'Posts:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('posts')
//                   .where('userId', isEqualTo: userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 var posts = snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     var postData = posts[index].data();
//                     return ListTile(
//                       title: Text(postData['title']),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfilePage extends StatelessWidget {
//   final String userId;

//   ProfilePage({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // User's photo
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/images/logo.png'),
//             ),
//             SizedBox(height: 16),
//             // User's information
//             StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 var userData = snapshot.data!.data();
//                 return Column(
//                   children: [
//                     Text(
//                       userData['name'],
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       userData['occupation'],
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             // User's posts
//             Text(
//               'Posts:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('posts')
//                   .where('userId', isEqualTo: userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 var posts = snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     var postData = posts[index].data();
//                     return ListTile(
//                       title: Text(postData['title']),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
