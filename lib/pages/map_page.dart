import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? userLocation;
  LatLng? storeLocation;
  GoogleMapController? mapController;

  Set<Polyline> routePolylines = {};
  final String googleApiKey = "";


  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchStoreLocation();
  }

  Future<void> fetchUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    }
    if (storeLocation != null) {
      fetchRoute();
    }
  }

  Future<void> fetchStoreLocation() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('tienda').doc('principal').get();
    final data = snapshot.data();

    if (data != null && data['tienda'] != null) {
      final geoPoint = data['tienda'] as GeoPoint;
      if (mounted) {
        setState(() {
          storeLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
        });
      }
      if (userLocation != null) {
        fetchRoute();
      }
    }
  }

  Future<void> fetchRoute() async {
  // Verificar que userLocation y storeLocation no sean null
  if (userLocation == null || storeLocation == null) {
    print("Ubicación del usuario o de la tienda es nula.");
    return;
  }

  final origin = "${userLocation!.latitude},${userLocation!.longitude}";
  final destination = "${storeLocation!.latitude},${storeLocation!.longitude}";

  final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$googleApiKey&mode=driving");

  print("🛰️ Solicitando ruta a la URL:");
  print(url.toString());

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final routes = data["routes"];
    if (routes == null || routes.isEmpty) {
      print("❌ No se encontraron rutas.");
      print("📦 Respuesta del servidor:");
      print(response.body);
      return;
    }

    final points = routes[0]["overview_polyline"]["points"];
    final route = decodePolyline(points);
    if (mounted) {
      setState(() {
        routePolylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: route,
          ),
        };
      });
    }
  } else {
    print("❌ Error HTTP ${response.statusCode}");
    print(response.body);
  }
}



  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cómo llegar a la tienda")),
      body: (userLocation == null || storeLocation == null)
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 14.3,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('user'),
                  position: userLocation!,
                  infoWindow: const InfoWindow(title: 'Tu ubicación'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
                Marker(
                  markerId: const MarkerId('store'),
                  position: storeLocation!,
                  infoWindow: const InfoWindow(title: 'Tienda Anicom'),
                ),
              },
              polylines: routePolylines,
              onMapCreated: (controller) => mapController = controller,
            ),
    );
  }
}
