import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stateful Widget Example'),
        ),
        body: Center(
          child: StatefulExample(),
        ),
      ),
    );
  }
}

class StatefulExample extends StatefulWidget {
  @override
  _StatefulExampleState createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  String displayText = 'Hello, world!';
  bool isButtonDisabled = false;

  void _updateText() {
    setState(() {
      displayText = 'Hello, Flutter!';
      isButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(displayText),
        ElevatedButton(
          onPressed: isButtonDisabled ? null : _updateText,
          child: const Text('Update'),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 63, 192, 20)),
          ),
          child: Text('This is a container'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Row 1'),
            Text('Row 2'),
            Text('Row 3'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Col 1'),
            Text('Col 2'),
            Text('Col 3'),
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              color: Color.fromARGB(255, 185, 13, 201),
            ),
            Container(
              width: 100,
              height: 50,
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }
}
