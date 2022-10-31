import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app/constants.dart';
import 'package:tiktok_app/controllers/auth_controller.dart';
import 'package:tiktok_app/views/Screens/home_screen.dart';
import 'package:tiktok_app/views/Screens/login_screen.dart';
import 'package:tiktok_app/views/Screens/signup_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => {Get.put(AuthController())});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ThemeData().colorScheme.copyWith(primary: buttonColor),
        //colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor)
      ),
      home: SignUpScreen(),
    );
  }
}
