import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokasi Saya',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const GeolocationScreen(),
    );
  }
}

class GeolocationScreen extends StatefulWidget {
  const GeolocationScreen({super.key});

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  
  String? _kecamatan;
  String? _kota;
  bool _isLoading = false;
  String? _errorMessage;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _kecamatan = null;
      _kota = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Layanan lokasi tidak aktif. Mohon aktifkan GPS.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak oleh pengguna.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak permanen. Anda harus mengubahnya di pengaturan aplikasi.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        LatLng location = LatLng(position.latitude, position.longitude);
        
        setState(() {
          _kecamatan = place.subLocality;
          _kota = place.subAdministrativeArea;
          _currentLocation = location;
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: location,
              infoWindow: InfoWindow(
                title: _kota,
                snippet: _kecamatan,
              ),
            ),
          };
        });

        // Animasi kamera ke lokasi dengan delay untuk memastikan map sudah loaded
        Future.delayed(const Duration(milliseconds: 500), () async {
          if (_mapController.isCompleted) {
            final GoogleMapController controller = await _mapController.future;
            await controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: location,
                  zoom: 15,
                ),
              ),
            );
          }
        });
      } else {
        throw Exception('Tidak dapat menemukan informasi alamat.');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cek Lokasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _currentLocation != null
                ? GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 15,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Tekan tombol untuk menampilkan peta'),
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            )
                          : (_kecamatan == null && _kota == null)
                              ? const Text(
                                  'Tekan tombol untuk menampilkan lokasi.',
                                  textAlign: TextAlign.center,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Kelurahan/Kecamatan: $_kecamatan',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Kota: $_kota',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _getLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5.0,
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'TAMPILKAN LOKASI SAAT INI',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}