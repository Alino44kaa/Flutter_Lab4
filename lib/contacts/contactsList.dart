import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'contactsModel.dart';
import 'contactsEntry.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  void initState() {
    super.initState();
    // Load data from the database
    contactsModel.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Contacts'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactsEntry()),
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: model.contacts.length,
              itemBuilder: (context, index) {
                final contact = model.contacts[index];
                return Slidable(
                  key: ValueKey(contact.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _editContact(context, contact);
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          model.delete(contact.id!);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Text('Phone: ${contact.phone}\nEmail: ${contact.email}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _editContact(BuildContext context, Contact contact) {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phone);
    final emailController = TextEditingController(text: contact.email);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  contactsModel.update(
                    Contact(
                      id: contact.id,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
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
}
