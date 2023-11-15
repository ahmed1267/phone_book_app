import 'package:flutter/material.dart';
import 'package:phone_book_app/add_edit.dart';
import 'package:phone_book_app/contactSearchDelegate.dart';
import 'package:phone_book_app/contact_details.dart';

void main() {
  runApp(MyApp());
}

class Contact {
  final String id; // Unique identifier for each contact
  final String name;
  final String phoneNumber;
  final String? avatar;

  Contact(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.avatar = 'assets/images/placeholder.png'});
}

class ContactList extends StatefulWidget {
  final List<Contact> contacts;
  final Function(Contact)? onContactDeleted;

  const ContactList({
    Key? key,
    required this.contacts,
    this.onContactDeleted,
  }) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool isDarkMode = false;
  List<Contact> contacts = []; // Initialize an empty list
  late List<Contact> filteredContacts; // Add a new list for filtered contacts

  TextEditingController searchController = TextEditingController();

  void _handleContactDeleted(Contact deletedContact) {
    setState(() {
      widget.contacts.removeWhere((contact) => contact.id == deletedContact.id);
      filteredContacts = List.from(widget.contacts);
    });
    if (widget.onContactDeleted != null) {
      widget.onContactDeleted!(deletedContact);
    }
  }

  @override
  void initState() {
    super.initState();
    // Load contacts when the widget is created
    _loadContacts();
    filteredContacts =
        List.from(contacts); // Initialize filteredContacts with all contacts
  }

  // Function to load contacts from in-memory storage
  void _loadContacts() {
    contacts = [
      Contact(
          id: '1',
          name: 'Alice Johnson',
          phoneNumber: '+1234567890',
          avatar: 'https://picsum.photos/200/300'),
      Contact(
          id: '2',
          name: 'Bob Smith',
          phoneNumber: '+0987654321',
          avatar: 'https://picsum.photos/200/300'),
      Contact(
          id: '3',
          name: 'Charlie Brown',
          phoneNumber: '+1122334455',
          avatar: 'https://picsum.photos/200/300'),
      Contact(
          id: '4',
          name: 'David Williams',
          phoneNumber: '+5566778899',
          avatar: 'https://picsum.photos/200/300'),
      Contact(
          id: '5',
          name: 'Eva Green',
          phoneNumber: '+2244668800',
          avatar: 'https://picsum.photos/200/300')
    ];
  }

  // Function to filter contacts based on search query
  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phone Book'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ContactSearchDelegate(filteredContacts),
                );
              },
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.brightness_2),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                _navigateToContactDetails(context, filteredContacts[index]);
              },
              title: Text(filteredContacts[index].name),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(context);
            _navigateToAddEditContact(
                context, null); // Pass null for adding new contact
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // Function to navigate to the add/edit contact page
  void _navigateToAddEditContact(BuildContext context, Contact? contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactPage(
          contact: contact,
          contacts: contacts,
        ),
      ),
    ).then((_) {
      // Rebuild the list when returning from AddEditContactPage
      setState(() {
        filteredContacts = List.from(contacts);
      });
    });
  }

  // Function to navigate to the contact details page
  void _navigateToContactDetails(BuildContext context, Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailsPage(
          contact: contact,
          contacts: contacts,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactList(
        contacts: [],
        onContactDeleted: (deletedContact) {
          // This function can be empty, as we're just passing it to ContactList
          // and ContactDetailsPage will call it when a contact is deleted.
        },
      ),
    );
  }
}
