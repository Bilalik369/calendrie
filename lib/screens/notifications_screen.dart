import 'package:flutter/material.dart';
import '../models/notification_models.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationData> notifications = [
    NotificationData(
      id: '1',
      title: 'La campagne « Soldes d\'été » a commencé',
      subtitle: 'La campagne a commencé',
      timestamp: 'il y a 1 h',
      type: NotificationType.campaign,
    ),
    NotificationData(
      id: '2',
      title: 'Nouvelle mission disponible dans votre région',
      subtitle: 'Nouvelle mission disponible',
      timestamp: 'il y a 2 heures',
      type: NotificationType.mission,
    ),
    NotificationData(
      id: '3',
      title: 'Preuve d\'installation pour la campagne « Back to School » validée',
      subtitle: 'Preuve validée',
      timestamp: 'il y a 3 heures',
      type: NotificationType.validation,
    ),
    NotificationData(
      id: '4',
      title: 'Paiement confirmé pour la campagne « Winter Wonderland »',
      subtitle: 'Paiement confirmé',
      timestamp: 'il y a 4 heures',
      type: NotificationType.payment,
    ),
    NotificationData(
      id: '5',
      title: 'La campagne « Spring Fling » est terminée',
      subtitle: 'Campagne terminée',
      timestamp: 'il y a 5 heures',
      type: NotificationType.campaign,
    ),
    NotificationData(
      id: '6',
      title: 'La preuve d\'installation de la campagne « Holiday Cheer » a été rejetée',
      subtitle: 'Preuve rejetée',
      timestamp: 'il y a 6 heures',
      type: NotificationType.rejection,
    ),
    NotificationData(
      id: '7',
      title: 'Nouvelle mission disponible dans votre région',
      subtitle: 'Nouvelle mission disponible',
      timestamp: 'il y a 7 heures',
      type: NotificationType.mission,
    ),
  ];

  Widget _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.campaign:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF2196F3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.campaign,
            color: Colors.white,
            size: 20,
          ),
        );
      case NotificationType.mission:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.assignment,
            color: Colors.blue,
            size: 20,
          ),
        );
      case NotificationType.validation:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
        );
      case NotificationType.payment:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.payment,
            color: Colors.white,
            size: 20,
          ),
        );
      case NotificationType.rejection:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _getNotificationIcon(notification.type),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  notification.timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}