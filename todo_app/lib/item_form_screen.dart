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
        await _dbHelper.insertItem(item.toMap() as Item);
      } else {
        await _dbHelper.updateItem(item.toMap() as Item);
      }
      Navigator.pop(context, true);
    }
  }
}
