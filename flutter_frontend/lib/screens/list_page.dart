import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  final String listID;

  const ListPage({super.key, required this.listID});

  @override
  State<ListPage> createState() => _ListPageState();
}

void createNewItem(BuildContext context, String listID) {
  final nameController = TextEditingController();
  final catagoryController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add New Gift"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Gift Name"),
          ),
          SizedBox(height: 16),
          TextField(
            controller: catagoryController,
            decoration: InputDecoration(hintText: "Gift Category"),
          ),
        ],
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
            final giftName = nameController.text.trim();
            final giftCategory = catagoryController.text.trim();
            if (giftName.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('accounts')
                  .doc(userID)
                  .collection('gift_lists')
                  .doc(listID)
                  .collection('gifts')
                  .add({'name': giftName, 'category': giftCategory});
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: Text("Add"),
        ),
      ],
    )
  );
}

void deleteGift(BuildContext context, String listID, String giftID) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Gift"),
      content: Text("Are you sure you want to delete this gift?"),
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
                .collection('gifts')
                .doc(giftID)
                .delete();
            if (context.mounted) Navigator.pop(context);
          },
          child: Text("Delete"),
        ),
      ],
    )
  );
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {

    final userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("List Page")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewItem(context, widget.listID), // Call createNewItem when FAB is pressed
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("accounts")
            .doc(userID)
            .collection("gift_lists")
            .doc(widget.listID)
            .collection("gifts")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final gift = docs[index];
              final giftID = docs[index].id;
              return ListTile(
                title: Text(gift['name'] ?? 'No name'),
                subtitle: Text(gift['category'] ?? 'No category'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteGift(context, widget.listID, giftID), // Call deleteGift with listID and giftID
                ),
              );
            },
          );
        },
      ),
    );
  }
}