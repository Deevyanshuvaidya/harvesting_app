import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'NavBar.dart';

class MySSHPage extends StatefulWidget {
  final String uniqueId;

  MySSHPage({required this.uniqueId});

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
        Uri.parse('http://192.168.142.35/api_app_testing/fetch_operator_id.php?uniqueId=${widget.uniqueId}'),
      );
      var operatorData = json.decode(operatorResponse.body);

      if (operatorData['status'] == 'success') {
        var operatorId = operatorData['data']['OPERATOR_ID'];

        var harvestersResponse = await http.get(
          Uri.parse('http://192.168.142.35/api_app_testing/fetch_harvesters.php?operatorId=$operatorId'),
        );

        var harvestersData = json.decode(harvestersResponse.body);
        if (harvestersData['status'] == 'success') {
          for (var harvester in harvestersData['data']) {
            var statusResponse = await http.get(
              Uri.parse('http://192.168.142.35/api_app_testing/fetch_allocation_status.php?harvestId=${harvester['HARVEST_ID']}'),
            );
            var statusData = json.decode(statusResponse.body);

            // Debugging: Check what status is returned from the backend
            print("Status for Harvester ID ${harvester['HARVEST_ID']}: ${statusData['data']['STATUS']}");

            if (statusData['status'] == 'success') {
              harvester['STATUS'] = statusData['data']['STATUS'] ?? 'Available';
            } else {
              harvester['STATUS'] = 'Available';
            }
          }

          setState(() {
            harvesters = harvestersData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(harvestersData['message'])),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(operatorData['message'])),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data.")),
      );
    }
  }

  Future<void> updateDisableStatus(String harvesterId, bool disable) async {
    var response = await http.post(
      Uri.parse('http://192.168.142.35/api_app_testing/update_disable.php'),
      body: {
        'harvester_id': harvesterId,
        'disable': disable ? '1' : '0',
      },
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      fetchHarvesters();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> showDetails(String harvestId) async {
    try {
      var response = await http.get(
        Uri.parse('http://192.168.142.35/api_app_testing/fetch_allocation_details.php?harvestId=$harvestId'),
      );
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        var farmerDetails = data['data']['farmer'];
        var allocationDate = data['data']['allocationDate'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Allocation Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Allocation Date: $allocationDate", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Farmer Name: ${farmerDetails['FARMER_NAME']}"),
                  Text("Location: ${farmerDetails['LOCATION']}"),
                  Text("Survey No: ${farmerDetails['SURVEY_NO']}"),
                  Text("Village: ${farmerDetails['VILLAGE']}"),
                  Text("Taluka: ${farmerDetails['TALUKA']}"),
                  Text("District: ${farmerDetails['DISTRICT']}"),
                  Text("Pincode: ${farmerDetails['PINCODE']}"),
                  Text("Acres: ${farmerDetails['ACERS']}"),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch details.")),
      );
    }
  }

  // Method to get the color based on the status
  Color getStatusColor(String status) {
    switch (status) {
      case "Allocated":
        return Colors.yellow[700]!;
      case "Available":
        return Colors.green;
      case "Can't be Allowed":
        return Colors.red;
      default:
        return Colors.grey; // Default color
    }
  }

  // Method to show a dialog when a harvester is allocated and cannot be disabled
  void _showAllocationInUseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('This harvester is currently allocated and cannot be disabled.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
        title: Text('Operator Harvesters'),
      ),
      drawer: NavBar(uniqueId: widget.uniqueId),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: harvesters.length,
          itemBuilder: (context, index) {
            var harvester = harvesters[index];
            bool isDisabled = harvester['DISABLE'] == '1';
            String status = harvester['STATUS'];

            return Card(
              margin: EdgeInsets.all(10),
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
                        title: Text(
                          "Harvester ID: ${harvester['HARVEST_ID']}",
                          style: TextStyle(
                            color: isDisabled ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Owned By: ${harvester['OWNED_BY']}",
                              style: TextStyle(
                                color: isDisabled ? Colors.grey : Colors.black,
                              ),
                            ),
                            Text(
                              "Operator Location: ${harvester['OPERATOR_LOCATION']}",
                              style: TextStyle(
                                color: isDisabled ? Colors.grey : Colors.black,
                              ),
                            ),
                            if (!isDisabled)
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: getStatusColor(status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                        isDisabled ? Icons.lock : Icons.lock_open,
                        color: isDisabled ? Colors.grey : Colors.green,
                        size: 15,
                      ),
                      onPressed: () {
                        if (status == "Allocated") {
                          _showAllocationInUseDialog();
                        } else {
                          setState(() {
                            isDisabled = !isDisabled;
                          });
                          updateDisableStatus(harvester['HARVEST_ID'], isDisabled);
                        }
                      },
                    ),
                  ),
                  if (status == "Allocated")
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.info, color: Colors.blue, size: 15),
                        onPressed: () {
                          showDetails(harvester['HARVEST_ID']);
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
