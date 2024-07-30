import 'package:flutter/material.dart';

class successMessage extends StatelessWidget {
  const successMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back to First Screen'),
          onPressed: () {
            Navigator.pop(context);
          },
          //child: const Text("Heyyey e fue ufr ur"),
        ),
      ),
    );
  }
}
