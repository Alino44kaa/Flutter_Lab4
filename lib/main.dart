import 'package:flutter/material.dart';
import 'appointments/appointments.dart';
import 'contacts/contacts.dart';
import 'notes/notes.dart';
import 'tasks/tasks.dart';

void main() => runApp(const FlutterBookApp());

class FlutterBookApp extends StatelessWidget {
  const FlutterBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Information Manager',
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Information Manager'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Appointments'),
                Tab(text: 'Contacts'),
                Tab(text: 'Notes'),
                Tab(text: 'Tasks'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Appointments(),
              Contacts(),
              Notes(),
              Tasks(),
            ],
          ),
        ),
      ),
    );
  }
}
