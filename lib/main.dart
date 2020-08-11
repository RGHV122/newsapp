import 'package:flutter/material.dart';
import 'package:newsapp/views/home.dart';
import 'package:newsapp/views/news.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  newsapipage=1;
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
