
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Federo',
          primaryColor: Color.fromARGB(255, 9, 71, 37),
          primaryColorDark: const Color.fromARGB(255, 0, 4, 51),
          primaryColorLight: Color.fromARGB(255, 202, 181, 18),
          textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 25, color: Colors.black),
              displayMedium: TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 0, 0)),
              bodyLarge: TextStyle(fontSize: 14, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)))),
      home: const SplashScreen(),
    );
  }
}
