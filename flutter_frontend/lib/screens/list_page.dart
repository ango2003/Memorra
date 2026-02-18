import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> favoriteList = [];

  void addToList() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        favoriteList.add(text);
      });
      _controller.clear();
    }
  }

  void removeFromList(int index) {
    setState(() {
      favoriteList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Page")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Enter item",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addToList,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(favoriteList[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeFromList(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}