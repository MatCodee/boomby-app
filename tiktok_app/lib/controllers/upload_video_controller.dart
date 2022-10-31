import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/constants.dart';
import 'package:tiktok_app/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  // Compresion del video que se esta haciendo
  _compressVideo(String videoPath) async {
    final compressVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressVideo!.file;
  }

  // Sube el viodeo a almacenmaiento de la nube
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef.child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // analizar lo que dice esta funcion
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  // Sube una imagen a la nube
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef.child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // uplaod video function
  uploadVideo(String songName, String caption, String videoPath) async {
    String uid = firebaseAuth.currentUser!.uid;
    print("id_user $uid");
    // Traemos la informacion del usuario
    final user = await firestore.collection('users').doc(uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data()! as Map<String, dynamic>;
        return data;
      },
      onError: (e) => Get.snackbar("Error User", e),
    );
    print("elemento $user");
    try {
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: user['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: user['profilePhoto'],
        thumbnail: thumbnail,
      );
      print("propedad");
      print(video.toJson());
      // porque no esta guardando la informacion de las cosas:
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      Get.back();
    } catch (e) {
      Get.snackbar("Error Uploading Video", e.toString());
    }
  }
}
