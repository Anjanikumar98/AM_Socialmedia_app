import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../utils/firebase.dart';

class PostService {
  String postId = Uuid().v4();

  // Function to upload an image (replace with actual implementation)
  Future<String> uploadImage(String folder, File image) async {
    // Replace with actual logic to upload to Firebase Storage
    return "https://your-image-url.com/${image.path}";
  }

  // Uploads profile picture to the users collection
  uploadProfilePicture(File image, User user) async {
    String link = await uploadImage("profilePic", image);
    var ref = usersRef.doc(user.uid);
    ref.update({"photoUrl": link});
  }

  // Uploads post to the post collection
  uploadPost(File image, String location, String description) async {
    String link = await uploadImage("posts", image);
    DocumentSnapshot doc =
        await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    var user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    var ref = postRef.doc();
    ref
        .set({
          "id": ref.id,
          "postId": ref.id,
          "username": user.username,
          "ownerId": FirebaseAuth.instance.currentUser!.uid,
          "mediaUrl": link,
          "description": description,
          "location": location,
          "timestamp": Timestamp.now(),
        })
        .catchError((e) {
          print(e);
        });
  }

  // Upload a comment
  uploadComment(
    String currentUserId,
    String comment,
    String postId,
    String ownerId,
    String mediaUrl,
  ) async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    var user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    await commentRef.doc(postId).collection("comments").add({
      "username": user.username,
      "comment": comment,
      "timestamp": Timestamp.now(),
      "userDp": user.photoUrl,
      "userId": user.id,
    });
    bool isNotMe = ownerId != currentUserId;
    if (isNotMe) {
      addCommentToNotification(
        "comment",
        comment,
        user.username!,
        user.id!,
        postId,
        mediaUrl,
        ownerId,
        user.photoUrl!,
      );
    }
  }

  // Add the comment to notification collection
  addCommentToNotification(
    String type,
    String commentData,
    String username,
    String userId,
    String postId,
    String mediaUrl,
    String ownerId,
    String userDp,
  ) async {
    await notificationRef.doc(ownerId).collection('notifications').add({
      "type": type,
      "commentData": commentData,
      "username": username,
      "userId": userId,
      "userDp": userDp,
      "postId": postId,
      "mediaUrl": mediaUrl,
      "timestamp": Timestamp.now(),
    });
  }

  // Add likes to the notification collection
  addLikesToNotification(
    String type,
    String username,
    String userId,
    String postId,
    String mediaUrl,
    String ownerId,
    String userDp,
  ) async {
    await notificationRef
        .doc(ownerId)
        .collection('notifications')
        .doc(postId)
        .set({
          "type": type,
          "username": username,
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "userDp": userDp,
          "postId": postId,
          "mediaUrl": mediaUrl,
          "timestamp": Timestamp.now(),
        });
  }

  // Remove likes from notification
  removeLikeFromNotification(
    String ownerId,
    String postId,
    String currentUser,
  ) async {
    bool isNotMe = currentUser != ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUser).get();
      var user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      notificationRef
          .doc(ownerId)
          .collection('notifications')
          .doc(postId)
          .get()
          .then(
            (doc) => {
              if (doc.exists) {doc.reference.delete()},
            },
          );
    }
  }
}

// class PostService extends Service {
//   String postId = Uuid().v4();
//
// //uploads profile picture to the users collection
//   uploadProfilePicture(File image, User user) async {
//     String link = await uploadImage(profilePic, image);
//     var ref = usersRef.doc(user.uid);
//     ref.update({
//       "photoUrl": link,
//     });
//   }
//
// //uploads post to the post collection
//   uploadPost(File image, String location, String description) async {
//     String link = await uploadImage(posts, image);
//     DocumentSnapshot doc =
//         await usersRef.doc(firebaseAuth.currentUser!.uid).get();
//     user = UserModel.fromJson(
//       doc.data() as Map<String, dynamic>,
//     );
//     var ref = postRef.doc();
//     ref.set({
//       "id": ref.id,
//       "postId": ref.id,
//       "username": user!.username,
//       "ownerId": firebaseAuth.currentUser!.uid,
//       "mediaUrl": link,
//       "description": description ?? "",
//       "location": location ?? "Wooble",
//       "timestamp": Timestamp.now(),
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
// //upload a comment
//   uploadComment(String currentUserId, String comment, String postId,
//       String ownerId, String mediaUrl) async {
//     DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
//     user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
//     await commentRef.doc(postId).collection("comments").add({
//       "username": user!.username,
//       "comment": comment,
//       "timestamp": Timestamp.now(),
//       "userDp": user!.photoUrl,
//       "userId": user!.id,
//     });
//     bool isNotMe = ownerId != currentUserId;
//     if (isNotMe) {
//       addCommentToNotification("comment", comment, user!.username!, user!.id!,
//           postId, mediaUrl, ownerId, user!.photoUrl!);
//     }
//   }
//
// //add the comment to notification collection
//   addCommentToNotification(
//       String type,
//       String commentData,
//       String username,
//       String userId,
//       String postId,
//       String mediaUrl,
//       String ownerId,
//       String userDp) async {
//     await notificationRef.doc(ownerId).collection('notifications').add({
//       "type": type,
//       "commentData": commentData,
//       "username": username,
//       "userId": userId,
//       "userDp": userDp,
//       "postId": postId,
//       "mediaUrl": mediaUrl,
//       "timestamp": Timestamp.now(),
//     });
//   }
//
// //add the likes to the notfication collection
//   addLikesToNotification(String type, String username, String userId,
//       String postId, String mediaUrl, String ownerId, String userDp) async {
//     await notificationRef
//         .doc(ownerId)
//         .collection('notifications')
//         .doc(postId)
//         .set({
//       "type": type,
//       "username": username,
//       "userId": firebaseAuth.currentUser!.uid,
//       "userDp": userDp,
//       "postId": postId,
//       "mediaUrl": mediaUrl,
//       "timestamp": Timestamp.now(),
//     });
//   }
//
//   //remove likes from notification
//   removeLikeFromNotification(
//       String ownerId, String postId, String currentUser) async {
//     bool isNotMe = currentUser != ownerId;
//
//     if (isNotMe) {
//       DocumentSnapshot doc = await usersRef.doc(currentUser).get();
//       user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
//       notificationRef
//           .doc(ownerId)
//           .collection('notifications')
//           .doc(postId)
//           .get()
//           .then((doc) => {
//                 if (doc.exists) {doc.reference.delete()}
//               });
//     }
//   }
// }
