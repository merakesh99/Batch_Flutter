# todo_app

Step 1: Create a New Flutter Project
Open your terminal and run the following command to create a new Flutter project:

sh

Copy code

flutter create todo_app


Navigate into the project directory:

sh

Copy code

cd todo_app


Step 2: Set Up Firebase
Firebase Console: Go to the Firebase Console and create a new project.
Add Firebase to Your Flutter App:
Follow the instructions to add a new Android app, iOS app, or both to your Firebase project.
Download the google-services.json (for Android) and GoogleService-Info.plist (for iOS) files and place them in the appropriate directories in your Flutter project.
Add Firebase Dependencies:
Add the following dependencies to your pubspec.yaml file:

yaml

Copy code

dependencies:

  flutter:

    sdk: flutter

  firebase_core: latest_version

  firebase_auth: latest_version

  cloud_firestore: latest_version


Step 3: Initialize Firebase
Create firebase_options.dart:
Run the following command to generate the firebase_options.dart file:

sh

Copy code

flutterfire configure


Initialize Firebase in main.dart:
dart

Copy code

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(MyApp());

}


class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'To-Do App',

      home: AuthScreen(),

    );

  }

}


Step 4: Firebase Authentication
Authentication Service:
Create a new file auth_service.dart:

dart

Copy code

import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> signInWithEmailPassword(String email, String password) async {

    try {

      UserCredential result = await _auth.signInWithEmailAndPassword(

          email: email, password: password);

      User? user = result.user;

      return user;

    } catch (e) {

      print(e.toString());

      return null;

    }

  }


  Future<User?> signUpWithEmailPassword(String email, String password) async {

    try {

      UserCredential result = await _auth.createUserWithEmailAndPassword(

          email: email, password: password);

      User? user = result.user;

      return user;

    } catch (e) {

      print(e.toString());

      return null;

    }

  }


  Future<void> signOut() async {

    await _auth.signOut();

  }

}


Authentication Screen:
Create a new file auth_screen.dart:

dart

Copy code

import 'package:flutter/material.dart';

import 'auth_service.dart';

import 'home_screen.dart';


class AuthScreen extends StatefulWidget {

  @override

  _AuthScreenState createState() => _AuthScreenState();

}


class _AuthScreenState extends State<AuthScreen> {

  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Authentication'),

      ),

      body: Padding(

        padding: EdgeInsets.all(16.0),

        child: Column(

          children: <Widget>[

            TextField(

              controller: _emailController,

              decoration: InputDecoration(labelText: 'Email'),

            ),

            TextField(

              controller: _passwordController,

              decoration: InputDecoration(labelText: 'Password'),

              obscureText: true,

            ),

            SizedBox(height: 20),

            ElevatedButton(

              onPressed: () async {

                User? user = await _authService.signInWithEmailPassword(

                    _emailController.text, _passwordController.text);

                if (user != null) {

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(builder: (context) => HomeScreen()),

                  );

                }

              },

              child: Text('Sign In'),

            ),

            ElevatedButton(

              onPressed: () async {

                User? user = await _authService.signUpWithEmailPassword(

                    _emailController.text, _passwordController.text);

                if (user != null) {

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(builder: (context) => HomeScreen()),

                  );

                }

              },

              child: Text('Sign Up'),

            ),

          ],

        ),

      ),

    );

  }

}


Step 5: Firestore Integration
Firestore Service:
Create a new file firestore_service.dart:

dart

Copy code

import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> addTask(String userId, String title) {

    return _db.collection('users').doc(userId).collection('tasks').add({

      'title': title,

      'completed': false,

      'timestamp': FieldValue.serverTimestamp(),

    });

  }


  Stream<QuerySnapshot> getTasks(String userId) {

    return _db

        .collection('users')

        .doc(userId)

        .collection('tasks')

        .orderBy('timestamp', descending: true)

        .snapshots();

  }


  Future<void> updateTask(String userId, String taskId, bool completed) {

    return _db

        .collection('users')

        .doc(userId)

        .collection('tasks')

        .doc(taskId)

        .update({'completed': completed});

  }


  Future<void> deleteTask(String userId, String taskId) {

    return _db.collection('users').doc(userId).collection('tasks').doc(taskId).delete();

  }

}


Home Screen:
Create a new file home_screen.dart:

dart

Copy code

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service.dart';


class HomeScreen extends StatelessWidget {

  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _taskController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('To-Do List'),

        actions: [

          IconButton(

            icon: Icon(Icons.logout),

            onPressed: () async {

              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(builder: (context) => AuthScreen()),

              );

            },

          ),

        ],

      ),

      body: Column(

        children: <Widget>[

          Padding(

            padding: const EdgeInsets.all(8.0),

            child: TextField(

              controller: _taskController,

              decoration: InputDecoration(

                labelText: 'New Task',

                suffixIcon: IconButton(

                  icon: Icon(Icons.add),

                  onPressed: () async {

                    if (_taskController.text.isNotEmpty) {

                      await _firestoreService.addTask(user!.uid, _taskController.text);

                      _taskController.clear();

                    }

                  },

                ),

              ),

            ),

          ),

          Expanded(

            child: StreamBuilder<QuerySnapshot>(

              stream: _firestoreService.getTasks(user!.uid),

              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {

                  return Center(child: CircularProgressIndicator());

                }

                if (snapshot.hasError) {

                  return Center(child: Text('Error: ${snapshot.error}'));

                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {

                  return Center(child: Text('No tasks found'));

                }


                return ListView(

                  children: snapshot.data!.docs.map((doc) {

                    return ListTile(

                      title: Text(doc['title']),

                      leading: Checkbox(

                        value: doc['completed'],

                        onChanged: (bool? value) {

                          _firestoreService.updateTask(user!.uid, doc.id, value!);

                        },

                      ),

                      trailing: IconButton(

                        icon: Icon(Icons.delete),

                        onPressed: () {

                          _firestoreService.deleteTask(user!.uid, doc.id);

                        },

                      ),

                    );

                  }).toList(),

                );

              },

            ),

          ),

        ],

      ),

    );

  }

}


Summary
Create a Flutter project and set up Firebase dependencies.
Initialize Firebase in your app.
Implement Firebase Authentication for user sign-up and sign-in.
Integrate Firestore to store and retrieve tasks.
Create a responsive UI for task management.
