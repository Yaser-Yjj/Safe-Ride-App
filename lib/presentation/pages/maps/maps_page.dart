import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        );

        if (mounted) {
          setState(() {
            currentPosition = pos;
            isLoading = false;
          });

          final GoogleMapController mapController =
              await _mapControllerCompleter.future;

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(pos.latitude, pos.longitude),
                zoom: 17,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          _showCustomSnackBar(context, "Error getting location: $e");
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showCustomSnackBar(
          context,
          "Permission denied for accessing location.",
        );
      }
    }
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: c.darkColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const SizedBox.shrink()
              : GoogleMap(
                onMapCreated: (controller) {
                  if (!_mapControllerCompleter.isCompleted) {
                    _mapControllerCompleter.complete(controller);
                  }
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentPosition?.latitude ?? 34.020882,
                    currentPosition?.longitude ?? -6.841650,
                  ),
                  zoom: 12,
                ),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),

          if (isLoading)
            Container(
              color: c.lightColor,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: c.darkColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
