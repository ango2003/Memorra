import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/nav_bar.dart';
import '../themes/app_colors.dart';
import '../widgets/background.dart';

class ListPage extends StatefulWidget {
  final String listID;
  const ListPage({super.key, required this.listID});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void createNewGift(BuildContext context, String listID) {
    final nameController = TextEditingController();
   // final categoryController = TextEditingController();
    String? selectedCategory;
    final categories = ['Food', 'Drink', 'Technology', 'Resteraunts', 'Other'];

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
            StatefulBuilder(
              builder: (context, setState) {
                return DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  hint: Text("Select Category"),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                );
              },
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
              final giftCategory = selectedCategory ?? 'Other';
              if (giftName.isNotEmpty) {
                final userID = FirebaseAuth.instance.currentUser!.uid;
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
      ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final heightPadding = width * 0.01;
    final widthPadding = height * 0.01;

    final addBoxWidth = width * 0.325;
    final addBoxHeight = height * 0.075;
    final addIconSize = base * 0.06;
    final addFontSize = base * 0.035;
    final double addBoxCurve = 50;

    final titleFontSize = base * 0.075;

    final dividerThickness = height * 0.008;
    final dividerIndent = width * 0.075;
    final double dividerCurve = 45;

    final subtitleFontSize = base * 0.05;
    final double listBoxPadding = 5;
    final double listCornerRadius = 15;

    final List<String> categories = ["Food","Drink","Technology","Resteraunts","Other",];

    Color addButtonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    Color addButtonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight.withValues(alpha: 0.75);
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;
    Color listBoxColor = isDark ? AppColors.listBGDark.withValues(alpha: 0.25) : AppColors.listBGLight.withValues(alpha: 0.25);
    Color deleteListIcon = isDark ? AppColors.deleteListDark : AppColors.deleteListLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: SizedBox(
          width: addBoxWidth,
          height: addBoxHeight,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(addBoxCurve),
            ),
            backgroundColor: addButtonBackgroundColor,
            foregroundColor: addButtonTextColor,
            onPressed: () => createNewGift(context, widget.listID),
            icon: Icon(Icons.add, size: addIconSize),
            label: Text(
              "Add New Item\nTo List",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: addFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: sizeboxSize),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: heightPadding, vertical: widthPadding),
              child: Text(
                "Friend's List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),

            Divider(
              color: titleColor,
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent: dividerIndent,
              radius: BorderRadius.circular(dividerCurve),
            ),

            SizedBox(height: sizeboxSize / 3),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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

                  return Padding(
                    padding: EdgeInsets.all(listBoxPadding),
                    child: ListView(
                      children: categories.map((category) {
                        final List<QueryDocumentSnapshot> items = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['category'] == category;
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Title
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: heightPadding, vertical: widthPadding/2),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: subtitleFontSize * 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            if (items.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 16, bottom: 10),
                                child: Text(
                                  "No items in this category",
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: subtitleFontSize / 1.6,
                                    fontWeight: FontWeight.normal,
                                    ),
                                ),
                              )
                            else
                              ...items.map((doc) {
                                final gift = doc.data() as Map<String, dynamic>;
                                final giftID = doc.id;

                                return Container(
                                  margin: EdgeInsets.only(bottom: sizeboxSize / 10),
                                  decoration: BoxDecoration(
                                    color: listBoxColor,
                                    borderRadius: BorderRadius.circular(listCornerRadius),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "-  ${gift['name'] ?? 'No name'}",
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: subtitleFontSize / 1.5,
                                        fontWeight: FontWeight.normal,
                                      )
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: deleteListIcon),
                                      onPressed: () => deleteGift(context, widget.listID, giftID),
                                    ),
                                  ),
                                );
                              }).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          currentIndex: -1,
        ),
      ),
    );
  }
}
