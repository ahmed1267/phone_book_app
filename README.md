# Phone Book App

## Overview

The Phone Book App is a simple mobile application that allows users to manage their contacts. Users can view a list of contacts, search for specific contacts, add new contacts, edit existing ones, and delete contacts.

## How to Run and Test

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/ahmed1267/phone_book_app.git
   cd phone-book-app
2. **Install Dependancy:**
   ```bash
   flutter pub get
  

4. **Run the App:**
   ```bash
   flutter run

**Assumptions and Decisions**

    Avatar Handling:
        The app assumes that avatars can be either network images (URL starting with 'http') or local assets. It distinguishes between the two when displaying avatars in the contact details.

    Contact Deletion:
        Contact deletion triggers a confirmation dialog. After confirming the deletion, the contact list is updated, and the user is navigated back to the main contact list.

    State Management:
        The app uses Flutter's built-in setState for managing state within individual widgets. In a larger-scale app, you might consider using a state management solution like Provider, Riverpod, or Bloc.

  
