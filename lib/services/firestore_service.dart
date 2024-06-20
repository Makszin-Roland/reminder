import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:reminder/models/reminder.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreService {
  
  static var user;
  static String uid = '';
  static var ref;
  static var fileRef;

  static void getData() {
    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    ref = FirebaseFirestore.instance
    .collection(uid)
    .withConverter(
      fromFirestore: Reminder.fromFirestore, 
      toFirestore: (Reminder c, _) => c.toFirestore()
    );

    fileRef = FirebaseStorage.instance.ref(uid);
  }

  //add a new reminder
  static Future<void> addReminder(Reminder reminder, File ? file) async {
    getData();
    await ref
      .doc(reminder.id)
      .set(reminder);

    if (file != null) {
      uploadFile(reminder.id, reminder.filename!, file);
    }
  }

   // get reminder once
  static Future<QuerySnapshot<Reminder>> getRemindersOnce() {
    getData();
    return ref
      .get();
  }

  // update a reminder
  static Future<void> updateReminder(Reminder reminder) async {
    getData();
    await ref.doc(reminder.id).update({
      "title": reminder.title,
      "notes": reminder.notes,
      "valability": reminder.valability,
      "filename": reminder.filename,
      "fileurl": reminder.fileUrl
    });
  }

  static Future<void> updateReminderfileUrl(String id, String url) async {
    getData();
    await ref.doc(id).update({
      "fileurl": url
    });
  }

  // delete a reminder
  static Future<void> deleteReminder(Reminder reminder) async {
    getData();
    await ref.doc(reminder.id).delete();

    ref = FirebaseStorage.instance.ref().child('$uid/${reminder.id}/${reminder.filename}');

    await ref.delete();
  }

  //upload file
  static UploadTask? uploadFile(String reminderID, String reminderFilename, File file) {
    try {
      getData();
      ref = FirebaseStorage.instance.ref('$uid/$reminderID/$reminderFilename');
      
      return ref.putFile(file);
  } on FirebaseException catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return null;
  }
  }

  static Future<String> getFiles(String reminderID, String reminderFilename) async {
    try {
      getData();
      final url = await fileRef.child('/$reminderID/$reminderFilename').getDownloadURL();
      return url;
    } on Exception catch (e) {
      throw FirebaseException(
        plugin: 'FirebaseStorage',
        message: 'No object exists at the desired reference. $e',
      );
    }
  }



}