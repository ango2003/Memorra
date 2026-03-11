import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/gift_service.dart';
import '../widgets/nav_bar.dart';
import '../models/gift_model.dart';

class ListPage extends StatelessWidget {
  final String listID;
  final giftService = GiftService.instance;
  ListPage({super.key, required this.listID});
  
  void createNewGift(BuildContext context, String listID) {
   final nameController = TextEditingController();
   final categoryController = TextEditingController();
    final giftService = GiftService.instance;

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
              controller: categoryController,
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
              final giftName = nameController.text.trim();
              final giftCategory = categoryController.text.trim();
             if (giftName.isNotEmpty) {
               await giftService.addGift(listID, giftName, giftCategory);
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
             await giftService.deleteGift(listID, giftID);
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
      final GiftService giftService = GiftService.instance;

     return Scaffold(
       appBar: AppBar(title: Text("List Page")),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewGift(context, listID), // Call createNewGift when FAB is pressed
         child: Icon(Icons.add),
        ),
        body: StreamBuilder<List<Gift>>(
          stream: giftService.getGifts(listID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) 
            {
             return const Center(child: CircularProgressIndicator());
            }
            final gifts = snapshot.data!;

            return ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return ListTile(
                  title: Text(gift.name),
                  subtitle: Text(gift.category),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteGift(context, listID, gift.id),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: NavBar(
          currentIndex: -1,
      ),
    );
  }
}
