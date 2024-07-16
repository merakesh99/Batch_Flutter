// import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';

// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(

//     options: DefaultFirebaseOptions.currentPlatform,

//   );

//   runApp(MyApp());

// }

// class MyApp extends StatelessWidget {

//   @override

//   Widget build(BuildContext context) {

//     return MaterialApp(

//       title: 'To-Do App',

//       home: AuthScreen(),

//     );

//   }

// }

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('AnimatedContainer Example')),
        body: AnimatedContainerDemo(),
      ),
    );
  }
}

class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = !_selected;
          });
        },
        child: AnimatedContainer(
          width: _selected ? 200.0 : 100.0,
          height: _selected ? 100.0 : 200.0,
          color: _selected ? Colors.blue : Colors.red,
          alignment:
              _selected ? Alignment.center : AlignmentDirectional.topCenter,
          duration: Duration(seconds: 1),
          curve: Curves.linear,
          child: Text("We are Good Students!"),
        ),
      ),
    );
  }
}
