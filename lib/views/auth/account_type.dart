import 'package:flutter/material.dart';

class AccountTypeRegister extends StatelessWidget {
  const AccountTypeRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Account Type'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register/recruiter');
              },
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person_2,
                      size: 50,
                      color: Colors.black,
                    ),
                    Text(
                      'Recruiter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black, // Change icon color as needed
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register/employee');
              },
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                    Text(
                      'Employee',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black, // Change icon color as needed
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
