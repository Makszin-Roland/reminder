import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/services/firestore_service.dart';
import 'package:reminder/services/reminder_service.dart';

class ReminderStore extends ChangeNotifier {
  List<Reminder> _reminders = [];

  get reminders => _reminders;

  //add reminder
  void addReminder(Reminder reminder, File? file) async {
    await FireStoreService.addReminder(reminder, file);
    notifyListeners();
  }

  //save reminder
  Future<void> saveReminder(Reminder reminder) async {
    await FireStoreService.updateReminder(reminder);
    return;
  }

  //remove reminder
  void removeReminder(Reminder reminder) async {
    await FireStoreService.deleteReminder(reminder);
    _reminders.remove(reminder);
    notifyListeners();
  }

  //initially fetch reminders
  Future<void> fetchRemindersOnce() async {
      final snapshot = await FireStoreService.getRemindersOnce();
      
      for(var doc in snapshot.docs) {
        bool exists = _reminders.any((reminder) => reminder.id == doc.data().id);

        if(!exists) {  
          _reminders.add(doc.data());
          _reminders.sort(((a, b) => a.valability.compareTo(b.valability)));

          if (doc.data().filename != 'No file') {
            Future.delayed(const Duration(seconds: 1), () async {
              await updateReminderList(_reminders, doc.id,); 
              notifyListeners(); 
            });
          }

          ReminderService.handleScheduledNotification({'reminderId': doc.data().id});
        }        
      } 

      notifyListeners(); 
  }

  Future<void> updateReminderList(List<Reminder> list, String id) async {
    for (var item in list) {
      try {
        final url = await FireStoreService.getFiles(item.id, item.filename!);
        if (item.id == id) {
          item.fileUrl = url;
          await FireStoreService.updateReminderfileUrl(item.id, item.fileUrl!);
          break;
        }
      } catch (e) {
        item.fileUrl = null; // or handle this case as per your logic
      }
    }
  }
  
}