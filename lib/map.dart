import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

List<Map<String, dynamic>> data = [
  {
    'id': '1',
    'position': const LatLng(20.07311519516119, -98.77893573584666),
    'assetPath': 'assets/sprite1.gif',
  },
  {
    'id': '2',
    'position': const LatLng(20.073085235710113, -98.77949712341139),
    'assetPath': 'assets/sprite2.gif',
  },
  {
    'id': '3',
    'position': const LatLng(20.073784242769754, -98.77948001517689),
    'assetPath': 'assets/sprite3.gif',
  },
  {
    'id': '4',
    'position': const LatLng(20.027047609904045, -98.8503693972475),
    'assetPath': 'assets/sprite5.gif',
  },
];

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String _imagePath = 'assets/whos.png';
  bool _capturado = false;
  double _leftImageX = 0;
  double _rightImageX =
      10; // ajusta este valor según la posición inicial de la imagen derecha

  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  Location _location = Location();

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(20.07289948696821, -98.77920193210772),
    zoom: 12.0,
  );

  @override
  void initState() {
    _generateMarker();
    super.initState();
    _getLocation();
  }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top side
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: _currentMapType,
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers.values.toSet(),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                      onPressed: _onMapType, // Call the _onMapType function
                      child: const Icon(Icons.map, size: 36),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom side
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue[50],
              child: Stack(
                children: [
                  _capturado
                      ? Center(
                          child: Text("Capturado!"),
                        )
                      : Container(),
                  Positioned(
                    top: 20, // ajusta este valor según la posición del botón
                    right: 10,
                    child: AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      top: 20,
                      right: _rightImageX,
                      child: SizedBox(
                        width: 100, // ancho de la imagen
                        height: 100, // alto de la imagen
                        child: Image.asset(_imagePath,
                            fit: BoxFit
                                .cover), // reemplaza con la ruta de la imagen derecha
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20, // ajusta este valor según la posición del botón
                    left: 10,
                    child: AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      top: 20,
                      left: _leftImageX,
                      child: SizedBox(
                        width: 100, // ancho de la imagen
                        height: 100, // alto de la imagen
                        child: Image.asset('assets/sprite4.gif',
                            fit: BoxFit
                                .cover), // reemplaza con la ruta de la imagen izquierda
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30, // ajusta este valor según la posición del botón
                    left: 70, // ajusta este valor según la posición del botón
                    child: ElevatedButton(
                      onPressed: _handleCaptureButtonPress,
                      child: Text("Capturar"),
                    ),
                  ),
                  Positioned(
                    bottom: 30, // ajusta este valor según la posición del botón
                    right: 70, // ajusta este valor según la posición del botón
                    child: ElevatedButton(
                      onPressed: _resetAnimation,
                      child: Text("Continuar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _generateMarker() async {
    await generatemarkers();
  }

  Future<void> generatemarkers() async {
    for (int i = 0; i < data.length; i++) {
      final imageSize = Size(100, 100); // Tamaño fijo del marcador (40x40)
      final imageConfig = ImageConfiguration(size: imageSize);
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        imageConfig,
        data[i]['assetPath'],
      ); // Calculate distance for the current marker
      final distanceToMarker = await calculateDistance(data[i]['position']);

      // Update marker infoWindow to display distance (optional)
      _markers[i.toString()] = Marker(
        markerId: MarkerId(i.toString()),
        position: data[i]['position'],
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: 'This is a marker ($distanceToMarker Km away)',
        ),
        onTap: () {
          if (distanceToMarker < 0.1) {
            // Check if distance is less than 100 meters
            // Add your desired onTap functionality for close markers here
            print('Marker $i tapped (within 100 meters)!');
            // Aquí reemplazas la imagen 'assets/whos.png' con la imagen del marcador clickeado
            setState(() {
              _rightImageX = 0;
              // Reemplaza la imagen 'assets/whos.png' con la imagen del marcador clickeado
              _imagePath = data[i]['assetPath'];
            });
          } else {
            print('Marker $i tapped (more than 100 meters away).');
          }
        },
      );
      setState(() {});
    }
  }

  Future<double> calculateDistance(LatLng markerPosition) async {
    // Initialize Location object
    final Location location = Location();

    // Check if location service is enabled
    if (!await location.serviceEnabled()) {
      await location.requestService();
    }

    // Get user's current location
    final LocationData? currentLocation = await location.getLocation();

    if (currentLocation != null) {
      // Calculate distance between current location and marker position
      final distanceInMeters = Geolocator.distanceBetween(
        currentLocation.latitude!,
        currentLocation.longitude!,
        markerPosition.latitude,
        markerPosition.longitude,
      );

      // Convert meters to kilometers (optional)
      final distanceInKm = distanceInMeters / 1000;

      return distanceInKm;
    } else {
      // Handle the case where currentLocation is null
      return 0.0; // or throw an exception, depending on your requirements
    }
  }

  // 9. Método para obtener la ubicación actual del usuario
  void _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // 10. Verificar si el servicio de ubicación está habilitado
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      // 11. Solicitar habilitar el servicio de ubicación
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // 12. Verificar si se tiene permiso para acceder a la ubicación
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // 13. Solicitar permiso para acceder a la ubicación
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // 14. Escuchar cambios en la ubicación del usuario
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _generateMarker();
        // 15. Actualizar la posición del marcador en el mapa
        _markers['current_location'] = Marker(
          markerId: MarkerId('current_location'),
          position:
              LatLng(currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet:
                'Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
      });
    });
  }

  void _handleCaptureButtonPress() {
    setState(() {
      _leftImageX =
          240; // ajusta este valor según la posición final de la imagen izquierda
      _capturado = true;
    });
  }

  void _resetAnimation() {
    setState(() {
      _leftImageX = 0;
      _capturado = false;
      _imagePath = 'assets/whos.png';
    });
  }
}
