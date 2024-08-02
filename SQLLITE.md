1. Introduction to SQLite
Overview of SQLite:

SQLite is a lightweight, disk-based database that doesn’t require a separate server process.
It’s useful for embedded applications, mobile applications, and small projects that require reliable data storage.
Use Cases:

Local data storage for offline capabilities.
Storing user preferences and settings.
Caching data for faster access.

2. Setting Up SQLite in Flutter
Adding Dependencies:

Open pubspec.yaml and add sqflite and path dependencies:

yaml

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4
  path: ^1.8.0
Run flutter pub get to install the packages.

3. Database Initialization
Creating a Database Helper Class:

Create a new file database_helper.dart:
dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'example.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }
}






4. CRUD Operations
Create Operation:

Add a method to insert data:
dart

Future<int> insertItem(Map<String, dynamic> item) async {
  Database db = await database;
  return await db.insert('items', item);
}
Read Operation:

Add a method to fetch data:
dart

Future<List<Map<String, dynamic>>> fetchItems() async {
  Database db = await database;
  return await db.query('items');
}
Update Operation:

Add a method to update data:
dart

Future<int> updateItem(Map<String, dynamic> item) async {
  Database db = await database;
  int id = item['id'];
  return await db.update('items', item, where: 'id = ?', whereArgs: [id]);
}
Delete Operation:

Add a method to delete data:
dart

Future<int> deleteItem(int id) async {
  Database db = await database;
  return await db.delete('items', where: 'id = ?', whereArgs: [id]);
}


5. Asynchronous Database Operations
Using Future and async/await:

Ensure all database operations are asynchronous to avoid blocking the UI thread.
6. Database Helper Class
Singleton Pattern:

The DatabaseHelper class uses the singleton pattern to ensure only one instance of the database is used throughout the app.
7. Model Classes
Creating Model Classes:

Create a new file item.dart:
dart

class Item {
  final int? id;
  final String name;
  final String description;

  Item({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
8. Error Handling
Managing Database Errors:

Use try-catch blocks to handle potential errors during database operations.
9. Database Migration
Handling Schema Changes:

Implement versioning and migration strategies using the onUpgrade callback in openDatabase.
10. Practical Examples
Building a Simple CRUD Application:

Create a new Flutter project.
Integrate the database helper and model classes.
Implement UI to interact with the database (e.g., adding, viewing, updating, and deleting items).
11. Testing
Writing Unit Tests:

Write unit tests to ensure database operations work as expected.
12. Best Practices
Performance Optimization:

Optimize queries and indexing for better performance.
Use transactions for bulk operations.
Security Considerations:

Consider encrypting sensitive data stored in the database.
Example Project Structure:

css

lib/
  main.dart
  database_helper.dart
  item.dart
  screens/
    home_screen.dart
    item_form_screen.dart
main.dart:

dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Example')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.fetchItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = Item.fromMap(items[index]);
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                onTap: () => _showItemForm(item: item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showItemForm(),
      ),
    );
  }

  void _showItemForm({Item? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemFormScreen(item: item)),
    );
    if (result != null) {
      setState(() {});
    }
  }
}
item_form_screen.dart:

dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  ItemFormScreen({this.item});

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _name = widget.item?.name ?? '';
    _description = widget.item?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? 'Add Item' : 'Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: _saveItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final item = Item(name: _name, description: _description, id: widget.item?.id);
      if (widget.item == null) {
        await _dbHelper.insertItem(item.toMap());
      } else {
        await _dbHelper.updateItem(item.toMap());
      }
      Navigator.pop(context, true);
    }
  }
}
This example provides a basic structure and implementation for a Flutter app that uses SQLite for local storage. You can expand and customize it based on your specific


13. Conclusion
Review:

Summarize the key points covered in the class.
Highlight the importance of understanding local storage and SQLite for developing robust Flutter applications.
Q&A Session:

Allow time for students to ask questions and clarify any doubts they may have.
Next Steps:

Provide resources for further learning.
Suggest small projects or exercises to reinforce the concepts learned.
Example Project Expanded
Finalizing database_helper.dart:
Ensure all necessary methods for CRUD operations are included in your database helper class.

Database Helper Class Expanded:

dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'example.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> fetchItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(Item item) async {
    Database db = await database;
    return await db.update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
Expanded Example: ItemFormScreen
ItemFormScreen:

dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  ItemFormScreen({this.item});

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _name = widget.item?.name ?? '';
    _description = widget.item?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? 'Add Item' : 'Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: _saveItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final item = Item(name: _name, description: _description, id: widget.item?.id);
      if (widget.item == null) {
        await _dbHelper.insertItem(item);
      } else {
        await _dbHelper.updateItem(item);
      }
      Navigator.pop(context, true);
    }
  }
}
Example home_screen.dart:
dart

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
Conclusion
Reviewing the Project: Walk through the completed project, highlighting key components and how they interact.
Advanced Topics: Briefly mention more advanced topics such as joining tables, using foreign keys, and complex queries.
Project Expansion: Encourage students to expand the project by adding new features such as search functionality, data filtering, or using more advanced database features.