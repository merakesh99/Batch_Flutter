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

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('AnimatedContainer Example')),
//         body: AnimatedContainerDemo(),
//       ),
//     );
//   }
// }

// class AnimatedContainerDemo extends StatefulWidget {
//   @override
//   _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
// }

// class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
//   bool _selected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _selected = !_selected;
//           });
//         },
//         child: AnimatedContainer(
//             width: _selected ? 200.0 : 100.0,
//             height: _selected ? 100.0 : 200.0,
//             color: _selected ? Colors.blue : Colors.red,
//             alignment:
//                 _selected ? Alignment.center : AlignmentDirectional.topCenter,
//             duration: Duration(seconds: 1),
//             curve: Curves.linear,
//             child: const Image(
//               image: NetworkImage(
//                   'https://cdn.pixabay.com/photo/2024/05/02/16/22/parrots-8735074_1280.jpg'),
//             )
//             // _selected ? Text("We are Good Students!") : FlutterLogo(size: 75),
//             ),
//       ),
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
        appBar: AppBar(title: Text('AnimationController Example')),
        body: AnimationDemo(),
      ),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _animation,
        child: FlutterLogo(size: 100),
      ),
    );
  }
}

