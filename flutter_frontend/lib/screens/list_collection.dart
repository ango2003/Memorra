import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/list_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/services/gift_service.dart';
import '../widgets/background.dart';
import '../models/gift_list_model.dart';
import '../themes/app_colors.dart';

class ListCollectionPage extends StatelessWidget {
  ListCollectionPage({super.key});
  
  final giftService = GiftService.instance;

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
          borderRadius: BorderRadius.circular(boxCurve)
        ),
        backgroundColor: bgColor,
        title: Text(
          "Create New\nList",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor,
          )
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
            )
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
                if (context.mounted) {
                  Navigator.pop(context);
                }
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
      )
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
          borderRadius: BorderRadius.circular(boxCurve)
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
            onPressed: () {
              Navigator.pop(context);
            },
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
              if (context.mounted) {
                Navigator.pop(context);
              }
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    //Spacing in between
    final sizeboxSize = base * 0.05;
    
    //Title Padding
    final heightPadding = width * 0.01;
    final widthPadding = height * 0.01;
    
    //Add Friend Sizing
    final addBoxWidth = width * 0.325;
    final addBoxHeight = height * 0.075;
    final addIconSize = base * 0.06;
    final addFontSize = base * 0.035;
    final double addBoxCurve = 50;
    final FontWeight addFontWeight = FontWeight.w600;
    
    //Title Size
    final titleFontSize = base * 0.1;
    
    //Divider Size
    final dividerThickness = height * 0.01;
    final dividerIndent = width * 0.075;
    final double dividerCurve = 45;

    //List Size
    final listFontSize = base * 0.04;
    final listLetterSpacing = 1.2;
    final subtitleFontSize = base * 0.02;
    final double spaceBetweenLists = height * 0.005;
    final double listTextPadding = width * 0.02;
    final double listBoxPadding = 5;
    final double listCornerRadius = 125;
    final FontWeight listFontWeight = FontWeight.w400;

    //Colors
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
            icon: Icon(Icons.add, 
              size: addIconSize,
            ),
            label: Text(
              "Add New\nFriend List",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: addFontSize,
                fontWeight: addFontWeight,
              ),
            )
          ),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                )
              )
            ),

            Divider(
              color: titleColor,
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent:dividerIndent,
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

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: listBoxPadding, vertical: listBoxPadding),
                    child: ListView.builder(
                      itemCount: lists.length,
                      itemBuilder: (context, index) {
                        final list = lists[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: spaceBetweenLists),
                          child: ListTile(
                            tileColor: listBoxColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(listCornerRadius),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(left: listTextPadding),
                              child: Text(
                                list.recipient,
                                style: TextStyle(
                                  fontSize: listFontSize,
                                  fontWeight: listFontWeight,
                                  color: listTextColor,
                                  letterSpacing: listLetterSpacing,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(left: listTextPadding),
                              child: Text(
                                "Tap to View Gift Ideas",
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: subtitleFontSize,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: deleteListIcon),
                              onPressed: () => deleteList(context, list.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListPage(listID: list.id),
                                ),
                              );
                            },
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
        bottomNavigationBar: NavBar(
          currentIndex: -1,
        ),
      ),
    );
  }
}