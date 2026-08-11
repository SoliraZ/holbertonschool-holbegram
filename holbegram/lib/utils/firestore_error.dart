import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Renders an error coming from a Firestore [StreamBuilder].
///
/// Signing out while a screen still has an active Firestore listener makes
/// the listener briefly receive a `permission-denied` error (the security
/// rules re-evaluate it against the now-null auth state right before the
/// widget tree is torn down). That case is expected and about to resolve
/// itself, so it's shown as a loading state instead of a scary error.
Widget buildStreamError(Object? error) {
  if (error is FirebaseException && error.code == 'permission-denied') {
    return const Center(child: CircularProgressIndicator());
  }
  return Center(child: Text('Error $error'));
}
