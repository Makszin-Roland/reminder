import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder/models/reminder.dart';

class FireStoreService {
  
  static var user;
  static String uid = '';
  static var ref;
  // static var user = FirebaseAuth.instance.currentUser;
  // static String uid = user!.uid;
  // static String? email = user!.email;
  // static var ref = FirebaseFirestore.instance
  //   .collection(uid)
  //   .withConverter(
  //     fromFirestore: Reminder.fromFirestore, 
  //     toFirestore: (Reminder c, _) => c.toFirestore()
  //   );

  static void getData() {
    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    ref = FirebaseFirestore.instance
    .collection(uid)
    .withConverter(
      fromFirestore: Reminder.fromFirestore, 
      toFirestore: (Reminder c, _) => c.toFirestore()
    );
  }

  //add a new reminder
  static Future<void> addReminder(Reminder reminder) async {
    getData();
    await ref
      .doc(reminder.id)
      .set(reminder);
  }

   // get characters once
  static Future<QuerySnapshot<Reminder>> getRemindersOnce() {
    getData();
    return ref
      .get();
  }

  // update a character
  static Future<void> updateReminder(Reminder reminder) async {
    getData();
    await ref.doc(reminder.id).update({
      "title": reminder.title,
      "notes": reminder.notes,
      "valability": reminder.valability,
    });
    
  }

  // delete a character
  static Future<void> deleteReminder(Reminder reminder) async {
    getData();
    await ref.doc(reminder.id).delete();
  }
}