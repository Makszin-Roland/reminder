import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/main.dart';
import 'package:reminder/screens/home/create_reminder.dart';
import 'package:reminder/screens/home/reminder_card.dart';
import 'package:reminder/services/reminder_store.dart';
import 'package:reminder/theme.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    Provider.of<ReminderStore>(context, listen: false)
      .fetchRemindersOnce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primaryAccent,
        surfaceTintColor: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
              ),
              child: Column(
                children: [
                  const Text('Your reminder'),
                  const SizedBox(height: 10,),
                  Text(user.email!)
                ],
              )
            ),
            
            ListTile(
              
              leading: const Icon(
                Icons.add,
                color: Colors.white,
                ),
              title: const Text(
                'Create new reminder',
                style: TextStyle(color: Colors.white)
                ),
              onTap:() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx) => const CreateNewReminder(),
                ));
              },
            ),

            ListTile(
              
              leading: const Icon(
                Icons.refresh,
                color: Colors.white,
                ),
              title: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white)
                ),
              onTap:() {
                setState(() {
                  Provider.of<ReminderStore>(context, listen: false).fetchRemindersOnce();
                });
              },
            ),

            const Divider(color: Colors.white),

            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.white)
                ),
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
                ),
              onTap: () { 
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(
                  builder: (ctx) => const MainPage(),
                ));
              }
            ),
          ],

        )
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ReminderStore>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.reminders.length,
                    itemBuilder: (_, index) {
                      return Dismissible(
                        key: ValueKey(value.reminders[index].id),
                        onDismissed: (direction) {
                          Provider.of<ReminderStore>(context, listen: false)
                            .removeReminder(value.reminders[index]);
                        },
                        child: ReminderCard(value.reminders[index]),
                        
                      );
                    }
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}