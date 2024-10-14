import 'package:flutter/material.dart';

class TutorHomePage extends StatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  int? selectedCardIndex;

  // Define a list of card colors
  final List<Color> cardColors = [
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.green,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.teal,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications page or show a dialog
              _showNotificationsDialog();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Tamjid!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3, // 3 cards in each row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: List.generate(7, (index) {
                    return _buildCard(
                      index: index,
                      color: _getCardColor(index),
                      icon: _getCardIcon(index),
                      label: _getCardLabel(index),
                      onTap: () {
                        setState(() {
                          selectedCardIndex = index;
                        });
                        _navigateToPage(index);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Build the Drawer Widget
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'Tutor Menu',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              // Log out functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
    );
  }

  // Build the Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.lightBlue[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to Chat History
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat, size: 30),
                  Text('Chat History', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/search'
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 30),
                  Text('Search', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to View Slot
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_view_day, size: 30),
                  Text('View Slot', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Notifications Dialog
  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: Text('You have no new notifications.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
      // Navigate to Sessions
        break;
      case 1:
      // Navigate to Requests
        break;
      case 2:
      // Navigate to View & Change Slots
        break;
      case 3:
      // Navigate to Students
        break;
      case 4:
      // Navigate to History
        break;
      case 5:
      // Navigate to Notifications
        break;
      case 6:
      // Navigate to Profile
        break;
    }
  }

  Color _getCardColor(int index) {
    if (selectedCardIndex == index) {
      return Colors.blueGrey; // Highlight selected card
    }
    return cardColors[index % cardColors.length];
  }

  IconData _getCardIcon(int index) {
    switch (index) {
      case 0:
        return Icons.calendar_today;
      case 1:
        return Icons.person_add;
      case 2:
        return Icons.edit;
      case 3:
        return Icons.people;
      case 4:
        return Icons.history;
      case 5:
        return Icons.notifications;
      case 6:
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  String _getCardLabel(int index) {
    switch (index) {
      case 0:
        return 'Sessions';
      case 1:
        return 'Requests';
      case 2:
        return 'View & Change Slots';
      case 3:
        return 'Students';
      case 4:
        return 'History';
      case 5:
        return 'Notifications';
      case 6:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  Widget _buildCard({
    required int index,
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


