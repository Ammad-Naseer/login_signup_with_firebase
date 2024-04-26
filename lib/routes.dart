import 'package:flutter/material.dart';
import 'package:task_8000/auth/login.dart';
import 'package:task_8000/auth/signup.dart';
import 'package:task_8000/home.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const HomePage(),
  '/login': (BuildContext context) => const LoginPage(),
  '/signup': (BuildContext context) => const SignupPage(),
};
