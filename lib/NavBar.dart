import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'myssh.dart';
import 'login.dart'; // Import the login page

class NavBar extends StatelessWidget {
  final String uniqueId;  // Declare uniqueId

  // Constructor to accept uniqueId as a parameter
  NavBar({required this.uniqueId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // SHSTRA logo header with fixed size
          Container(
            width: 476,
            height: 130,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white, // Set a solid background color or remove for transparent
              ),
              child: Center(
                child: Image.asset(
                  'assets/Logo SHSTRA.jpg',  // Path to your SHSTRA logo
                  width: 1907,
                  height: 523,
                  fit: BoxFit.contain,  // Ensures the logo fits within the available space
                ),
              ),
            ),
          ),

          // Menu items
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My SSH'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MySSHPage(uniqueId: uniqueId)),  // Pass uniqueId to MySSHPage
              ); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('SCHEDULE'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add navigation logic for SCHEDULE page
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage(uniqueId: uniqueId)),  // Pass uniqueId to DashboardPage
              ); // Close the drawer
            },
          ),

          // Spacer to push the bottom buttons down
          Spacer(),

          // Help & Settings at the bottom
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add navigation logic for Help page
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add navigation logic for Settings page
            },
          ),

          // Logout button at the bottom
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _showLogoutConfirmation(context); // Show confirmation dialog
            },
          ),
        ],
      ),
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                _logout(context);  // Call logout function if 'Yes' is pressed
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Logout function to navigate to the login page
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),  // Navigate to LoginPage
    );
  }
}