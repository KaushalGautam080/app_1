import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FireBaseStorageServices {
  final fsInstance = FirebaseStorage.instance;

  Future<String> uploadImageGetUrl(Uint8List imageData,
      {required String imageName}) async {
    final folderRef = fsInstance.ref('images/$imageName');
    final uploadTask = folderRef.putData(
        imageData,
        SettableMetadata(
          contentType: imageName.split(".").last,
        ));
    final imageUrl = await uploadTask.then((taskSnap) {
      return taskSnap.ref.getDownloadURL();
    });
    return imageUrl;

  }


}
