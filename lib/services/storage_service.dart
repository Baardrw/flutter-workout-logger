import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

///https://mercyjemosop.medium.com/select-and-upload-images-to-firebase-storage-flutter-6fac855970a9
class StorageService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<String?> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    _photo = File(pickedFile!.path);
    return uploadFile();
  }

  Future<String?> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    _photo = File(pickedFile!.path);
    return uploadFile();
  }

  Future<String?> uploadFile() async {
    if (_photo == null) return null;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      TaskSnapshot task = await ref.putFile(_photo!);
      final url = task.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('error occured');
      return null;
    }
  }

  Future<String?> showPicker(context) async {
    try {
      final pickedImage = await showModalBottomSheet<XFile?>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    Navigator.of(context).pop(pickedFile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    Navigator.of(context).pop(pickedFile);
                  },
                ),
              ],
            ),
          );
        },
      );

      if (pickedImage != null) {
        final file = File(pickedImage.path);
        final fileName = basename(pickedImage.path);
        final destination = 'files/$fileName';

        final ref = storage.ref(destination).child('file/');
        TaskSnapshot task = await ref.putFile(file);
        final url = await task.ref.getDownloadURL();
        return url;
      } else {
        return null;
      }
    } catch (e) {
      print('error occured: $e');
      return null;
    }
  }
}
