import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointmentsModel.dart';
import 'appointmentsEntry.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppointmentsList extends StatefulWidget {
  const AppointmentsList({super.key});

  @override
  _AppointmentsListState createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  @override
  void initState() {
    super.initState();
    appointmentsModel.loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Appointments'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentsEntry()),
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: model.appointments.length,
              itemBuilder: (context, index) {
                final appointment = model.appointments[index];
                return Slidable(
                  key: ValueKey(appointment.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _editAppointment(context, appointment);
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          model.delete(appointment.id!);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(appointment.title),
                    subtitle: Text(
                        '${appointment.description} - ${appointment.date.toLocal().toString().split(' ')[0]}'),
                    onTap: () => _showAppointmentDetails(context, appointment),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _editAppointment(BuildContext context, Appointment appointment) {
    final titleController = TextEditingController(text: appointment.title);
    final descriptionController = TextEditingController(text: appointment.description);
    final dateController = TextEditingController(
        text: appointment.date.toLocal().toString().split(' ')[0]);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  appointmentsModel.update(
                    Appointment(
                      id: appointment.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      date: DateTime.parse(dateController.text),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appointment.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${appointment.description}'),
              const SizedBox(height: 10),
              Text('Date: ${appointment.date.toLocal().toString().split(' ')[0]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
