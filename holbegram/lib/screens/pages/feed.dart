import 'package:flutter/material.dart';

import '../../utils/posts.dart';
import '../../widgets/holberton_logo.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 32),
            ),
            const SizedBox(width: 4),
            const HolbertonLogo(size: 24),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: const Posts(),
    );
  }
}
