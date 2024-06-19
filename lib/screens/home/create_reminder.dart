import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/screens/home/home_screen.dart';
import 'package:reminder/services/reminder_store.dart';
import 'package:reminder/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import '../../utils/utils.dart';

var uuid = const Uuid();

class CreateNewReminder extends StatefulWidget {
  const CreateNewReminder({super.key});

  @override
  State<CreateNewReminder> createState() => _CreateNewReminderState();
}

class _CreateNewReminderState extends State<CreateNewReminder> {

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? pickedDate;
  final user = FirebaseAuth.instance.currentUser;
  PlatformFile? pickedfile;
  String _fileName = 'No file';
  File? fileToDisplay;
  FilePickerResult? result;
  bool isLoading = false;
  String _fileExtension = 'No file';

  @override
  void dispose() {
    
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  void addReminder() async {
    if (_titleController.text.trim().isEmpty) {
      Utils().errorDialog(context, 'Please enter a title');

      return;
    }

    if (_dateController.text.trim().isEmpty) {
      Utils().errorDialog(context, 'Please enter a date');

      return;
    }

    Provider.of<ReminderStore>(context, listen: false)
      .addReminder(Reminder(
        title: _titleController.text.trim(), 
        notes: _noteController.text.trim(), 
        valability: pickedDate!, 
        id: uuid.v4(),
        filename: _fileName,
      ), fileToDisplay
      );

      final reminderTitle = _titleController.text.trim();
      final reminderDate = pickedDate!;
      final fcmToken = await FirebaseMessaging.instance.getToken();

      print('fcmToken: $fcmToken');

      _saveReminderToFirestore(reminderTitle, reminderDate, fcmToken);
      

      Navigator.push(context, MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
        ));
  }

  void _saveReminderToFirestore(String title, DateTime date, String? fcmToken) {
    final reminderData = {
      'title': title,
      'valability': date,
      'userId': fcmToken,
    };

    FirebaseFirestore.instance.collection('reminders').add(reminderData);  

  }

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });  

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'img'],
        allowMultiple: false,
      );
      
      if(result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        _fileExtension = result!.files.first.extension!.toLowerCase();
      }

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          fileToDisplay = File(pickedImage.path);
          _fileName = pickedImage.name;
          _fileExtension = pickedImage.path.split('.').last.toLowerCase();
        });
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showFileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            color: AppColors.buttonColor,
            child: ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              textColor: Colors.black, //AppColors.buttonColor,
              iconColor: Colors.black, //AppColors.buttonColor,         
              onTap: () {
                Navigator.of(context).pop();
                pickImageFromGallery();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            color: AppColors.buttonColor,
            child: ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Pick from Files'),
              textColor: Colors.black,
              iconColor: Colors.black,
              onTap: () {
                Navigator.of(context).pop();
                pickFile();
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Reminder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:  InputDecoration(
                      icon: Icon(Icons.title_rounded, 
                        color: AppColors.buttonColor,
                      ),
                      label: const Text('Title')     
                    ),
                    style: const TextStyle(color: Colors.white),           
                  ), 
            
                  const SizedBox(height: 30,),
            
                  TextFormField(
                    controller: _noteController,
                    decoration:  InputDecoration(
                      icon: Icon(Icons.note,
                        color: AppColors.buttonColor,
                      ),
                      label: const Text('Note')     
                    ),
                    style: const TextStyle(color: Colors.white),           
                  ), 
            
                  const SizedBox(height: 30,),
            
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today, 
                        color: AppColors.buttonColor,
                      ),
                      labelText: 'Enter the date',
                    ), 
                    style: const TextStyle(color: Colors.white),   
                    onTap: () async {
                      pickedDate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950), 
                        lastDate: DateTime(2100),
                      );
            
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
                        });
                      }
                    },
                  ),
            
                  const SizedBox(height: 30,),
                  isLoading 
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                      onPressed: showFileOptions, 
                      icon: const Icon(Icons.attach_file), 
                      label: const Text('Choose file'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(185, 40),
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ), 
                      ),
                    ),
            
                  const SizedBox(height: 15,),
                    
                  if (_fileExtension == 'img' || _fileExtension == 'jpg' || _fileExtension == 'png')
                    GestureDetector(
                      onTap:() {
                        OpenFile.open(fileToDisplay?.path);
                      },
                      child: SizedBox(height: 150, width: 150, child: 
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.file(fileToDisplay!, fit: BoxFit.cover,)
                        ),
                      ),
                    ),
                  
                  if (_fileExtension == 'pdf')
                    GestureDetector(
                      onTap:() {
                        OpenFile.open(fileToDisplay?.path);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset('assets/img/pdf_black.png',
                          width: 150,
                          color: AppColors.buttonColor
                        ),
                      ),
                    ),
            
                  //const Expanded(child: SizedBox(height: 5,)),
            
                  ElevatedButton.icon(

                    icon: const Icon(Icons.add_circle),
                    label: const Text('Create reminder'),
                    style:  ElevatedButton.styleFrom(
                      fixedSize: const Size(185, 40),
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),  
                    ),
                    onPressed: addReminder, 
                  ),         
                ],
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}