import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_8000/firebase_options.dart';
import 'package:task_8000/routes.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp()); // Run your Flutter app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task',
      initialRoute: '/login',
      routes: routes,
    );
  }
}
