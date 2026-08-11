import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../models/post.dart';
import '../../auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = 'Some error occurred';
    try {
      String postUrl = await StorageMethods().uploadImageToStorage(
        true,
        'posts',
        image,
      );
      String postId = const Uuid().v1();
      String publicId = _publicIdFromUrl(postUrl);

      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set({
        ...post.toJson(),
        'publicId': publicId,
      });

      res = 'Ok';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId, String publicId) async {
    await _firestore.collection('posts').doc(postId).delete();

    try {
      final uri = Uri.parse(
        StorageMethods().cloudinaryUrl.replaceFirst('/upload', '/destroy'),
      );
      await http.post(uri, body: {'public_id': publicId});
    } catch (_) {
      // Deleting a Cloudinary asset requires a signed admin request; without
      // exposing the API secret on the client, this call is best-effort only.
    }
  }

  // Cloudinary embeds the (folder-prefixed) public_id in the delivery URL,
  // right after the optional "v<version>" segment and before the extension.
  String _publicIdFromUrl(String url) {
    final segments = Uri.parse(url).pathSegments;
    final uploadIndex = segments.indexOf('upload');
    if (uploadIndex == -1 || uploadIndex + 1 >= segments.length) return '';

    var rest = segments.sublist(uploadIndex + 1);
    if (rest.isNotEmpty && RegExp(r'^v\d+$').hasMatch(rest.first)) {
      rest = rest.sublist(1);
    }

    final path = rest.join('/');
    final dotIndex = path.lastIndexOf('.');
    return dotIndex == -1 ? path : path.substring(0, dotIndex);
  }
}
