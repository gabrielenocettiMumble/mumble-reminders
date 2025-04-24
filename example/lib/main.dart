import 'package:flutter/material.dart';
import 'package:mumble_reminders_example/providers/providers.dart';
import 'package:mumble_reminders_example/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the reminders manager
  await Providers.remindersManager.initializePlugin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mumble Reminders',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(245, 130, 104, 1)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
