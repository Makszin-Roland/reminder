import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //initialization
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  //setting timezone
  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.getLocation('Europe/Bucharest'); 
    return tz.TZDateTime.from(dateTime, location);
  }

  //schedule the notification
  static Future<void> scheduleNotification(
    int id, DateTime scheduledDate, String title, String body) async {
    
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final tzScheduledDate = _convertToTZDateTime(scheduledDate);

     if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      if (kDebugMode) {
        print('Scheduled date $tzScheduledDate is in the past. Skipping notification.');
      }
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    if (kDebugMode) {
      print('Scheduling notification: $id at $scheduledDate with title: $title and body: $body');
    }
  }

  static Future<void> handleScheduledNotification(Map<String, dynamic>? inputData) async {
    final reminderId = inputData?['reminderId'];
    User? user;
    String uid = '';
    if (reminderId == null) return;

    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    final reminderDoc = await FirebaseFirestore.instance.collection(uid).doc(reminderId).get();
    if (!reminderDoc.exists) return;

    final reminderData = reminderDoc.data();
    if (reminderData == null) return;

    final reminderTitle = reminderData['title'];
    final reminderDate = reminderData['valability'].toDate();

    final notificationDate1 = reminderDate.subtract(const Duration(hours: 12));
    final notificationDate7 = reminderDate.subtract(const Duration(days: 6, hours: 12));

    await scheduleNotification(reminderId.hashCode + 1, notificationDate1, reminderTitle, 'You have 1 day until the event');
    await scheduleNotification(reminderId.hashCode + 7, notificationDate7, reminderTitle, 'You have 7 day until the event');
  }
}
