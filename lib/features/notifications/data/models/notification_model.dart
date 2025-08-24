class NotificationModel {
  final String title;
  final DateTime timestamp;
  final String type;
  final bool isRead;

  const NotificationModel({
    required this.title,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  static List<NotificationModel> getMockNotifications() {
    return [
      NotificationModel(
        title: 'Your appointment with Dr. Sarah has been confirmed',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'appointment',
        isRead: false,
      ),
      NotificationModel(
        title: 'Reminder: Appointment with Dr. John tomorrow',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: 'appointment',
        isRead: true,
      ),
      NotificationModel(
        title: 'Welcome to Shifaa App!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: 'general',
        isRead: false,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
      NotificationModel(
        title: 'Your prescription is ready',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: 'general',
        isRead: true,
      ),
    ];
  }
}
