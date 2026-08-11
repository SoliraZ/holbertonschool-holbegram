import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final List<String> savedIds = Provider.of<UserProvider>(
      context,
    ).getUser.saved.cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontFamily: 'Billabong', fontSize: 32),
        ),
      ),
      body: savedIds.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where(FieldPath.documentId, whereIn: savedIds)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;

                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data[index]['postUrl'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
