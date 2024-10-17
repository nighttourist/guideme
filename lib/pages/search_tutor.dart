import 'package:flutter/material.dart';

class TutorSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Tutors'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search fields for subject and location
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(),
              ),
              items: ['Math', 'Science', 'English', 'Programming']
                  .map((subject) => DropdownMenuItem(
                value: subject,
                child: Text(subject),
              ))
                  .toList(),
              onChanged: (value) {
                // Handle subject selection
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(),
              ),
              items: ['Dhaka', 'Chittagong', 'Rajshahi', 'Sylhet']
                  .map((location) => DropdownMenuItem(
                value: location,
                child: Text(location),
              ))
                  .toList(),
              onChanged: (value) {
                // Handle location selection
              },
            ),
            SizedBox(height: 20),
            // Search button
            ElevatedButton.icon(
              onPressed: () {
                // Perform search functionality
              },
              icon: Icon(Icons.search),
              label: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            // Sorting Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Results:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  hint: Text('Sort By'),
                  items: [
                    DropdownMenuItem(
                      value: 'rating',
                      child: Text('Highest Rating'),
                    ),
                    DropdownMenuItem(
                      value: 'distance',
                      child: Text('Closest Distance'),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle sorting
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            // Display list of tutors
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with the actual number of tutors
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          'T$index',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('Tutor Name $index'),
                      subtitle: Text(
                          'Subjects: Math, Science\nRating: 4.5 ⭐'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to tutor details page (to be created)
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
