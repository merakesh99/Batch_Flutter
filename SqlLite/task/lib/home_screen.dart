import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';
import 'item_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _dbHelper;
  late Future<List<Item>> _itemList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _refreshItemList();
  }

  void _refreshItemList() {
    setState(() {
      _itemList = _dbHelper.fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Example')),
      body: FutureBuilder<List<Item>>(
        future: _itemList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _dbHelper.deleteItem(item.id!);
                    _refreshItemList();
                  },
                ),
                onTap: () => _navigateToItemForm(item: item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToItemForm(),
      ),
    );
  }

  void _navigateToItemForm({Item? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemFormScreen(item: item)),
    );
    if (result != null) {
      _refreshItemList();
    }
  }
}
