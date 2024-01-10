import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_finder/utils/lets_start.dart';
import 'package:job_finder/utils/logo.dart';
import 'package:job_finder/utils/terms_and_conditions.dart';
import 'package:job_finder/views/TermsAndConditionsButton%20.dart';
import 'package:job_finder/views/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Logo(height: 150.0, width: 150.0, radius: 50.0),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsAndConditionsButton()),
                );
              },
              child: const Text('Terms And Conditions',
                      style: TextStyle(color: Colors.black, fontSize: 15)),
            ),
            LetsStart(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
