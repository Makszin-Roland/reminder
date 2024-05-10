import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard(this.reminder, {super.key});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.title),
                const SizedBox(height: 10,),
                Text(DateFormat('dd.MM.yyyy').format(reminder.valability)),
                const SizedBox(height: 10,),
                Text(reminder.notes)
              ],
            )
          ],
        ),
      ),
    );
  }
}