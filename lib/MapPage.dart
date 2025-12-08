import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final double farmerLatitude;
  final double farmerLongitude;
  final double predefinedLatitude = 19.1669167; // Replace with your predefined latitude
  final double predefinedLongitude = 73.9518611; // Replace with your predefined longitude

  MapPage({
    Key? key,
    required this.farmerLatitude,
    required this.farmerLongitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> polylineCoordinates = [];
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _getDirections();
  }

  // Function to fetch directions
  Future<void> _getDirections() async {
    String googleAPIKey = ''; // Replace with your Google Directions API key
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.predefinedLatitude},${widget.predefinedLongitude}&destination=${widget.farmerLatitude},${widget.farmerLongitude}&key=$googleAPIKey';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'OK') {
      var route = jsonData['routes'][0];
      var polyline = route['overview_polyline']['points'];
      polylineCoordinates = _decodePolyline(polyline);

      setState(() {}); // Update UI after fetching the polyline
    } else {
      print("Error fetching directions: ${jsonData['status']}");
    }
  }

  // Function to decode polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      polylineCoordinates.add(point);
    }
    return polylineCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.farmerLatitude, widget.farmerLongitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId('farmer'),
            position: LatLng(widget.farmerLatitude, widget.farmerLongitude),
            infoWindow: InfoWindow(title: 'Farmer Location'),
          ),
          Marker(
            markerId: MarkerId('predefined'),
            position: LatLng(widget.predefinedLatitude, widget.predefinedLongitude),
            infoWindow: InfoWindow(title: 'Mill Location'),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
