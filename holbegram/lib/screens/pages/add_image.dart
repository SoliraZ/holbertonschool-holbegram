import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../home.dart';
import 'methods/post_storage.dart';

const String _addImageIconUrl =
    'https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final TextEditingController _captionController = TextEditingController();
  final PostStorage _postStorage = PostStorage();
  Uint8List? _image;
  bool _isPosting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image_outlined, color: Colors.red),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  selectImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.red,
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  selectImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _post() async {
    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() {
      _isPosting = true;
    });

    final Users user = Provider.of<UserProvider>(
      context,
      listen: false,
    ).getUser;

    String res = await _postStorage.uploadPost(
      _captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) return;

    if (res == 'Ok') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    } else {
      setState(() {
        _isPosting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _post,
            child: _isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 28,
                      color: Colors.red,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Text(
                'Add Image',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose an image from your gallery or take a one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_image!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Image.network(
                            _addImageIconUrl,
                            width: 80,
                            height: 80,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
