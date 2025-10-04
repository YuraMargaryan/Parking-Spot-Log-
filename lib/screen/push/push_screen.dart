import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'notification_service.dart';
import 'notification_model.dart';
import 'notification_storage_service.dart';
import 'notifications_list_screen.dart';

@RoutePage()
class PushScreen extends StatefulWidget {
  const PushScreen({super.key});

  @override
  State<PushScreen> createState() => _PushScreenState();
}

class _PushScreenState extends State<PushScreen> {
  final NotificationServiceIOS _notificationService = NotificationServiceIOS();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  String _title = 'Parking Reminder';
  String _body = 'Dont forget to check the parking spot.';

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.init();
  }

  Future<void> _selectDate() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            ),
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedTime = newDateTime;
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleNotification() async {
    try {
      final DateTime scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Create notification model
      final notification = NotificationModel(
        id: notificationId,
        title: _title,
        body: _body,
        scheduledDateTime: scheduledDateTime,
        createdAt: DateTime.now(),
      );

      // Schedule notification in system
      await _notificationService.scheduleAt(
        id: notificationId,
        title: _title,
        body: _body,
        dateTime: scheduledDateTime,
      );

      // Save to local storage
      await NotificationStorageService.saveNotification(notification);

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('✅ Success'),
            content: Text('Notification scheduled for ${_formatDateTime(scheduledDateTime)}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('❌ Error'),
            content: Text('Failed to schedule notification: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }


  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '🔔 Parking Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CupertinoColors.systemYellow,
                CupertinoColors.systemOrange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemYellow.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              CupertinoIcons.list_bullet,
              color: CupertinoColors.white,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const NotificationsListScreen(),
                ),
              );
            },
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
           color: CupertinoColors.white
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Beautiful parking section header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CupertinoColors.systemYellow,
                        CupertinoColors.systemOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemYellow.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: CupertinoColors.systemOrange.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          CupertinoIcons.car_fill,
                          color: CupertinoColors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parking Reminder Setup',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: CupertinoColors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Create a personal parking reminder',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Beautiful field for title
                _buildBeautifulTextField(
                  label: '🚗 Reminder Title',
                  placeholder: 'Enter parking reminder title',
                  initialValue: _title,
                  onChanged: (value) => _title = value,
                  icon: CupertinoIcons.car_fill,
                ),
                
                const SizedBox(height: 20),
                
                // Beautiful field for text
                _buildBeautifulTextField(
                  label: '💬 Parking Message',
                  placeholder: 'Enter parking reminder text',
                  initialValue: _body,
                  onChanged: (value) => _body = value,
                  icon: CupertinoIcons.location_fill,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 30),
                
                // Beautiful time section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CupertinoColors.systemBackground.resolveFrom(context),
                        CupertinoColors.systemTeal.resolveFrom(context).withOpacity(0.02),
                        CupertinoColors.systemCyan.resolveFrom(context).withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemTeal.resolveFrom(context).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: CupertinoColors.systemCyan.resolveFrom(context).withOpacity(0.08),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                    border: Border.all(
                      color: CupertinoColors.systemTeal.resolveFrom(context).withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [CupertinoColors.systemTeal, CupertinoColors.systemCyan],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemTeal.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.clock_fill,
                              color: CupertinoColors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '⏰ Reminder Time',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: CupertinoColors.label,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Select date and time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Beautiful date and time selection buttons
                      _buildBeautifulDateTimeButton(
                        label: '📅 Date',
                        value: '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                        onTap: _selectDate,
                        icon: CupertinoIcons.calendar,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildBeautifulDateTimeButton(
                        label: '🕐 Time',
                        value: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                        onTap: _selectTime,
                        icon: CupertinoIcons.clock,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Beautiful action buttons
                Column(
                  children: [
                    // Main scheduling button
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            CupertinoColors.systemYellow,
                            CupertinoColors.systemOrange,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: CupertinoColors.systemOrange.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: CupertinoColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: const Icon(
                                CupertinoIcons.car_fill,
                                color: CupertinoColors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Schedule Parking Reminder',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        onPressed: _scheduleNotification,
                      ),
                    ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  Widget _buildBeautifulTextField({
    required String label,
    required String placeholder,
    required String initialValue,
    required Function(String) onChanged,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBackground.resolveFrom(context),
            CupertinoColors.systemBlue.resolveFrom(context).withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: CupertinoColors.systemBlue.resolveFrom(context).withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: CupertinoColors.systemBlue.resolveFrom(context).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [CupertinoColors.systemYellow, CupertinoColors.systemOrange],
                    ),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemYellow.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CupertinoTextField(
              placeholder: placeholder,
              controller: TextEditingController(text: initialValue),
              onChanged: onChanged,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemGrey6.resolveFrom(context),
                    CupertinoColors.systemGrey5.resolveFrom(context),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: CupertinoColors.systemBlue.resolveFrom(context).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              maxLines: maxLines,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeautifulDateTimeButton({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemGrey6.resolveFrom(context),
              CupertinoColors.systemGrey5.resolveFrom(context),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: CupertinoColors.systemPurple.resolveFrom(context).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [CupertinoColors.systemYellow, CupertinoColors.systemOrange],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemYellow.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.systemYellow,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: CupertinoColors.systemYellow,
              ),
            ),
          ],
        ),
      ),
      );
  }
}