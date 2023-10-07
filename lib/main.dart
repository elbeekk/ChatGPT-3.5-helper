import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/home_page.dart';
import 'package:test_app/language_pick.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LanguagePick(),
    );
  }
}
