import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/home_page.dart';
import 'package:test_app/language_pick.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:FirebaseOptions(apiKey: "AIzaSyARM1XEedt9Jt-XqKZYtnxworpw3O0HiDg", appId: "1:694363892436:android:9214ee57cfdf82c1382941",
        messagingSenderId: "694363892436", projectId: "test-app-217a0"),
  );
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
