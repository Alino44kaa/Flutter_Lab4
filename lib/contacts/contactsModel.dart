import 'contactsDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';

class Contact {
  int? id;
  String name;
  String phone;
  String email;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });
}

class ContactsModel extends Model {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  // Load data from the database
  Future<void> loadContacts() async {
    final data = await ContactsDBWorker.db.getAllContacts();
    _contacts = data.map((item) {
      return Contact(
        id: item['id'],
        name: item['name'],
        phone: item['phone'],
        email: item['email'],
      );
    }).toList();
    notifyListeners();
  }

  void add(Contact contact) async {
    final id = await ContactsDBWorker.db.insertContact({
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
    });
    contact.id = id;
    _contacts.add(contact);
    notifyListeners();
  }

  void delete(int id) async {
    await ContactsDBWorker.db.deleteContact(id);
    _contacts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void update(Contact contact) async {
    await ContactsDBWorker.db.updateContact({
      'id': contact.id,
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
    });
    int index = _contacts.indexWhere((item) => item.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }
}

final contactsModel = ContactsModel();
