import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown once, right after signup, so the new user can set a profile
/// picture. Cloudinary is installed as a dependency but no account has
/// been configured yet, so picking/uploading is a placeholder for now.
class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key, required this.displayName});

  final String displayName;

  void _pickFromGallery(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Choisir depuis la galerie : à venir')),
    );
  }

  void _pickFromCamera(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prendre une photo : à venir')),
    );
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
              const Icon(Icons.mode_of_travel, color: Colors.red, size: 32),
              const SizedBox(height: 24),
              Text(
                'Hello, $displayName Welcome to Holbegram.',
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
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFEFEFEF),
                child: Icon(Icons.person, size: 60, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => _pickFromGallery(context),
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _pickFromCamera(context),
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
