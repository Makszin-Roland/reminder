import 'package:flutter/material.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/services/firestore_service.dart';

class ReminderStore extends ChangeNotifier {
  List<Reminder> _reminders = [];

  get reminders => _reminders;

  //add reminder
  void addReminder(Reminder reminder) async {
    await FireStoreService.addReminder(reminder);

    //_reminders.add(reminder);
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
  void fetchRemindersOnce() async {
      

      final snapshot = await FireStoreService.getRemindersOnce();

      _reminders = [];

      for(var doc in snapshot.docs) {
        _reminders.add(doc.data());
        _reminders.sort(((a, b) => a.valability.compareTo(b.valability)));
      }

      notifyListeners();
    
  }
  
}