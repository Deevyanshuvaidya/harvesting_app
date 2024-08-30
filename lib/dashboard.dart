import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'dart:convert';

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.green.shade600,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 64, color: Colors.white),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                // Add other dashboard content here
              ],
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.black),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
