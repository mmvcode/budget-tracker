import 'package:flutter/material.dart';
import 'package:budget_tracker/src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  await dotenv.load(fileName: '.env');
  runApp(App());
}
