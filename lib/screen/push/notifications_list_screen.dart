import 'package:flutter/cupertino.dart';
import 'notification_model.dart';
import 'notification_storage_service.dart';
import 'notification_service.dart';

class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  final NotificationServiceIOS _notificationService = NotificationServiceIOS();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    
    final notifications = await NotificationStorageService.getNotifications();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    try {
      // Cancel notification in system
      await _notificationService.cancel(notification.id);
      
      // Remove from local storage
      await NotificationStorageService.deleteNotification(notification.id);
      
      // Update list
      await _loadNotifications();
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('🗑️ Deleted'),
            content: const Text('Notification successfully deleted'),
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
            content: Text('Failed to delete notification: $e'),
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

  Future<void> _clearAllNotifications() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('⚠️ Confirmation'),
        content: const Text('Are you sure you want to delete all notifications?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete All'),
            onPressed: () async {
              Navigator.of(context).pop();
              await _performClearAll();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _performClearAll() async {
    try {
      // Cancel all notifications in system
      await _notificationService.cancelAll();
      
      // Clear local storage
      await NotificationStorageService.clearAllNotifications();
      
      // Update list
      await _loadNotifications();
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('🗑️ Cleared'),
            content: const Text('All notifications deleted'),
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
            content: Text('Failed to clear notifications: $e'),
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

  String _getTimeUntilNotification(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);
    
    if (difference.isNegative) {
      return 'Passed';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    if (days > 0) {
      return 'In $days d. $hours h.';
    } else if (hours > 0) {
      return 'In $hours h. $minutes min.';
    } else {
      return 'In $minutes min.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('📋 My Reminders'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        trailing: _notifications.isNotEmpty
            ? Container(
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
                    CupertinoIcons.trash,
                    color: CupertinoColors.white,
                    size: 18,
                  ),
                  onPressed: _clearAllNotifications,
                ),
              )
            : null,
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CupertinoColors.systemBackground.resolveFrom(context),
                CupertinoColors.systemGrey6.resolveFrom(context),
              ],
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationsList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CupertinoColors.systemYellow.withOpacity(0.1),
                    CupertinoColors.systemOrange.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: CupertinoColors.systemYellow.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                CupertinoIcons.car_fill,
                size: 60,
                color: CupertinoColors.systemYellow,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Reminders',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Create your first parking reminder\nin the "Reminders" section',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return CupertinoScrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final isPast = notification.isPast;
    final timeUntil = _getTimeUntilNotification(notification.scheduledDateTime);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isPast 
              ? CupertinoColors.systemRed.withOpacity(0.3)
              : CupertinoColors.systemYellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: isPast 
                          ? LinearGradient(
                              colors: [
                                CupertinoColors.systemRed,
                                CupertinoColors.systemRed.withOpacity(0.7),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                CupertinoColors.systemYellow,
                                CupertinoColors.systemOrange,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (isPast ? CupertinoColors.systemRed : CupertinoColors.systemYellow).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPast ? CupertinoIcons.clock : CupertinoIcons.car_fill,
                      color: CupertinoColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.trash,
                      color: CupertinoColors.systemRed,
                      size: 20,
                    ),
                    onPressed: () => _deleteNotification(notification),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: CupertinoColors.systemGrey.resolveFrom(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    notification.formattedDateTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: isPast 
                          ? LinearGradient(
                              colors: [
                                CupertinoColors.systemRed.withOpacity(0.1),
                                CupertinoColors.systemRed.withOpacity(0.05),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                CupertinoColors.systemYellow.withOpacity(0.1),
                                CupertinoColors.systemOrange.withOpacity(0.05),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isPast 
                            ? CupertinoColors.systemRed.withOpacity(0.2)
                            : CupertinoColors.systemYellow.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isPast ? 'Passed' : timeUntil,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPast 
                            ? CupertinoColors.systemRed
                            : CupertinoColors.systemYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onPressed: () {
          // Можно добавить детальный просмотр уведомления
        },
      ),
    );
  }
}
