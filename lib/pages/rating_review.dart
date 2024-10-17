import 'package:flutter/material.dart';

class RatingsReviewsPage extends StatefulWidget {
  @override
  _RatingsReviewsPageState createState() => _RatingsReviewsPageState();
}

class _RatingsReviewsPageState extends State<RatingsReviewsPage> {
  // Store ratings for each tutor
  Map<int, int> ratings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Tutors'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with the actual number of tutors to rate
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tutor Name $index',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Rate this tutor:'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          ratings[index] != null && ratings[index]! >= 1
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _rateTutor(index, 1),
                      ),
                      IconButton(
                        icon: Icon(
                          ratings[index] != null && ratings[index]! >= 2
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _rateTutor(index, 2),
                      ),
                      IconButton(
                        icon: Icon(
                          ratings[index] != null && ratings[index]! >= 3
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _rateTutor(index, 3),
                      ),
                      IconButton(
                        icon: Icon(
                          ratings[index] != null && ratings[index]! >= 4
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _rateTutor(index, 4),
                      ),
                      IconButton(
                        icon: Icon(
                          ratings[index] != null && ratings[index]! >= 5
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _rateTutor(index, 5),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Write a review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (reviewText) {
                      // Handle review text input here
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle submit rating and review
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _rateTutor(int tutorIndex, int rating) {
    setState(() {
      ratings[tutorIndex] = rating; // Update the rating for the tutor
    });
  }
}
