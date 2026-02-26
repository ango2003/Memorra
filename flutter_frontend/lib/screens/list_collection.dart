import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCollection extends StatelessWidget {
  const ListCollection({super.key});

<<<<<<< HEAD
  void createNewList(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New List"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Gift Recipient"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              final giftRecipient = controller.text.trim();
              if (giftRecipient.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(userID)
                    .collection('gift_lists')
                    .add({'gift_recipient': giftRecipient});
                Navigator.pop(context);
              }
            },
            child: Text("Create"),
          ),
        ],
      )
    );
  }

  void deleteList(BuildContext context, String listID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete List"),
        content: Text("Are you sure you want to delete this list?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection('accounts')
                  .doc(userID)
                  .collection('gift_lists')
                  .doc(listID)
                  .delete();
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      )
    );
  }
=======
>>>>>>> origin/main

  @override
  Widget build(BuildContext context) {
    
<<<<<<< HEAD
    final userID = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    return Scaffold(
      appBar: AppBar(title: Text("My lists")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewList(context), // Call createNewList when FAB is pressed
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance // Access Firestore instance
=======
    final userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("My lists")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
>>>>>>> origin/main
            .collection('accounts')
            .doc(userID)
            .collection('gift_lists')
            .snapshots(),
        builder: (context, snapshot) {
<<<<<<< HEAD
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data

          final docs = snapshot.data!.docs; // Get list of documents in the 'gift_lists' collection
          
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>; // Get data of each document as a Map
              final listID = docs[index].id;
              return ListTile(
                title: Text(data['gift_recipient']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteList(context, listID), // Call deleteList when delete button is pressed
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/listpage', // Navigate to ListPage when a list is tapped
                    arguments: {
                      'userID': userID,
                      'listID': listID,
                      'giftRecipient': data['gift_recipient'],
                    }
                  );
                }
              );
            },
=======
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          
          return ListView(
            children: docs.map((doc) {
              return ListTile(title: Text(doc['gift_recipient: ']));
            }).toList(),
>>>>>>> origin/main
          );
        },
      ),
    );
  }
}