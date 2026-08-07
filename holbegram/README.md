# Holbegram

A Flutter (Android) clone of Instagram's core flow, built with Firebase
(Authentication + Firestore).

## Features

- Email/password sign up and login (Firebase Auth)
- User profile stored in Cloud Firestore
- Profile picture step after signup (UI ready, upload wiring pending)

## Project structure

```text
lib/
  main.dart                    # App entry point, Firebase init, auth gate
  screens/
    login_screen.dart          # Login screen
    signup_screen.dart         # Sign up screen
    upload_image_screen.dart   # Post-signup "add a profile picture" step
  widgets/
    text_field.dart            # Shared rounded text field used on auth screens
  services/
    auth_service.dart          # Firebase Auth wrapper (sign up / sign in / sign out)
    firestore_service.dart     # Firestore user profile read/write
```

## Local configuration (not committed)

These files are required to run the app and are gitignored on purpose
(they contain your own Firebase project credentials):

- `android/app/google-services.json`
- `lib/firebase_options.dart`

## Getting started

```powershell
flutter pub get
flutter devices
flutter run
```

## Notes

- `firebase_database` and `cloudinary_flutter` are installed as
  dependencies but are not wired up yet — user data currently lives in
  Firestore, and profile picture upload is a placeholder pending a
  Cloudinary account.
- The "Sign in with Google" button on the login screen is UI-only for
  now (Google sign-in is not enabled in the Firebase console yet).
