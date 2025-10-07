import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/core/database/database.dart';
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

class SavedPlacesScreen extends StatefulWidget {
  final AppDatabase db;
  final Function(TableMapData) onPlaceSelected;
  final VoidCallback? onPlaceDeleted;
  
  const SavedPlacesScreen({
    super.key, 
    required this.db,
    required this.onPlaceSelected,
    this.onPlaceDeleted,
  });

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  List<TableMapData> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await widget.db.select(widget.db.tableMap).get();
      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading places: $e');
    }
  }

  Future<void> _deletePlace(TableMapData place) async {
    try {
      // Отменяем уведомление при удалении места
      if (place.isReminderActive) {
        final notificationService = NotificationServiceIOS();
        await notificationService.cancel(place.id);
      }
      
      await widget.db.deleteMap(place.id);
      await _loadPlaces();
      // Notify parent screen about deletion
      if (widget.onPlaceDeleted != null) {
        widget.onPlaceDeleted!();
      }
    } catch (e) {
      print('Error deleting place: $e');
    }
  }

  void _showDeleteConfirmation(TableMapData place) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗑️ Delete Parking Spot'),
        content: Text('Are you sure you want to delete parking spot "${place.name ?? 'Unnamed'}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _deletePlace(place);
            },
          ),
        ],
      ),
    );
  }

  // Show reminder management dialog
  void _showReminderDialog(TableMapData place) {
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
                    await notificationService.scheduleAt(
                      id: place.id,
                      title: '🚗 Parking Spot Reminder',
                      body: reminderMessageController.text.isNotEmpty 
                          ? reminderMessageController.text 
                          : 'Reminder for parking spot: ${place.name}',
                      dateTime: selectedReminderDateTime!,
                    );
                  }
                  
                  await _loadPlaces();
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          '🚗 My Parking Spots',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : _places.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.car_fill,
                        size: 64,
                        color: CupertinoColors.systemYellow,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Saved Parking Spots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add parking spots on the map',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    final place = _places[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CupertinoColors.systemYellow.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.onPlaceSelected(place),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              // Иконка места парковки
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CupertinoColors.systemYellow,
                                      CupertinoColors.systemOrange,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.systemYellow.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  CupertinoIcons.car_fill,
                                  color: CupertinoColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Информация о месте
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name ?? 'Unnamed Parking Spot',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.label,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      place.address,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Coordinates: ${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.tertiaryLabel,
                                      ),
                                    ),
                                    if (place.isReminderActive && place.reminderDateTime != null) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.bell_fill,
                                            color: CupertinoColors.systemYellow,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Reminder: ${place.reminderDateTime!.day}/${place.reminderDateTime!.month}/${place.reminderDateTime!.year} at ${place.reminderDateTime!.hour.toString().padLeft(2, '0')}:${place.reminderDateTime!.minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: CupertinoColors.systemYellow,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Кнопка навигации
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => widget.onPlaceSelected(place),
                                child: Container(
                                  width: 30,
                                  height: 30,
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
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.location_fill,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Кнопка управления напоминанием
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => _showReminderDialog(place),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: place.isReminderActive 
                                        ? CupertinoColors.systemYellow 
                                        : CupertinoColors.systemGrey3,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.bell_fill,
                                    color: place.isReminderActive 
                                        ? CupertinoColors.white 
                                        : CupertinoColors.systemGrey,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Кнопка удаления
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => _showDeleteConfirmation(place),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemRed,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
