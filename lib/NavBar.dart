import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'myssh.dart';
import 'login.dart'; // Import the login page

class NavBar extends StatelessWidget {
  final String OPERATOR_ID;  // Declare uniqueId

  // Constructor to accept uniqueId as a parameter
  NavBar({required this.OPERATOR_ID});

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
                MaterialPageRoute(builder: (context) => MySSHPage(OPERATOR_ID: OPERATOR_ID)),  // Pass uniqueId to MySSHPage
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
                MaterialPageRoute(builder: (context) => DashboardPage(OPERATOR_ID: OPERATOR_ID)),  // Pass uniqueId to DashboardPage
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners for the dialog
            side: BorderSide(color: Colors.grey.shade300, width: 2), // Shaded border
          ),
          title: Center(
            child: Text(
              "Confirm Logout",
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold header
                fontSize: 20,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center, // Center align text
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Green background for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white, // White text
                      fontWeight: FontWeight.bold, // Bold text for the button
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Green background for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    _logout(context);  // Call logout function if 'Yes' is pressed
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.white, // White text
                      fontWeight: FontWeight.bold, // Bold text for the button
                    ),
                  ),
                ),
              ],
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