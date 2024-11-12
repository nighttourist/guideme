import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Load the saved theme preference (if available) here
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Apply the dark theme across the app and save the preference
    _applyTheme();
  }

  void _applyTheme() {
    if (isDarkMode) {
      // Apply dark theme
      ThemeData.dark();
    } else {
      // Apply light theme
      ThemeData.light();
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Appearance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: isDarkMode,
            onChanged: _toggleDarkMode,
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          Divider(),

          ListTile(
            title: Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Edit Profile"),
            onTap: () {
              // Navigate to Edit Profile page
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () {
              // Navigate to Change Password page
            },
          ),
          Divider(),

          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SwitchListTile(
            title: Text("Receive Notifications"),
            value: true,
            onChanged: (bool value) {
              // Enable or disable notifications
            },
            secondary: Icon(Icons.notifications),
          ),
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text("Sound"),
            onTap: () {
              // Toggle notification sound settings
            },
          ),
          Divider(),

          ListTile(
            title: Text(
              'Privacy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () {
              // Navigate to Privacy Policy page
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text("Security Settings"),
            onTap: () {
              // Navigate to Security Settings page
            },
          ),
          Divider(),

          ListTile(
            title: Text(
              'General',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
            onTap: () {
              // Navigate to Help & Support page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log Out"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
