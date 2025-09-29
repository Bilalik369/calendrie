import 'package:flutter/material.dart';
import '../models/notification_models.dart';




class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);


  @override

  State<NotificationsScreen> createState() => _NotificationsScreenState(); 
}

class _NotificationsScreenState extends State<NotificationsScreen>{
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
  @override 
  

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios , color: Colors.black, size: 20),
          onPressed: ()=> Navigator.of(context).pop(),
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

    );
  }
  
}