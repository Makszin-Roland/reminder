import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {

  Reminder(
    { required this.title, 
      required this.notes, 
      required this.valability, 
      required this.id, 
      this.filename,
      this.fileUrl
    }
    );

  final String title;
  final String notes;
  final DateTime valability;
  final String id;
  final String? filename;
  late String? fileUrl;

  
  //reminder to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'notes': notes,
      'valability': valability,
      'filename': filename,
      'fileurl': fileUrl
    };
  }

  //reminder from firestore
  factory Reminder.fromFirestore (
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    
    final data = snapshot.data()!;

    Reminder reminder = Reminder(
      fileUrl: data['fileUrl'],
      filename: data['filename'],
      title: data['title'], 
      notes: data['notes'], 
      valability: data['valability'].toDate(), 
      id: snapshot.id, 
    );

    return reminder;
  }


}