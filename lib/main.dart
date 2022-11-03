import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await UserPreferences.init();
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
          primarySwatch: Colors.blue,
          fontFamily: 'Federo',
          primaryColor: Color.fromARGB(255, 0, 51, 23),
          primaryColorDark: Color.fromARGB(255, 0, 4, 51),
          primaryColorLight: Color.fromARGB(255, 179, 170, 97),
          textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 25, color: Colors.black),
              headline2: TextStyle(fontSize: 25, color: Colors.white),
              bodyText1: TextStyle(fontSize: 14, color: Colors.black),
              bodyText2: TextStyle(fontSize: 14, color: Colors.white))),
      home: const SplashScreen(),
    );
  }
}
