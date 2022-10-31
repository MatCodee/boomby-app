import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:get/get.dart";
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_app/constants.dart';

import "package:tiktok_app/models/user.dart" as model;
import 'package:tiktok_app/views/Screens/home_screen.dart';
import 'package:tiktok_app/views/Screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;

  File? get ProfilePhoto => _pickedImage.value;
  User get user => _user.value!;

  // register the Users

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    // ver que hace esta funcion
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user in the firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        // esta es la funcion que va a subir la imagen de la foto en firebase
        String urlPhoto = await _uploadToFireStorage(image);
        print(urlPhoto);
        model.User user = model.User(
            name: username,
            email: email,
            profilePhoto: urlPhoto,
            uid: cred.user!.uid);

        // Agregando el contenido a la base de datos
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar("Error Creating Account", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Account", e.toString());
    }
  }

  Future<String> _uploadToFireStorage(File image) async {
    final storageRef = FirebaseStorage.instance.ref(); // Esto es temporal
    Reference ref =
        storageRef.child('profilePics').child(firebaseAuth.currentUser!.uid);

    // Entender estas palabras reservadas
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Esta es la funcion que  se va a encargar de  elegir una imagem del usuario para la Aplicacion
  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print("El objeto es nulo");
      Get.snackbar(
          "Profile Picture", "You have Successfully selected your profile");
      _pickedImage = Rx<File?>(File(pickedImage.path));
    }
  }

  // Estas son las funciones de logn de la aplicacion
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("Successfuly");
      } else {
        Get.snackbar("Error Logging in", "Plase enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Login Account", e.toString());
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
