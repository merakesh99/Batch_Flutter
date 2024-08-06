import 'package:flutter/material.dart';

class ThreePage extends StatelessWidget {
  const ThreePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
          child: Column(children: [
        Text(
          'Three Page - 1',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const successMessage()),
              // );
            },
            child: Text("Click")),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 20,
        ),
      ])),
    ));
  }
}
