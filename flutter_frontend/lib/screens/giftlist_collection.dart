import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/giftlist_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/services/gift_service.dart';
import '../widgets/background.dart';
import '../models/gift_list_model.dart';
import '../themes/app_colors.dart';

class ListCollectionPage extends StatefulWidget {
  const ListCollectionPage({super.key});

  @override
  State<ListCollectionPage> createState() => _ListCollectionPageState();
}

class _ListCollectionPageState extends State<ListCollectionPage>
    with TickerProviderStateMixin {
  final giftService = GiftService.instance;

  final Map<String, AnimationController> _arrowControllers = {};
  final Map<String, bool> _expandedState = {};

  @override
  void dispose() {
    for (var controller in _arrowControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void createNewList(BuildContext context) {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final inputFontSize = width * 0.03;
    final buttonFontSize = width * 0.02;

    Color bgColor = isDark ? AppColors.popUpBGDark.withValues(alpha: 0.6) : AppColors.popUpBGLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color inputHintColor = isDark ? AppColors.hintTextDark : AppColors.hintTextLight;
    Color inputColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(boxCurve),
        ),
        backgroundColor: bgColor,
        title: Text(
          "Create New\nList",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor,
          ),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(
            color: inputColor,
            fontSize: inputFontSize,
          ),
          decoration: InputDecoration(
            hintText: "Gift Recipient",
            hintStyle: TextStyle(
              color: inputHintColor,
              fontSize: inputFontSize,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: inputHintColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: inputColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBGColor,
            ),
            onPressed: () async {
              final giftRecipient = controller.text.trim();
              if (giftRecipient.isNotEmpty) {
                await giftService.addGiftList(giftRecipient);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(
              "Create",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
        ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(boxCurve),
        ),
        backgroundColor: bgColor,
        title: Text(
          "Delete Friend's List",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this list?"
          "\n(You cannot undo once deleted)",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subtitleColor,
            fontSize: subtitleFontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBGColor,
            ),
            onPressed: () async {
              await giftService.deleteGiftList(listID);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
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

    final containerAnimationTime = 600;
    final listFontSize = base * 0.04;
    final listLetterSpacing = 1.2;
    final subtitleFontSize = base * 0.02;
    final double spaceBetweenLists = height * 0.005;
    final double listTextPadding = width * 0.02;
    final double listBoxPadding = 5;
    final double listCornerRadius = 40;
    final double topExpandedRadius = listCornerRadius;
    final double bottomExpandedRadius = listCornerRadius;

    Color addButtonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;
    Color addButtonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight.withValues(alpha: 0.75);
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color listTextColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;
    Color listBoxColor = isDark ? AppColors.listBGDark.withValues(alpha: 0.4) : AppColors.listBGLight.withValues(alpha: 0.4);
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
            onPressed: () => createNewList(context),
            icon: Icon(Icons.add, size: addIconSize),
            label: Text(
              "Add New\nFriend List",
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
                "My Friend's List",
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

            SizedBox(height: sizeboxSize),

            Expanded(
              child: StreamBuilder<List<GiftList>>(
                stream: giftService.getGiftLists(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final lists = snapshot.data!;

                  for (var list in lists) {
                    _arrowControllers[list.id] ??= AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 200),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(listBoxPadding),
                    child: ListView.builder(
                      itemCount: lists.length,
                      itemBuilder: (context, index) {
                        final list = lists[index];
                        final ideas = ["Like 1", "Like 2", "Like 3", "Like 4", "Like 5"]; // temporary ideas

                        return AnimatedContainer(
                          duration: Duration(milliseconds: containerAnimationTime),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(bottom: spaceBetweenLists),
                          decoration: BoxDecoration(
                            borderRadius: _expandedState[list.id] == true
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(topExpandedRadius),
                                    topRight: Radius.circular(topExpandedRadius),
                                    bottomLeft: Radius.circular(bottomExpandedRadius),
                                    bottomRight: Radius.circular(bottomExpandedRadius),
                                  )
                                : BorderRadius.circular(listCornerRadius),
                          ),
                          child: ClipRRect(
                            borderRadius: _expandedState[list.id] == true
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(topExpandedRadius),
                                    topRight: Radius.circular(topExpandedRadius),
                                    bottomLeft: Radius.circular(bottomExpandedRadius),
                                    bottomRight: Radius.circular(bottomExpandedRadius),
                                  )
                                : BorderRadius.circular(listCornerRadius),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: listBoxColor,
                                  borderRadius: _expandedState[list.id] == true
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(topExpandedRadius),
                                          topRight: Radius.circular(topExpandedRadius),
                                          bottomLeft: Radius.circular(bottomExpandedRadius),
                                          bottomRight: Radius.circular(bottomExpandedRadius),
                                        )
                                      : BorderRadius.circular(listCornerRadius),
                                ),

                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _expandedState[list.id] = !(_expandedState[list.id] ?? false);
                                        });

                                        if (_expandedState[list.id] == true) {
                                          _arrowControllers[list.id]!.forward();
                                        } else {
                                          _arrowControllers[list.id]!.reverse();
                                        }
                                      },

                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: containerAnimationTime),
                                        curve: Curves.easeOutCubic,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: listTextPadding,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    list.recipient,
                                                    style: TextStyle(
                                                      fontSize: listFontSize,
                                                      fontWeight: FontWeight.w400,
                                                      color: listTextColor,
                                                      letterSpacing: listLetterSpacing,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Tap here to view gift ideas",
                                                    style: TextStyle(
                                                      color: subtitleColor,
                                                      fontSize: subtitleFontSize,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: deleteListIcon,
                                                size: listFontSize * 1.2,
                                              ),
                                              onPressed: () => deleteList(context, list.id),
                                            ),

                                            RotationTransition(
                                              turns: Tween(begin: 0.0, end: 0.5)
                                                  .animate(_arrowControllers[list.id]!),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: listTextColor,
                                                size: listFontSize * 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    AnimatedCrossFade(
                                      duration: Duration(milliseconds: containerAnimationTime + 100),
                                      crossFadeState: _expandedState[list.id] == true
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      firstChild: AnimatedOpacity(
                                        duration: Duration(milliseconds: containerAnimationTime),
                                        opacity: _expandedState[list.id] == true ? 1 : 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(5, (i) {
                                              final idea = ideas[i];

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
                                                        idea,
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
                                      ),
                                      secondChild: SizedBox.shrink(),
                                    ),
                                  ],
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

        bottomNavigationBar: 
        NavBar(
          currentIndex: -1
        ),
      ),
    );
  }
}
