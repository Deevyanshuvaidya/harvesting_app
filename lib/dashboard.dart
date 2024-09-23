import 'dart:convert';

import 'package:flutter/material.dart';
import 'NavBar.dart';  // Import NavBar
import 'login.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  final String uniqueId;

  DashboardPage({required this.uniqueId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String name = '';
  String location = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOperatorDetails();
  }

  Future<void> fetchOperatorDetails() async {
    var response = await http.post(
      Uri.parse('http://192.168.54.35/api_app_testing/fetch_operator_details.php'),  // Replace with your server address
      body: {'unique_id': widget.uniqueId},
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      setState(() {
        name = data['data']['name'];
        location = data['data']['location'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        title: Text('Profile Dashboard'),
      ),
      drawer: NavBar(), // NavBar as the drawer
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                color: Colors.green.shade600,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 64, color: Colors.white),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          widget.uniqueId,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white70),
                            SizedBox(width: 4.0),
                            Text(
                              location,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Dashboard content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      "Dashboard Overview",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    // Add Dashboard buttons or cards here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Example Button 1
                        _buildDashboardButton(
                            context, Icons.bar_chart, "Reports"),
                        // Example Button 2
                        _buildDashboardButton(
                            context, Icons.settings, "Settings"),
                        // Example Button 3
                        _buildDashboardButton(
                            context, Icons.person, "Profile"),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        icon: Icon(Icons.logout),
                        label: Text("Logout"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create dashboard buttons
  Widget _buildDashboardButton(
      BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Material(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: () {
              // Handle button tap, navigate to other pages if needed
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(icon, size: 36.0, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(label,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }
}
