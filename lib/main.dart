import 'package:flutter/material.dart';
import 'package:newsapp/views/home.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: Colors.indigo,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
