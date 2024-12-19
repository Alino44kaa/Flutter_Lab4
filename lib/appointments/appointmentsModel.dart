import 'appointmentsDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';

class Appointment {
  int? id;
  String title;
  String description;
  DateTime date;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}

class AppointmentsModel extends Model {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  // Load data from the database
  Future<void> loadAppointments() async {
    final data = await AppointmentsDBWorker.db.getAllAppointments();
    _appointments = data.map((item) {
      return Appointment(
        id: item['id'],
        title: item['title'],
        description: item['description'],
        date: DateTime.parse(item['date']),
      );
    }).toList();
    notifyListeners();
  }

  void add(Appointment appointment) async {
    final id = await AppointmentsDBWorker.db.insertAppointment({
      'title': appointment.title,
      'description': appointment.description,
      'date': appointment.date.toIso8601String(),
    });
    appointment.id = id;
    _appointments.add(appointment);
    notifyListeners();
  }

  void delete(int id) async {
    await AppointmentsDBWorker.db.deleteAppointment(id);
    _appointments.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void update(Appointment appointment) async {
    await AppointmentsDBWorker.db.updateAppointment({
      'id': appointment.id,
      'title': appointment.title,
      'description': appointment.description,
      'date': appointment.date.toIso8601String(),
    });
    int index = _appointments.indexWhere((item) => item.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
      notifyListeners();
    }
  }
}

final appointmentsModel = AppointmentsModel();
