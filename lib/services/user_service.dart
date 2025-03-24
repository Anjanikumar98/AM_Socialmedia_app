import 'dart:developer';
import 'dart:io';
import 'package:am_socialmedia_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  // Get the authenticated user ID
  String currentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  // Function to upload an image (replace with actual implementation)
  Future<String> uploadImage(String folder, File image) async {
    // Replace with actual logic to upload to Firebase Storage
    return "https://your-image-url.com/${image.path}";
  }

  // Tells when the user is online or not and updates the last seen for messages
  setUserStatus(bool isOnline) {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      usersRef.doc(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.now(),
      });
    }
  }

  // Updates user profile in the Edit Profile Screen
  updateProfile({
    File? image,
    String? username,
    String? bio,
    String? country,
  }) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    users.username = username;
    users.bio = bio;
    users.country = country;
    if (image != null) {
      users.photoUrl = await uploadImage("profilePic", image);
    }
    await usersRef.doc(currentUid()).update({
      'username': username,
      'bio': bio,
      'country': country,
      "photoUrl": users.photoUrl ?? '',
    });

    return true;
  }
}
