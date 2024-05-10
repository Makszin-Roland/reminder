import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {

  Reminder(
      
      {required this.title, required this.notes, required this.valability, required this.id}
    );

  final String title;
  final String notes;
  final DateTime valability;
  final String id;

  
  //reminder to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'notes': notes,
      'valability': valability,
    };
  }

  //reminder from firestore
  factory Reminder.fromFirestore (
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    
    final data = snapshot.data()!;

    Reminder reminder = Reminder(
      title: data['title'], 
      notes: data['notes'], 
      valability: data['valability'].toDate(), 
      id: snapshot.id,
    );

    return reminder;
  }


}