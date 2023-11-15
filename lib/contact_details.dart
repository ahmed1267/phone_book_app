import 'package:flutter/material.dart';
import 'package:phone_book_app/add_edit.dart';
import 'package:phone_book_app/main.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;
  final List<Contact> contacts;

  const ContactDetailsPage(
      {Key? key, required this.contact, required this.contacts})
      : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  Contact? _updatedContact;

  @override
  Widget build(BuildContext context) {
    // Use _updatedContact if available, otherwise use widget.contact
    Contact displayContact = _updatedContact ?? widget.contact;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display contact details here
            Text('Name: ${displayContact.name}'),
            Text('Phone Number: ${displayContact.phoneNumber}'),
            // Display avatar if available
            if (displayContact.avatar != null)
              Image.network(displayContact.avatar!),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _navigateToAddEditContact(context, displayContact);
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteContact(displayContact);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to navigate to the add/edit contact page with the current contact for editing
  void _navigateToAddEditContact(BuildContext context, Contact contact) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactPage(
          contact: contact,
          contacts: widget.contacts,
        ),
      ),
    );

    if (updatedContact != null && updatedContact is Contact) {
      setState(() {
        _updatedContact = updatedContact;
      });
    }
  }

  // Function to delete the contact
  void _deleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.contacts.removeWhere((c) => c.id == contact.id);

                // Replace the current route with the updated main page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ContactList(contacts: widget.contacts),
                  ),
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
