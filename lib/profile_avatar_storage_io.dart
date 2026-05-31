import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<File> _avatarFile(String uid) async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/profile_avatar_$uid.jpg');
}

Future<Uint8List?> loadLocalProfileAvatarBytes(String uid) async {
  final f = await _avatarFile(uid);
  if (!await f.exists()) return null;
  return f.readAsBytes();
}

Future<void> saveLocalProfileAvatarFromPicker(String uid, XFile file) async {
  final dest = await _avatarFile(uid);
  final bytes = await file.readAsBytes();
  await dest.writeAsBytes(bytes, flush: true);
}
