import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/screens/home/home_screen.dart';
import 'package:reminder/services/reminder_store.dart';
import 'package:reminder/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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

  @override
  void dispose() {
    
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  void addReminder () {
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
      )
      );

      Navigator.push(context, MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Reminder'),
      ),
      body: Container(
        child: Padding(
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

              const Expanded(child: SizedBox(height: 5,)),

              ElevatedButton.icon(
                icon: const Icon(Icons.add_circle),
                label: const Text('Create reminder'),
                style:  ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),  
                ),
                onPressed: addReminder, 
              ),         
            ],
            
          ),
        ),
          
      ),
    );
  }
}