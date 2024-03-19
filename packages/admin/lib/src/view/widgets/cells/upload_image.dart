import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<String?> getPhoto({
  required Size size,
  bool isCircle = true,
}) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  final ratio = size.width / size.height;
  if (image != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: ratio, ratioY: 1),
      cropStyle:
          ratio == 1 && isCircle ? CropStyle.circle : CropStyle.rectangle,
      maxWidth: size.width.toInt(),
      maxHeight: size.height.toInt(),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          showCropGrid: false,
          backgroundColor: Colors.black,
          hideBottomControls: true,
          activeControlsWidgetColor: Colors.black,
          statusBarColor: Colors.black,
          cropFrameColor: Colors.transparent,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          doneButtonTitle: 'Save',
          cancelButtonTitle: 'Cancel',
        ),
      ],
    );
    final bytes = await croppedFile?.readAsBytes();
    if (bytes == null) return null;
    return uploadPhoto(bytes);
  }
  return null;
}

Future<String> uploadPhoto(Uint8List e) async {
  var res = await FirebaseStorage.instance
      .ref('images/${const Uuid().v4()}.jpg')
      .putData(e);
  return await res.ref.getDownloadURL();
}
