import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import 'profile_avatar_storage_stub.dart'
    if (dart.library.io) 'profile_avatar_storage_io.dart' as avatar_storage;

Future<Uint8List?> loadLocalProfileAvatarBytes(String uid) => avatar_storage.loadLocalProfileAvatarBytes(uid);

Future<void> saveLocalProfileAvatarFromPicker(String uid, XFile file) =>
    avatar_storage.saveLocalProfileAvatarFromPicker(uid, file);
