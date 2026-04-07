import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/giftlist_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/services/gift_service.dart';
import '../widgets/background.dart';
import '../models/gift_list_model.dart';
import '../themes/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  final String listID;
  
  const ListPage({
    super.key,
    required this.listID,
    });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with TickerProviderStateMixin {
  final giftService = GiftService.instance;

  // Rotating arrow controllers
  final Map<String, AnimationController> _arrowControllers = {};

  @override
  void dispose() {
    for (var controller in _arrowControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void createNewList(BuildContext context) {
    final nameController = TextEditingController();
    final ideaControllers = List.generate(5, (_) => TextEditingController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final inputFontSize = width * 0.03;
    final buttonFontSize = width * 0.025;

    Color bgColor = isDark ? AppColors.popUpBGDark.withValues(alpha: 0.6) : AppColors.popUpBGLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color inputHintColor = isDark ? AppColors.hintTextDark : AppColors.hintTextLight;
    Color inputColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    void refresh() => setState(() {});

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          bool allFilled = nameController.text.trim().isNotEmpty &&
              ideaControllers.every((c) => c.text.trim().isNotEmpty);

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(boxCurve),
            ),
            backgroundColor: bgColor,
            title: Text(
              "Create New\nFriend List",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                color: titleColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (_) => setStateDialog(() {}),
                    style: TextStyle(color: inputColor, fontSize: inputFontSize),
                    decoration: InputDecoration(
                      hintText: "Friend's Name",
                      hintStyle: TextStyle(color: inputHintColor),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pre-labeled prompts
                  _buildPromptField("Favorite hobbies", ideaControllers[0], inputColor, inputHintColor, inputFontSize, setStateDialog),
                  _buildPromptField("Favorite snacks", ideaControllers[1], inputColor, inputHintColor, inputFontSize, setStateDialog),
                  _buildPromptField("Favorite stores", ideaControllers[2], inputColor, inputHintColor, inputFontSize, setStateDialog),
                  _buildPromptField("Favorite colors", ideaControllers[3], inputColor, inputHintColor, inputFontSize, setStateDialog),
                  _buildPromptField("Favorite clothing sizes", ideaControllers[4], inputColor, inputHintColor, inputFontSize, setStateDialog),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: titleColor, fontSize: buttonFontSize)),
              ),
              ElevatedButton(
                onPressed: allFilled
                    ? () async {
                        final userID = FirebaseAuth.instance.currentUser!.uid;

                        await FirebaseFirestore.instance
                            .collection("accounts")
                            .doc(userID)
                            .collection("gift_lists")
                            .add({
                          "recipient": nameController.text.trim(),
                          "generatedIdeas": ideaControllers.map((c) => c.text.trim()).toList(),
                        });

                        if (context.mounted) Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: allFilled ? buttonBGColor : Colors.grey,
                ),
                child: Text("Create", style: TextStyle(color: titleColor, fontSize: buttonFontSize)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromptField(
    String label,
    TextEditingController controller,
    Color inputColor,
    Color hintColor,
    double fontSize,
    void Function(void Function()) setStateDialog,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: (_) => setStateDialog(() {}),
        style: TextStyle(color: inputColor, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: hintColor),
        ),
      ),
    );
  }

  void deleteList(BuildContext context, String listID) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final subtitleFontSize = width * 0.03;
    final buttonFontSize = width * 0.025;

    Color bgColor = isDark ? AppColors.popUpBGDark.withValues(alpha: 0.6) : AppColors.popUpBGLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(boxCurve)),
        backgroundColor: bgColor,
        title: Text("Delete Friend's List",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: titleFontSize, color: titleColor)),
        content: Text(
          "Are you sure you want to delete this list?\n(You cannot undo once deleted)",
          textAlign: TextAlign.center,
          style: TextStyle(color: subtitleColor, fontSize: subtitleFontSize),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: titleColor, fontSize: buttonFontSize)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: buttonBGColor),
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection("accounts")
                  .doc(userID)
                  .collection("gift_lists")
                  .doc(listID)
                  .delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: titleColor, fontSize: buttonFontSize)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final titleFontSize = base * 0.1;

    final dividerThickness = height * 0.01;
    final dividerIndent = width * 0.075;
    final double dividerCurve = 45;

    final listFontSize = base * 0.04;
    final listLetterSpacing = 1.2;
    final subtitleFontSize = base * 0.02;
    final double spaceBetweenLists = height * 0.005;
    final double listTextPadding = width * 0.02;
    final double listBoxPadding = 5;
    final double listCornerRadius = 125;

    Color addButtonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    Color addButtonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight.withValues(alpha: 0.75);
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color listTextColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;
    Color listBoxColor = isDark ? AppColors.listBGDark.withValues(alpha: 0.4) : AppColors.listBGLight.withValues(alpha: 0.4);
    Color deleteListIcon = isDark ? AppColors.deleteListDark : AppColors.deleteListLight;

    final userID = FirebaseAuth.instance.currentUser!.uid;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // Floating Add Button
        floatingActionButton: SizedBox(
          width: addBoxWidth,
          height: addBoxHeight,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(addBoxCurve)),
            backgroundColor: addButtonBackgroundColor,
            foregroundColor: addButtonTextColor,
            onPressed: () => createNewList(context),
            icon: Icon(Icons.add, size: addIconSize),
            label: Text(
              "Add New\nFriend List",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: addFontSize, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        body: Column(
          children: [
            SizedBox(height: sizeboxSize),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: heightPadding, vertical: widthPadding),
              child: Text(
                "My Friend's List",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: titleColor),
              ),
            ),

            Divider(
              color: titleColor,
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent: dividerIndent,
              radius: BorderRadius.circular(dividerCurve),
            ),

            SizedBox(height: sizeboxSize),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("accounts")
                    .doc(userID)
                    .collection("gift_lists")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  // Initialize arrow controllers
                  for (var doc in docs) {
                    _arrowControllers[doc.id] ??= AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(listBoxPadding),
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final list = docs[index];
                        final listID = list.id;

                        final ideas = List<String>.from(list["generatedIdeas"] ?? []);

                        return Container(
                          margin: EdgeInsets.only(bottom: spaceBetweenLists),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(listCornerRadius)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(listCornerRadius),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: listBoxColor,
                                  borderRadius: BorderRadius.circular(listCornerRadius),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.symmetric(horizontal: listTextPadding, vertical: 8),

                                    trailing: RotationTransition(
                                      turns: Tween(begin: 0.0, end: 0.5).animate(_arrowControllers[listID]!),
                                      child: Icon(Icons.keyboard_arrow_down_rounded, color: listTextColor, size: listFontSize * 1.4),
                                    ),

                                    title: Text(
                                      list["recipient"],
                                      style: TextStyle(
                                        fontSize: listFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: listTextColor,
                                        letterSpacing: listLetterSpacing,
                                      ),
                                    ),

                                    subtitle: Text(
                                      "Tap to view friend details",
                                      style: TextStyle(color: subtitleColor, fontSize: subtitleFontSize),
                                    ),

                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(ideas.length, (i) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Idea ${i + 1}: ",
                                                    style: TextStyle(
                                                      color: listTextColor,
                                                      fontSize: subtitleFontSize * 1.1,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ideas[i],
                                                      style: TextStyle(
                                                        color: subtitleColor,
                                                        fontSize: subtitleFontSize * 1.05,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                      // "Need to change something?" button
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Editing Coming Soon"),
                                              content: Text("You'll be able to edit this list in a future update."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Need to change something?",
                                          style: TextStyle(
                                            color: listTextColor,
                                            fontSize: subtitleFontSize * 1.1,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],

                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                        _arrowControllers[listID]!.forward();
                                      } else {
                                        _arrowControllers[listID]!.reverse();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        bottomNavigationBar: NavBar(currentIndex: -1),
      ),
    );
  }
}
