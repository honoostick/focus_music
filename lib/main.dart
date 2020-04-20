import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './router.dart';
import './store/index.dart';

void main() => runApp(MultiProvider(
      providers: providers,
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Music',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(),
        cardColor: Colors.grey[1000],
        accentColor: Colors.purple[600], // Colors.cyan[600],
      ),
      home: Router(),
    );
  }
}
