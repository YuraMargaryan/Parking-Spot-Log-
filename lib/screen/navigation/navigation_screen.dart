import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parking_spot_log/core/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parking_spot_log/screen/navigation/saved_places_screen.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  final AppDatabase db;
  
  const MapScreen({super.key, required this.db});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  List<Marker> _markers = [];
  final LatLng _defaultLocation = const LatLng(40.1772, 44.5035); // Ереван
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadSavedPlaces();
    _getCurrentLocation();
  }

  // Load saved places from database
  Future<void> _loadSavedPlaces() async {
    try {
      final places = await widget.db.select(widget.db.tableMap).get();
      setState(() {
        _markers = places.map((place) => Marker(
          point: LatLng(place.latitude, place.longitude),
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () => _showPlaceDetails(place),
            child: const Icon(
                CupertinoIcons.car_fill,
                color: CupertinoColors.black,
                size: 24,
              ),
          ),
        )).toList();
      });
    } catch (e) {
      print('Error loading places: $e');
    }
  }



  

  // Get current user location
  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions
      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        _showLocationPermissionDialog();
        return;
      }

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      // Добавляем маркер местоположения пользователя
      _addUserLocationMarker();
      
    } catch (e) {
      print('Error getting location: $e');
      _showLocationErrorDialog();
    }
  }

  // Add user location marker
  void _addUserLocationMarker() {
    if (_userLocation != null) {
      final userMarker = Marker(
        point: _userLocation!,
        width: 40,
        height: 40,
        child:const Icon(
            CupertinoIcons.location_fill,
            color: CupertinoColors.systemGreen,
            size: 20,
          ),
      );
      
      setState(() {
        // Remove old user marker if exists
        _markers.removeWhere((marker) => 
          marker.child is Container && 
          (marker.child as Container).child is Icon &&
          ((marker.child as Container).child as Icon).icon == CupertinoIcons.person_fill
        );
        _markers.insert(0, userMarker); // Add to beginning of list
      });
    }
  }

  // Show location permission dialog
  void _showLocationPermissionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚗 Location Permission'),
        content: const Text('To show your location and parking spots, you need to allow access to location. Go to settings and allow access.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  // Show location service dialog
  void _showLocationServiceDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚗 Location Disabled'),
        content: const Text('To show your location and parking spots, you need to enable location in device settings.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Show location error dialog
  void _showLocationErrorDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚗 Location Error'),
        content: const Text('Could not determine your location. Check internet connection and permissions for finding parking spots.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Retry'),
            onPressed: () {
              Navigator.of(context).pop();
              _getCurrentLocation();
            },
          ),
        ],
      ),
    );
  }

  // Handle map tap
  void _onMapTap(LatLng latlng) {
    _showAddPlaceDialog(latlng);
  }

  // Show add place dialog
  void _showAddPlaceDialog(LatLng latlng) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚗 Add Parking Spot'),
        content: Column(
          children: [
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: nameController,
              placeholder: 'Parking spot name',
              padding: const EdgeInsets.all(12),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: addressController,
              placeholder: 'Address (optional)',
              padding: const EdgeInsets.all(12),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Save'),
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _savePlace(
                  nameController.text,
                  addressController.text,
                  latlng.latitude,
                  latlng.longitude,
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // Save place to database
  Future<void> _savePlace(String name, String address, double latitude, double longitude) async {
    try {
      await widget.db.into(widget.db.tableMap).insert(
        TableMapCompanion.insert(
          name: drift.Value(name),
          address: address,
          latitude: latitude,
          longitude: longitude,
        ),
      );
      await _loadSavedPlaces(); // Reload markers
    } catch (e) {
      print('Error saving place: $e');
    }
  }

  // Show place details
  void _showPlaceDetails(TableMapData place) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(place.name ?? 'Place'),
        content: Column(
          children: [
            const SizedBox(height: 16),
            Text('📍 ${place.address}'),
            const SizedBox(height: 8),
            Text('Coordinates: ${place.latitude.toStringAsFixed(6)}, ${place.longitude.toStringAsFixed(6)}'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Open in Maps'),
            onPressed: () => _openInMaps(place.latitude, place.longitude),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () async {
              try {
                await widget.db.deleteMap(place.id);
                await _loadSavedPlaces();
                Navigator.of(context).pop();
              } catch (e) {
                print('Error deleting place: $e');
              }
            },
          ),
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Open place in maps
  void _openInMaps(double latitude, double longitude) async {
    final url = 'https://maps.apple.com/?q=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // Show list of saved places
  void _showSavedPlaces() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SavedPlacesScreen(
          db: widget.db,
          onPlaceSelected: (place) {
            // Return to map and center on selected place
            Navigator.of(context).pop();
            _mapController.move(LatLng(place.latitude, place.longitude), 15);
          },
          onPlaceDeleted: () {
            // Update markers on map when place is deleted in list
            _loadSavedPlaces();
          },
        ),
      ),
    ).then((_) {
      // Update markers when returning from places list screen
      _loadSavedPlaces();
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '🚗 My Parking Spots',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: _showSavedPlaces,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemYellow,
                      CupertinoColors.systemOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemYellow.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.bookmark_fill,
                  color: CupertinoColors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      child: SizedBox.expand(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userLocation ?? _defaultLocation,
                initialZoom: 15,
                onTap: (tapPosition, latlng) => _onMapTap(latlng),
              ),
              children: [
                // Добавляем карту CartoDB (альтернатива OpenStreetMap)
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.parking_spot_log.app',
                  maxZoom: 18,
                  minZoom: 1,
                ),
                MarkerLayer(
                  markers: _markers,
                ),
                // Информационная панель
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.separator,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🚗 My Parking Spots on Map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap on map to add parking spot\nTap on marker to view details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '💾 Parking spots are saved in yellow icon',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.systemYellow,
                            ),
                          ),
                        ),
                        if (_userLocation != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '🟢 Your location is determined',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.systemGreen,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ]
            ),
            // Кнопка "Моё местоположение" в правом нижнем углу
            Positioned(
              right: 20,
              bottom: 100, // Поднял выше, чтобы не перекрывалась с навигацией
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: CupertinoColors.systemYellow,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(28),
                  onPressed: () {
                    if (_userLocation != null) {
                      _mapController.move(_userLocation!, 15);
                    } else {
                      _getCurrentLocation();
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.location_fill,
                    color: CupertinoColors.systemYellow,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}