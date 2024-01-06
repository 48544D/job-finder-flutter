import 'package:flutter/material.dart';

class HomePageUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Finder'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Jobs',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Filter:'),
                SizedBox(width: 8.0),
                DropdownButton<String>(
                  items: <String>['All', 'Full-time', 'Part-time', 'Remote']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // TODO: Apply filter based on selected value
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual job count
              itemBuilder: (BuildContext context, int index) {
                // TODO: Build job list item based on fetched data
                return ListTile(
                  title: Text('Job Title'),
                  subtitle: Text('Company Name'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to user profile page
        },
        child: Icon(Icons.person),
      ),
    );
  }
}