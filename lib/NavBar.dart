import 'package:app/dashboard.dart';
import 'package:flutter/material.dart';

import 'myssh.dart';

class NavBar extends StatelessWidget {
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
                MaterialPageRoute(builder: (context) => MySSHPage(uniqueId: '',)),
              ); // Close the drawer
              // Add navigation logic for My SSH page
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage(uniqueId: '',)),
              ); // Close the drawer
              // Add navigation logic for Home page
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
              Navigator.pop(context); // Close the drawer
              // Implement the logout functionality
            },
          ),
        ],
      ),
    );
  }
}
