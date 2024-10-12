import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import for Timer
import 'NavBar.dart';

class MySSHPage extends StatefulWidget {
  final String uniqueId;

  MySSHPage({required this.uniqueId});

  @override
  _MySSHPageState createState() => _MySSHPageState();
}

class _MySSHPageState extends State<MySSHPage> {
  List<dynamic> allocations = [];
  bool isLoading = true;
  Timer? _timer;  // Timer for periodic fetching

  @override
  void initState() {
    super.initState();
    fetchAllocations();
    // Set up a timer to fetch data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fetchAllocations();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel the timer when the page is disposed
    super.dispose();
  }

  Future<void> fetchAllocations() async {
    var response = await http.get(
      Uri.parse('http://192.168.54.35/api_app_testing/fetch_allocations.php?operatorId=${widget.uniqueId}'),
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      setState(() {
        allocations = data['data'];
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

  Future<void> updateDisableStatus(String harvesterId, bool disable) async {
    var response = await http.post(
      Uri.parse('http://192.168.54.35/api_app_testing/update_disable.php'),
      body: {
        'harvester_id': harvesterId,
        'disable': disable ? '1' : '0',
      },
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      // Automatically refresh the list after status update
      fetchAllocations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  // Function to show the schedule dialog with dummy data
  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Harvester Schedule Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Harvester ID: SSH012024"),
              SizedBox(height: 10),
              Text("Farmer: John Doe"),
              SizedBox(height: 10),
              Text("Location: Field 24, Springfield"),
              SizedBox(height: 10),
              Text("Date: 2024-10-05"),
              SizedBox(height: 10),
              Text("Time: 10:00 AM - 12:00 PM"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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

  Icon getStatusIcon(String status) {
    switch (status) {
      case "Available":
        return Icon(Icons.help_outline, color: Colors.green); // Question mark for "Available"
      case "Allotted":
        return Icon(Icons.check_circle, color: Colors.yellow); // Right tick for "Allotted"
      case "Can't be Allowed":
        return Icon(Icons.block_sharp, color: Colors.red); // Exclamation mark for "Can't be Allowed"
      default:
        return Icon(Icons.help_outline, color: Colors.grey); // Default to question mark
    }
  }

  // Function to show an alert dialog when the harvester is allocated
  void _showAllocatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('This harvester is currently allocated and cannot be disabled.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operator List'),
      ),
      drawer: NavBar(uniqueId: widget.uniqueId),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: allocations.length,
          itemBuilder: (context, index) {
            var allocation = allocations[index];
            bool isDisabled = allocation['disable'] == '1';
            String status = allocation['status'];

            return Card(
              margin: EdgeInsets.all(10),
              color: isDisabled ? Colors.grey[300] : Colors.white, // Grey out the card if disabled
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1,  // Reduce opacity if disabled
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        'assets/1.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "SSH: ${allocation['harvester_id']}",
                        style: TextStyle(
                          color: isDisabled ? Colors.grey : Colors.black,  // Grey out text if disabled
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Industry: ${allocation['industry_name']}",
                            style: TextStyle(
                              color: isDisabled ? Colors.grey : Colors.black,
                            ),
                          ),
                          Text(
                            "Location: ${allocation['location']}",
                            style: TextStyle(
                              color: isDisabled ? Colors.grey : Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: getStatusColor(status),
                                ),
                              ),
                              SizedBox(width: 10),
                              getStatusIcon(status),  // Display the correct icon
                            ],
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: !isDisabled,  // Switch shows the opposite of disable status
                        onChanged: (value) {
                          if (status == "Allotted") {
                            _showAllocatedDialog();  // Show warning dialog
                          } else {
                            setState(() {
                              isDisabled = !value;  // Toggle status locally
                            });
                            updateDisableStatus(allocation['harvester_id'], !value);  // Update status in the database
                          }
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                    ),
                    if (!isDisabled)  // If not disabled, show additional options like buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showScheduleDialog(context); // Navigate to schedule page
                            },
                            child: Text('Check Schedule'),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
