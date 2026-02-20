import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCollection extends StatelessWidget {
  const ListCollection({super.key});


  @override
  Widget build(BuildContext context) {
    
    final userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("My lists")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('accounts')
            .doc(userID)
            .collection('gift_lists')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          
          return ListView(
            children: docs.map((doc) {
              return ListTile(title: Text(doc['gift_recipient: ']));
            }).toList(),
          );
        },
      ),
    );
  }
}