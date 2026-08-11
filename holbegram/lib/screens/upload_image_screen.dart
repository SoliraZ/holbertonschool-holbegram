import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/holberton_logo.dart';

const String _defaultAvatarUrl =
    'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';

/// Shown once, right after signup, so the new user can pick a profile
/// picture before the account is actually created.
class AddPicture extends StatefulWidget {
  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  final String email;
  final String password;
  final String username;

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

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

  void _next(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Holbegram',
                style: GoogleFonts.lobster(
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const HolbertonLogo(size: 56),
              const SizedBox(height: 24),
              Text(
                'Hello, ${widget.username} Welcome to Holbegram.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose an image from your gallery or take a new one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 64,
                backgroundColor: const Color(0xFFEFEFEF),
                backgroundImage: _image != null
                    ? MemoryImage(_image!)
                    : const NetworkImage(_defaultAvatarUrl) as ImageProvider,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: selectImageFromGallery,
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: selectImageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _next(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
