import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'NavBar.dart';
import 'MapPage.dart';
import 'package:url_launcher/url_launcher.dart';

class MySSHPage extends StatefulWidget {
  final String OPERATOR_ID;

  MySSHPage({required this.OPERATOR_ID});

  @override
  _MySSHPageState createState() => _MySSHPageState();
}

class _MySSHPageState extends State<MySSHPage> {
  List<dynamic> harvesters = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchHarvesters();
    // Fetch harvesters every 5 seconds for live updates
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fetchHarvesters();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchHarvesters() async {
    try {
      var operatorResponse = await http.get(
        Uri.parse('http://192.168.165.35/api_app_testing/fetch_operator_id.php?OPERATOR_ID=${widget.OPERATOR_ID}'),
      );
      var operatorData = json.decode(operatorResponse.body);

      if (operatorData['status'] == 'success') {
        var operatorId = operatorData['data']['OPERATOR_ID'];
        var operatorName = operatorData['data']['OPERATOR_NAME'];
        var operatorVillage = operatorData['data']['VILLAGE'];

        var harvestersResponse = await http.get(
          Uri.parse('http://192.168.165.35/api_app_testing/fetch_harvesters.php?operatorId=$operatorId'),
        );

        var harvestersData = json.decode(harvestersResponse.body);
        if (harvestersData['status'] == 'success') {
          for (var harvester in harvestersData['data']) {
            // Fetch and update the status and disabled state for each harvester
            var statusResponse = await http.get(
              Uri.parse('http://192.168.165.35/api_app_testing/fetch_allocation_status.php?harvestId=${harvester['HARVEST_ID']}&operatorId=$operatorId'),
            );
            var statusData = json.decode(statusResponse.body);

            harvester['STATUS'] = statusData['status'] == 'success'
                ? statusData['data']['STATUS'] ?? 'Not Allocated'
                : 'Not Allocated';

            // Fetch the DISABLED status from the harvester
            harvester['DISABLE'] = harvester['DISABLE'] ?? 0;

            // Add operator village to the harvester details
            harvester['OPERATOR_VILLAGE'] = operatorVillage;
            harvester['OPERATOR_NAME'] = operatorName;
          }

          setState(() {
            harvesters = harvestersData['data'];
            isLoading = false;
          });
        } else {
          showError(harvestersData['message']);
        }
      } else {
        showError(operatorData['message']);
      }
    } catch (error) {
      showError("Failed to load data.");
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Toggle harvester's DISABLED state
  Future<void> toggleDisable(String harvestId, String operatorId, bool isCurrentlyDisabled, String status) async {
    if (status == 'Allocated') {
      // Show popup if trying to disable an allocated harvester
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.grey.shade300, // Border color
                width: 1.5, // Border width
              ),
            ),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // Header background color
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Warning',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold header text
                  fontSize: 18.0,
                ),
              ),
            ),
            content: Text('This harvester is currently in use and cannot be disabled.'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://192.168.165.35/api_app_testing/toggle_disable.php'),
        body: json.encode({
          'harvestId': harvestId,
          'operatorId': operatorId, // Added operatorId
          'disable': isCurrentlyDisabled ? 0 : 1, // Toggle between enabled/disabled
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Update UI directly without fetching all data again
        setState(() {
          harvesters = harvesters.map((harvester) {
            if (harvester['HARVEST_ID'] == harvestId) {
              harvester['DISABLE'] = isCurrentlyDisabled ? 0 : 1; // Update the UI state
            }
            return harvester;
          }).toList();
        });
        print("Toggle successful: $harvestId is now ${isCurrentlyDisabled ? 'enabled' : 'disabled'}");
      } else {
        showError(data['message']);
        print("Error from server: ${data['message']}");
      }
    } catch (error) {
      showError("Failed to update state.");
      print("Exception: $error");
    }
  }


  Future<void> showDetails(String harvestId, String operatorId) async {
    try {
      var response = await http.get(
        Uri.parse('http://192.168.165.35/api_app_testing/fetch_allocation_details.php?harvestId=$harvestId&operatorId=$operatorId'),
      );
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        var farmerDetails = data['data']['farmer'];
        var allocationDate = data['data']['allocationDate'];

        // Ensure latitude and longitude are parsed as doubles
        double farmerLatitude = double.tryParse(farmerDetails['LATITUDE'].toString()) ?? 0.0;
        double farmerLongitude = double.tryParse(farmerDetails['LONGITUDE'].toString()) ?? 0.0;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: Colors.grey.shade300, // Border color
                  width: 1.5, // Border width
                ),
              ),
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Header background color
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Allocation Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold header text
                    fontSize: 18.0,
                  ),
                ),
              ),
              content: SingleChildScrollView( // Allow scrolling if content is too long
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Allocation Date: $allocationDate", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(150), // Set fixed width for the first column
                        1: FixedColumnWidth(200), // Set fixed width for the second column
                      },
                      children: [
                        TableRow(
                          children: [
                            Text("Farmer Name:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['FARMER_NAME']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['LOCATION']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Survey No:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['SURVEY_NO']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Village:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['VILLAGE']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Taluka:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['TALUKA']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("District:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['DISTRICT']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Pincode:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['PINCODE']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Acres:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${farmerDetails['ACERS']}"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Latitude:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$farmerLatitude"),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("Longitude:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$farmerLongitude"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                // Arrange the buttons in a Column to create a V shape
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                          ),
                          child: Text("Visualize route"),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MapPage(
                                  farmerLatitude: farmerLatitude,
                                  farmerLongitude: farmerLongitude,
                                ),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                          ),
                          child: Text("Direction"),
                          onPressed: () {
                            _launchGoogleMaps(farmerLatitude, farmerLongitude);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Spacing between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                          ),
                          child: Text("Completed"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _confirmCompletion(harvestId, operatorId);

                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green, // Button text color
                          ),
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );


      } else {
        showError(data['message']);
      }
    } catch (error) {
      showError("Failed to fetch details.");
    }
  }

// Function to confirm and handle task completion
  Future<void> _confirmCompletion(String harvestId, String operatorId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.grey.shade300, // Border color
              width: 1.5, // Border width
            ),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Header background color
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Confirmation',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold header text
                fontSize: 18.0,
              ),
            ),
          ),
          content: Text('Is the task completed?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Button text color
                backgroundColor: Colors.green, // Button background color
              ),
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Button text color
                backgroundColor: Colors.green, // Button background color
              ),
              child: Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                await _completeTask(harvestId, operatorId);

                // Delay for a moment to allow the dialog to close before continuing
              },
            ),
          ],
        );
      },
    );

  }



// Function to update the status in the allocation_ssh table
  Future<void> _completeTask(String harvestId, String operatorId) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.165.35/api_app_testing/complete_task.php'),
        body: json.encode({
          'harvestId': harvestId,
          'operatorId': operatorId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task completed successfully!")),
        );
        fetchHarvesters(); // Refresh harvesters list to reflect the changes
      } else {
        showError(data['message']);
      }
    } catch (error) {
      showError("Failed to update task.");
    }
  }


  // Function to launch Google Maps with farmer's location
  Future<void> _launchGoogleMaps(double latitude, double longitude) async {
    double sourceLatitude = 19.1669167;
    double sourceLongitude = 73.9518611;
    double destinationLatitude = latitude;
    double destinationLongitude = longitude;

    final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$sourceLatitude,$sourceLongitude&destination=$destinationLatitude,$destinationLongitude';


    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }


  Color getStatusColor(String status) {
    switch (status) {
      case "Allocated":
        return Colors.yellow[700]!;
      case "Not Allocated":
        return Colors.green;
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
        title: Text('Operator Harvesters'),
      ),
      drawer: NavBar(OPERATOR_ID: widget.OPERATOR_ID),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: harvesters.length,
          itemBuilder: (context, index) {
            var harvester = harvesters[index];
            String status = harvester['STATUS'];
            bool isDisabled = harvester['DISABLE'] == 1;

            return Card(
              margin: EdgeInsets.all(10),
              color: isDisabled ? Colors.grey[300] : Colors.white,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.asset(
                          'assets/1.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                        title: Text("SSH: ${harvester['HARVEST_ID']}" ,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Operator Name: ${harvester['OPERATOR_NAME']}"),
                            Text("Location: ${harvester['OPERATOR_VILLAGE']}"),
                            if (!isDisabled) ...[ // Only show status if not disabled
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: getStatusColor(status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isDisabled) Text("Status: Disabled", style: TextStyle(color: Colors.black54)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 1,
                    right: 5,
                    child: IconButton(
                      icon: Icon(
                        isDisabled ? Icons.lock : Icons.lock_open, // Use lock and unlock icons
                        color: isDisabled ? Colors.red : Colors.green,
                          size: 15,
                      ),
                      onPressed: () {
                        toggleDisable(harvester['HARVEST_ID'],harvester['OPERATOR_ID'] ,isDisabled, status);
                      },
                    ),
                  ),
                  if (!isDisabled && status == "Allocated")
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.info, color: Colors.blue, size: 15),
                        onPressed: () {
                          showDetails(harvester['HARVEST_ID'],widget.OPERATOR_ID);
                        },
                      ),
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
