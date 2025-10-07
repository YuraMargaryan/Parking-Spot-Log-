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
import 'package:parking_spot_log/screen/push/notification_service.dart';

// Helper methods for date and time pickers
Future<DateTime?> showCupertinoDatePicker({
  required BuildContext context,
  required DateTime initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) async {
  DateTime selectedDate = initialDateTime;
  
  // Исправляем проблему с миллисекундами
  DateTime effectiveMinimumDate = minimumDate ?? DateTime(1900);
  DateTime effectiveInitialDateTime = initialDateTime;
  
  if (effectiveInitialDateTime.isBefore(effectiveMinimumDate)) {
    effectiveInitialDateTime = effectiveMinimumDate;
  }
  
  final result = await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (context) => Container(
      height: 350,
      color: CupertinoColors.systemBackground,
      child: Column(
        children: [
          Container(
            height: 50,
            color: CupertinoColors.systemGrey6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: effectiveInitialDateTime,
              minimumDate: minimumDate,
              maximumDate: maximumDate,
              onDateTimeChanged: (date) {
                selectedDate = date;
              },
            ),
          ),
        ],
      ),
    ),
  );
  
  return result;
}

Future<DateTime?> showCupertinoTimePicker({
  required BuildContext context,
  required DateTime initialDateTime,
}) async {
  DateTime selectedTime = initialDateTime;
  
  final result = await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (context) => Container(
      height: 350,
      color: CupertinoColors.systemBackground,
      child: Column(
        children: [
          Container(
            height: 50,
            color: CupertinoColors.systemGrey6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(selectedTime),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: initialDateTime,
              onDateTimeChanged: (time) {
                selectedTime = time;
              },
            ),
          ),
        ],
      ),
    ),
  );
  
  return result;
}

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
    final reminderMessageController = TextEditingController();
    DateTime? selectedReminderDateTime;
    bool isReminderEnabled = false;

    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: const Text('🚗 Add Parking Spot'),
          content: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 16),
                // Переключатель напоминания
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.bell_fill,
                      color: CupertinoColors.systemYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Set Reminder'),
                    const Spacer(),
                    CupertinoSwitch(
                      value: isReminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          isReminderEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                if (isReminderEnabled) ...[
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: reminderMessageController,
                    placeholder: 'Reminder message (optional)',
                    padding: const EdgeInsets.all(12),
                  ),
                  const SizedBox(height: 12),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final now = DateTime.now();
                      final selectedDate = await showCupertinoDatePicker(
                        context: context,
                        initialDateTime: now.add(const Duration(hours: 1)),
                        minimumDate: now,
                        maximumDate: now.add(const Duration(days: 365)),
                      );
                      if (selectedDate != null) {
                        final selectedTime = await showCupertinoTimePicker(
                          context: context,
                          initialDateTime: selectedDate,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            selectedReminderDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CupertinoColors.systemYellow.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        selectedReminderDateTime != null
                            ? 'Reminder: ${selectedReminderDateTime!.day}/${selectedReminderDateTime!.month}/${selectedReminderDateTime!.year} at ${selectedReminderDateTime!.hour.toString().padLeft(2, '0')}:${selectedReminderDateTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select reminder date & time',
                        style: const TextStyle(
                          color: CupertinoColors.systemYellow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
                    isReminderEnabled ? selectedReminderDateTime : null,
                    isReminderEnabled ? reminderMessageController.text : null,
                    isReminderEnabled,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Save place to database
  Future<void> _savePlace(String name, String address, double latitude, double longitude, DateTime? reminderDateTime, String? reminderMessage, bool isReminderActive) async {
    try {
      final placeId = await widget.db.into(widget.db.tableMap).insert(
        TableMapCompanion.insert(
          name: drift.Value(name),
          address: address,
          latitude: latitude,
          longitude: longitude,
          reminderDateTime: drift.Value(reminderDateTime),
          reminderMessage: drift.Value(reminderMessage),
          isReminderActive: drift.Value(isReminderActive),
        ),
      );
      
      // Если напоминание активно, планируем уведомление
      if (isReminderActive && reminderDateTime != null) {
        await _scheduleReminderNotification(placeId, name, reminderMessage ?? 'Reminder for parking spot: $name', reminderDateTime);
      }
      
      await _loadSavedPlaces(); // Reload markers
    } catch (e) {
      print('Error saving place: $e');
    }
  }

  // Schedule reminder notification
  Future<void> _scheduleReminderNotification(int placeId, String placeName, String message, DateTime reminderDateTime) async {
    try {
      final notificationService = NotificationServiceIOS();
      await notificationService.scheduleAt(
        id: placeId,
        title: '🚗 Parking Spot Reminder',
        body: message,
        dateTime: reminderDateTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
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
            if (place.isReminderActive && place.reminderDateTime != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupertinoColors.systemYellow.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.bell_fill,
                          color: CupertinoColors.systemYellow,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Reminder Active',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${place.reminderDateTime!.day}/${place.reminderDateTime!.month}/${place.reminderDateTime!.year}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Time: ${place.reminderDateTime!.hour.toString().padLeft(2, '0')}:${place.reminderDateTime!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (place.reminderMessage != null && place.reminderMessage!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Message: ${place.reminderMessage}',
                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Open in Maps'),
            onPressed: () => _openInMaps(place.latitude, place.longitude),
          ),
          if (place.isReminderActive) ...[
            CupertinoDialogAction(
              child: const Text('Edit Reminder'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditReminderDialog(place);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel Reminder'),
              onPressed: () async {
                try {
                  await widget.db.updateMapReminder(place.id, null, null, false);
                  final notificationService = NotificationServiceIOS();
                  await notificationService.cancel(place.id);
                  await _loadSavedPlaces();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error canceling reminder: $e');
                }
              },
            ),
          ] else ...[
            CupertinoDialogAction(
              child: const Text('Set Reminder'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditReminderDialog(place);
              },
            ),
          ],
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () async {
              try {
                // Отменяем уведомление при удалении места
                if (place.isReminderActive) {
                  final notificationService = NotificationServiceIOS();
                  await notificationService.cancel(place.id);
                }
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

  // Show edit reminder dialog
  void _showEditReminderDialog(TableMapData place) {
    final reminderMessageController = TextEditingController(text: place.reminderMessage ?? '');
    DateTime? selectedReminderDateTime = place.reminderDateTime;
    bool isReminderEnabled = place.isReminderActive;

    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: Text('🔔 Reminder for ${place.name ?? 'Place'}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Переключатель напоминания
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.bell_fill,
                      color: CupertinoColors.systemYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Enable Reminder'),
                    const Spacer(),
                    CupertinoSwitch(
                      value: isReminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          isReminderEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                if (isReminderEnabled) ...[
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: reminderMessageController,
                    placeholder: 'Reminder message (optional)',
                    padding: const EdgeInsets.all(12),
                  ),
                  const SizedBox(height: 12),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final now = DateTime.now();
                      final selectedDate = await showCupertinoDatePicker(
                        context: context,
                        initialDateTime: selectedReminderDateTime ?? now.add(const Duration(hours: 1)),
                        minimumDate: now,
                        maximumDate: now.add(const Duration(days: 365)),
                      );
                      if (selectedDate != null) {
                        final selectedTime = await showCupertinoTimePicker(
                          context: context,
                          initialDateTime: selectedReminderDateTime ?? selectedDate,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            selectedReminderDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CupertinoColors.systemYellow.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        selectedReminderDateTime != null
                            ? 'Reminder: ${selectedReminderDateTime!.day}/${selectedReminderDateTime!.month}/${selectedReminderDateTime!.year} at ${selectedReminderDateTime!.hour.toString().padLeft(2, '0')}:${selectedReminderDateTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select reminder date & time',
                        style: const TextStyle(
                          color: CupertinoColors.systemYellow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
                try {
                  final notificationService = NotificationServiceIOS();
                  
                  // Отменяем старое уведомление
                  await notificationService.cancel(place.id);
                  
                  // Обновляем напоминание в базе данных
                  await widget.db.updateMapReminder(
                    place.id,
                    isReminderEnabled ? selectedReminderDateTime : null,
                    isReminderEnabled ? reminderMessageController.text : null,
                    isReminderEnabled,
                  );
                  
                  // Если напоминание активно, планируем новое уведомление
                  if (isReminderEnabled && selectedReminderDateTime != null) {
                    await _scheduleReminderNotification(
                      place.id,
                      place.name ?? 'Place',
                      reminderMessageController.text.isNotEmpty 
                          ? reminderMessageController.text 
                          : 'Reminder for parking spot: ${place.name}',
                      selectedReminderDateTime!,
                    );
                  }
                  
                  await _loadSavedPlaces();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error updating reminder: $e');
                }
              },
            ),
          ],
        ),
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