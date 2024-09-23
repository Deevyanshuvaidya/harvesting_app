import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'NavBar.dart';  // Import the NavBar class

class MySSHPage extends StatefulWidget {
  final String uniqueId;

  MySSHPage({required this.uniqueId});

  @override
  _MySSHPageState createState() => _MySSHPageState();
}

class _MySSHPageState extends State<MySSHPage> {
  List<dynamic> operators = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOperators();
  }

  Future<void> fetchOperators() async {
    var response = await http.get(
      Uri.parse('http://192.168.54.35/api_app_testing/myssh.php'), // Your PHP server URL
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      setState(() {
        operators = data['data'];
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

  // Mock status data for now, to be replaced with DB field when available
  String getStatus() {
    // Placeholder logic, this can be modified later when the status is added to the DB
    List<String> statuses = ["Available", "Allotted", "Can't be Allowed"];
    return statuses[operators.length % 3];  // Simple logic to cycle statuses for demo
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Available":
        return Colors.green;
      case "Allotted":
        return Colors.yellow;
      case "Can't be Allowed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operator List'),
      ),
      drawer: NavBar(),  // Add the NavBar as the drawer
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: operators.length,
          itemBuilder: (context, index) {
            var operator = operators[index];
            String status = getStatus();  // Get mock status for now
            return Card(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Image.asset(
                      'assets/1.png',  // Constant image for each operator
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    title: Text("SSH: ${operator['unique_id']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Industry: ${operator['industry_name']}"),
                        Text("Location: ${operator['location']}"),
                        Text("Status: $status", style: TextStyle(color: getStatusColor(status))),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        status == "Available" ? Icons.check_circle : Icons.error,
                        color: getStatusColor(status),
                      ),
                      SizedBox(width: 10),
                      status == "Available"
                          ? ElevatedButton(
                        onPressed: () {
                          // Navigate to schedule page
                        },
                        child: Text('Check Schedule'),
                      )
                          : Container(),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
