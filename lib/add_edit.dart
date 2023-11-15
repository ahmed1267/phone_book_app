import 'package:flutter/material.dart';
import 'package:phone_book_app/main.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact; // Pass the contact if editing, null if adding
  final List<Contact> contacts; // Pass the contacts list

  AddEditContactPage({Key? key, required this.contacts, this.contact})
      : super(key: key);

  @override
  _AddEditContactPageState createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      // Editing mode, prefill the form with contact details
      _nameController.text = widget.contact!.name;
      _phoneNumberController.text = widget.contact!.phoneNumber;
    }
  }

  // Function to save or update the contact
  void _saveContact() {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (name.isNotEmpty && phoneNumber.isNotEmpty) {
      String id = widget.contact?.id ?? UniqueKey().toString();
      Contact newContact = Contact(
        id: id, // Use existing id or generate a new one
        name: name,
        phoneNumber: phoneNumber,
      );

      // Add logic to save or update the contact based on the widget.contact value
      if (widget.contact == null) {
        // Add the new contact if it's a new one
        setState(() {
          widget.contacts.add(newContact);
        });
      } else {
        // Update the existing contact
        int index = widget.contacts
            .indexWhere((contact) => contact.id == widget.contact?.id);

        if (index != -1) {
          setState(() {
            widget.contacts[index] = newContact;
          });
        }
      }

      Navigator.pop(context, newContact); // Close the add/edit contact page
    } else {
      // Show an error message or handle empty fields
      // For now, you can print an error message to the console
      print("Name and phone number are required.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveContact, // Call the save function
                  child: Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the add/edit contact page
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
