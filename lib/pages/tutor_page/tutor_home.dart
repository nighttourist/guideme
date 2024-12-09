import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;
import 'tutor_slot_page.dart';
import 'chat_page.dart';
import 'tutor_request.dart';
import 'notification_page.dart';
import '../other/settings.dart';
import 'tutor_profile_page.dart';
import '../student_page/studentList.dart';

class TutorHomePage extends StatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  int? selectedCardIndex;
  String? tutorUid;
  String? studentUid;

  final List<Color> cardColors = [
    Colors.blueAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.orangeAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.redAccent.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _fetchTutorUid();
  }

  Stream<int> _getUnreadNotificationCount() {
    if (tutorUid == null) return Stream.value(0);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(tutorUid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> _fetchTutorUid() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (snapshot.exists && snapshot['role'] == 'tutor') {
          setState(() {
            tutorUid = snapshot.id;
          });
        } else {
          print('User is not a tutor');
        }
      } catch (e) {
        print('Error fetching tutor UID: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Dashboard'),
        actions: [
          StreamBuilder<int>(
            stream: _getUnreadNotificationCount(),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;
              return IconButton(
                icon: badges.Badge(
                  badgeContent: unreadCount > 0 ? Text('$unreadCount') : null,
                  showBadge: unreadCount > 0,
                  child: Icon(Icons.notifications),
                ),
                onPressed: _showNotificationsDialog,
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Tutor!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: 7,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemBuilder: (context, index) {
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            accountName: Text(
              'Tutor Name', // Replace with actual tutor name if available
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              'tutor@example.com', // Replace with actual tutor email if available
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorProfilePage(tutorId: tutorUid ?? ''),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.request_page,
            text: 'Requests',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestPage(tutorId: tutorUid ?? ''),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.calendar_today,
            text: 'Manage Slots',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorSlotPage(tutorUid: tutorUid ?? ''),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Log Out',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Slots',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (tutorUid != null && studentUid != null) {
              // Fetch the student name from Firestore
              FirebaseFirestore.instance
                  .collection('students') // Make sure this collection contains the student data
                  .doc(studentUid) // Get the document of the student using studentUid
                  .get()
                  .then((DocumentSnapshot docSnapshot) {
                if (docSnapshot.exists) {
                  // Extract the student's name from the document
                  String studentName = docSnapshot['name']; // Assuming the field name is 'name'

                  // Navigate to the TutorChatPage with the actual student name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TutorChatPage(
                        studentId: studentUid ?? '',  // Pass studentId correctly
                        studentName: studentName,     // Pass the studentName fetched from Firestore
                      ),
                    ),
                  );
                } else {
                  // Handle the case where the student document doesn't exist
                  print('Student not found');
                }
              }).catchError((e) {
                // Handle any errors that occur while fetching the data
                print('Error fetching student data: $e');
              });
            }
            break;

          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TutorSlotPage(tutorUid: tutorUid ?? ''),
              ),
            );
            break;
        }
      },
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
    );
  }

  void _showNotificationsDialog() async {
    if (tutorUid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(tutorUid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'isRead': true});
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationPage(tutorId: tutorUid ?? '')),
      );
    }
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestPage(tutorId: tutorUid ?? ''),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorSlotPage(tutorUid: tutorUid ?? ''),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentListPage(tutorId: tutorUid ?? ''),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationPage(tutorId: tutorUid ?? ''),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorProfilePage(tutorId: tutorUid ?? ''),
          ),
        );
        break;
    }
  }

  Color _getCardColor(int index) {
    return selectedCardIndex == index
        ? Colors.blueGrey.shade300
        : cardColors[index % cardColors.length];
  }

  IconData _getCardIcon(int index) {
    switch (index) {
      case 0:
        return Icons.schedule;
      case 1:
        return Icons.request_page;
      case 2:
        return Icons.calendar_today;
      case 3:
        return Icons.person;
      case 4:
        return Icons.history;
      case 5:
        return Icons.notifications;
      case 6:
        return Icons.account_circle;
      default:
        return Icons.info;
    }
  }

  String _getCardLabel(int index) {
    switch (index) {
      case 0:
        return 'Sessions';
      case 1:
        return 'Requests';
      case 2:
        return 'Slots';
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
