import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

Future<UploadTask?> getFile() async {
  FilePickerResult? picker = await FilePicker.platform.pickFiles();
  if (picker != null) {
    File file = File(picker.files.single.path!);
    final bytes = file.readAsBytesSync();
    final ext = file.path.split('.').last;
    return uploadFile(bytes, ext);
  }
  return null;
}

UploadTask uploadFile(Uint8List e, String? ext) {
  var res = FirebaseStorage.instance
      .ref('files/${const Uuid().v4()}.${ext ?? 'file'}')
      .putData(e);
  return res;
}
