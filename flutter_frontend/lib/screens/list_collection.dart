import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/list_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/services/gift_service.dart';
import '../models/gift_list_model.dart';

class ListCollectionPage extends StatelessWidget {
  ListCollectionPage({super.key});
  
  final giftService = GiftService.instance;

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
              final giftRecipient = controller.text.trim();

              if (giftRecipient.isNotEmpty) {
                await giftService.addGiftList(giftRecipient);
                if (context.mounted) {
                  Navigator.pop(context);
                }
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
        title: Text("Delete Reminder"),
        content: Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await giftService.deleteGiftList(listID);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text("Delete"),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("My Gift Lists")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewList(context), // Call createNewList when FAB is pressed
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<GiftList>>(
        stream: giftService.getGiftLists(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) 
          {
            return const Center(child: CircularProgressIndicator()); 
          }
          final lists = snapshot.data!; // Get list of documents in the 'gift_lists' collection
          
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index]; // Get data of each document as a Map
              return ListTile(
                title: Text(list.recipient),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteList(context, list.id), // Call deleteList when delete button is pressed
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(listID: list.id)), // Navigate to ListPage when a list is tapped
                  );
                }
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 3,
      ),
    );
  }
}