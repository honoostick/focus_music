import 'package:bot_toast/bot_toast.dart';
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
    return BotToastInit(
        child: MaterialApp(
      title: 'Focus Music',
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        // colorScheme: ColorScheme.dark(),
        cardColor: Colors.grey[1000],
        accentColor: Colors.purple[600], // Colors.cyan[600],
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
        // appBarTheme: AppBarTheme.of(context)
      ),
      home: Router(),
    ));
  }
}
