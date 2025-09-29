class NotificationData {
  final String id; 
  final String title;
  final String subtitle;
  final String timestamp;
  final NotificationType type;
  final bool isRead;


  NotificationData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
    this.isRead = false 
  });
}
enum NotificationType {
   campaign,
  mission,
  validation,
  payment,
  rejection,
}


class NotificationConstants {
  static const Map<NotificationType , String> typeLabels = {
    NotificationType.campaign :  "campaign",
    NotificationType.mission : "mission",
    NotificationType.validation : "validation",
    NotificationType.payment : "payment",
    NotificationType.rejection : "rejection",

  };
}