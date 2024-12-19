import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AppointmentsDBWorker {
  static final AppointmentsDBWorker db = AppointmentsDBWorker._();

  AppointmentsDBWorker._();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("Path provider is not supported on the web.");
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/appointments.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE appointments (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllAppointments() async {
    final db = await database;
    return await db.query('appointments');
  }

  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment);
  }

  Future<void> deleteAppointment(int id) async {
    final db = await database;
    await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAppointment(Map<String, dynamic> appointment) async {
    final db = await database;
    await db.update(
      'appointments',
      appointment,
      where: 'id = ?',
      whereArgs: [appointment['id']],
    );
  }
}
