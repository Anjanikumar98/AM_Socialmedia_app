import 'dart:developer';
import 'dart:io';
import 'package:am_socialmedia_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final usersRef = FirebaseFirestore.instance.collection('users');

  // Get the authenticated user ID safely
  String? currentUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Upload an image to Firebase Storage
  Future<String> uploadImage(String folder, File image) async {
    try {
      String filePath = '$folder/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Upload failed: $e');
      return '';
    }
  }

  // Update user online status and last seen
  setUserStatus(bool isOnline) {
    String? uid = currentUid();
    if (uid != null) {
      usersRef.doc(uid).update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.now(),
      });
    }
  }

  // Update user profile safely
  updateProfile({
    File? image,
    String? username,
    String? bio,
    String? country,
  }) async {
    String? uid = currentUid();
    if (uid == null) return false;

    DocumentSnapshot doc = await usersRef.doc(uid).get();
    var users = UserModel.fromJson(doc.data() as Map<String, dynamic>);

    Map<String, dynamic> updatedData = {};

    if (username != null) updatedData['username'] = username;
    if (bio != null) updatedData['bio'] = bio;
    if (country != null) updatedData['country'] = country;

    if (image != null) {
      String imageUrl = await uploadImage("profilePic", image);
      updatedData['photoUrl'] = imageUrl;
    }

    if (updatedData.isNotEmpty) {
      await usersRef.doc(uid).update(updatedData);
    }

    return true;
  }
}
