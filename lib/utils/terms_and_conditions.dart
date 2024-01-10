import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key, this.onPressed}) : super(key: key);
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Welcome to Job Finder!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "By accessing or using our app (the \"Service\"), you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these Terms, please do not use our Service.",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  "1. User Accounts\n"
                  "   - You must create an account to access certain features of the Service.\n"
                  "   - Provide accurate, current, and complete information during the registration process.\n"
                  "   - Keep your password secure and confidential. You are responsible for any activity on your account./n/n"
                  "2. Content\n"
                  "   - Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material (\"Content\").\n"
                  "   - You are responsible for the Content that you post to the Service, including its legality, reliability, and appropriateness.\n"
                  "   - By posting Content to the Service, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through the Service.\n\n"
                  "3. Links To Other Web Sites\n"
                  "   - Our Service may contain links to third-party web sites or services that are not owned or controlled by Job Finder.\n"
                  "   - Job Finder has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services.\n"
                  "   - You further acknowledge and agree that Job Finder shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n\n"
                  "4. Changes\n"
                  "   - We reserve the right, at our sole discretion, to modify or replace these Terms at any time.\n"
                  "   - If a revision is material we will try to provide at least 30 days' notice prior to any new terms taking effect.\n"
                  "   - What constitutes a material change will be determined at our sole discretion.\n\n"
                  "5. Contact Us\n"
                  "   - If you have any questions about these Terms and Conditions, please contact us at [Your Contact Information].\n\n"
                  "6. Termination\n"
                  "   - We reserve the right to terminate or suspend your account at our discretion.\n\n"
                  "7. Changes to Terms\n"
                  "   - We may update these Terms from time to time. Check this page for the latest version.\n\n"
                  "8. Disclaimer of Warranties\n"
                  "   - The Service is provided \"as is\" without any warranty.\n\n"
                  "9. Limitation of Liability\n"
                  "   - We are not liable for any indirect, incidental, or consequential damages.\n\n"
                  "10. Governing Law\n"
                    "    - These Terms are governed by the laws of [Your Country/Region].\n\n"
                    ,style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
	            SizedBox(height: 20),            
                Text(
                  "If you have any questions about these Terms and Conditions, please contact us at iotech.inovation@gmail.com.",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Thank you for using Job Finder!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
