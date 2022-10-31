import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_app/controllers/auth_controller.dart';
import 'package:tiktok_app/views/Screens/add_video.dart';
import 'package:tiktok_app/views/Screens/profile_screen.dart';
import 'package:tiktok_app/views/Screens/search_screen.dart';
import 'package:tiktok_app/views/Screens/video_screen.dart';

// Pages:
List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  Text("Messages Screen"),
  ProfileScreen(uid: authController.user.uid),
];

// Firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseFirestore.instance;
var firestore = FirebaseFirestore.instance;

// Controller
var authController = AuthController.instance;

// COLORS
const backgroundColor = Color.fromARGB(255, 13, 13, 13);
var buttonColor = Color.fromARGB(255, 233, 80, 164);
var buttonColorDark = Color.fromARGB(255, 33, 33, 33);
//var buttonColor = Colors.red[400];
const borderColor = Colors.grey;
