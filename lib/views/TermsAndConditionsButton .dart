import 'package:flutter/material.dart';

class TermsAndConditionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(height: 40),
              Text(
                "Welcome to Job Finder!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "By accessing or using our app (the \"Service\"), you agree to comply with and be bound by these Terms and Conditions. If you do not agree to these Terms, please do not use our Service.",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 20),
              buildSectionTitle("1. User Accounts"),
              buildListItem("- You must create an account to access certain features of the Service."),
              buildListItem("- Provide accurate, current, and complete information during the registration process."),
              buildListItem("- Keep your password secure and confidential. You are responsible for any activity on your account."),
              SizedBox(height: 20),
              buildSectionTitle("2. Content"),
              buildListItem("- You are solely responsible for the content you post or submit on the Service."),
              buildListItem("- Do not post false, misleading, or inappropriate content."),
              SizedBox(height: 20),
              buildSectionTitle("3. Privacy"),
              buildListItem("- Our Privacy Policy explains how we collect, use, and protect your personal information."),
              buildSectionTitle("4. Job Listing"),
              buildListItem("- Job listings provided on the Service are for informational purposes only. - We do not guarantee that any job listing will be filled or that any candidate will be hired."),
              buildSectionTitle("5. Prohibited Conduct"),
              buildListItem("- You agree not to engage in any of the following prohibited activities:"),
              buildSectionTitle("6. Termination"),
              buildListItem("- We may terminate or suspend your account or ability to use the Service, in whole or in part, at our sole discretion, for any or no reason, and without notice or liability of any kind."),
              buildSectionTitle("7. Disclaimer of Warranty and Limitation of Liability"),
              buildListItem("- We make no warranties or representations about the Service or any content available on the Service."),
              buildSectionTitle("8. Disclaimer of Warranties"),
              buildListItem("- We make no warranties or representations about the Service or any content available on the Service."),
              buildSectionTitle("9. Indemnification"),
              buildListItem("- You agree to defend, indemnify, and hold us harmless from and against any claims, liabilities, damages, losses, and expenses, including, without limitation, reasonable legal and accounting fees, arising out of or in any way connected with your access to or use of the Service, or your violation of these Terms."),
              buildSectionTitle("10. Changes to These Terms"),
              buildListItem("- We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion."),
              SizedBox(height: 20),
              Text(
                "If you have any questions about these Terms and Conditions, please contact us at iotech.inovation@gmail.com.",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                "Thank you for using Job Finder!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildListItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
