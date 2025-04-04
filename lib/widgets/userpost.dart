import 'package:am_socialmedia_app/components/custom_card.dart';
import 'package:am_socialmedia_app/components/custom_image.dart';
import 'package:am_socialmedia_app/models/post.dart';
import 'package:am_socialmedia_app/models/user.dart';
import 'package:am_socialmedia_app/pages/profile.dart';
import 'package:am_socialmedia_app/screens/comment.dart';
import 'package:am_socialmedia_app/screens/view_image.dart';
import 'package:am_socialmedia_app/services/post_service.dart';
import 'package:am_socialmedia_app/utils/firebase.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatelessWidget {
  final PostModel? post;

  UserPost({this.post});

  final DateTime timestamp = DateTime.now();

  currentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  final PostService services = PostService();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () {},
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return ViewImage(post: post);
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onClosed: (v) {},
        closedColor: Theme.of(context).cardColor,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: CustomImage(
                      imageUrl: post?.mediaUrl ?? '',
                      height: 350.0,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.0,
                      vertical: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Row(
                            children: [
                              buildLikeButton(),
                              SizedBox(width: 5.0),
                              InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) => Comments(post: post),
                                    ),
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: StreamBuilder(
                                  stream:
                                      likesRef
                                          .where(
                                            'postId',
                                            isEqualTo: post!.postId,
                                          )
                                          .snapshots(),
                                  builder: (
                                    context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot snap = snapshot.data!;
                                      List<DocumentSnapshot> docs = snap.docs;
                                      return buildLikesCount(
                                        context,
                                        docs.length,
                                      );
                                    } else {
                                      return buildLikesCount(context, 0);
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            StreamBuilder(
                              stream:
                                  commentRef
                                      .doc(post!.postId)
                                      .collection("comments")
                                      .snapshots(),
                              builder: (
                                context,
                                AsyncSnapshot<QuerySnapshot> snapshot,
                              ) {
                                if (snapshot.hasData) {
                                  QuerySnapshot snap = snapshot.data!;
                                  List<DocumentSnapshot> docs = snap.docs;
                                  return buildCommentsCount(
                                    context,
                                    docs.length,
                                  );
                                } else {
                                  return buildCommentsCount(context, 0);
                                }
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: post!.description.toString().isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3.0),
                            child: Text(
                              post?.description ?? "",
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color, // caption
                                fontSize: 15.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            timeago.format(
                              post!.timestamp,
                            ), // No need for .toDate()
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ),
                        // SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ],
              ),
              buildUser(context),
            ],
          );
        },
      ),
    );
  }

  buildLikeButton() {
    final likesRef = FirebaseFirestore.instance
        .collection('statusRef')
        .doc(post!.postId)
        .collection('likes');

    return StreamBuilder<QuerySnapshot>(
      stream: likesRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // If no data is available, show the like button immediately (no loading indicator)
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LikeButton(
                isLiked: false, // Assume not liked initially
                onTap: (currentLiked) async {
                  // Simulate the like action for mock posts
                  print(
                    'Mock post like action: ${currentLiked ? 'Remove' : 'Add'} like',
                  );
                  return !currentLiked; // Toggle mock like state
                },
                size: 25.0,
                circleColor: CircleColor(
                  start: Color(0xffFFC0CB),
                  end: Color(0xffff0000),
                ),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Color(0xffFFA500),
                  dotSecondaryColor: Color(0xffd8392b),
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    isLiked ? Ionicons.heart : Ionicons.heart_outline,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 25,
                  );
                },
              ),
              const SizedBox(width: 5),
              buildLikesCount(
                context,
                0,
              ), // No likes count since it's a mock post
              const SizedBox(width: 20),
              Icon(Icons.comment, color: Colors.grey, size: 18),
              const SizedBox(width: 5),
              buildCommentsCount(context, 0), // No comments for mock post
            ],
          );
        }

        // Proceed with the real data if it's available
        final isLiked = snapshot.data!.docs.any(
          (doc) => doc['userId'] == currentUserId(),
        );
        int likesCount = snapshot.data!.docs.length;

        Future<bool> onLikeButtonTapped(bool currentLiked) async {
          if (!currentLiked) {
            // Add like
            await likesRef.add({
              'userId': currentUserId(),
              'dateCreated': Timestamp.now(),
            });
            await addLikesToNotification();
            return true;
          } else {
            // Remove like
            final docId =
                snapshot.data!.docs
                    .firstWhere((doc) => doc['userId'] == currentUserId())
                    .id;
            await likesRef.doc(docId).delete();

            // Remove notification
            services.removeLikeFromNotification(
              post!.ownerId,
              post!.postId,
              currentUserId(),
            );
            return false;
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LikeButton(
              isLiked: isLiked,
              onTap: onLikeButtonTapped,
              size: 25.0,
              circleColor: CircleColor(
                start: Color(0xffFFC0CB),
                end: Color(0xffff0000),
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xffFFA500),
                dotSecondaryColor: Color(0xffd8392b),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? Ionicons.heart : Ionicons.heart_outline,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 25,
                );
              },
            ),
            const SizedBox(width: 5),
            buildLikesCount(context, likesCount),
            const SizedBox(width: 20),
            Icon(Icons.comment, color: Colors.grey, size: 18),
            const SizedBox(width: 5),
            buildCommentsCount(context, post!.comments.length),
          ],
        );
      },
    );
  }

  addLikesToNotification() async {
    bool isNotMe = currentUserId() != post!.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      services.addLikesToNotification(
        "like",
        user!.username!,
        currentUserId(),
        post!.postId,
        post!.mediaUrl,
        post!.ownerId,
        user!.photoUrl!,
      );
    }
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
      ),
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        '-   $count comments',
        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  buildUser(BuildContext context) {
    bool isMe = currentUserId() == post!.ownerId;

    return StreamBuilder<DocumentSnapshot>(
      stream: usersRef.doc(post!.ownerId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Or a loader if needed
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Container(); // Data not found
        }

        UserModel user = UserModel.fromJson(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        return Visibility(
          visible: !isMe,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: GestureDetector(
                onTap: () => showProfile(context, profileId: user.id!),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      user.photoUrl!.isEmpty
                          ? CircleAvatar(
                            radius: 20.0,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Text(
                              user.username![0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          )
                          : CircleAvatar(
                            radius: 20.0,
                            backgroundImage: CachedNetworkImageProvider(
                              user.photoUrl!,
                            ),
                          ),
                      const SizedBox(width: 8.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post?.username ?? "Anjanikumar",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            post?.location ?? 'PUNE',
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => Profile(profileId: profileId)),
    );
  }
}

// buildLikeButton() {
//     return StreamBuilder(
//       stream:
//           likesRef
//               .where('postId', isEqualTo: post!.postId)
//               .where('userId', isEqualTo: currentUserId())
//               .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasData) {
//           List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
//
//           ///replaced this with an animated like button
//           // return IconButton(
//           //   onPressed: () {
//           //     if (docs.isEmpty) {
//           //       likesRef.add({
//           //         'userId': currentUserId(),
//           //         'postId': post!.postId,
//           //         'dateCreated': Timestamp.now(),
//           //       });
//           //       addLikesToNotification();
//           //     } else {
//           //       likesRef.doc(docs[0].id).delete();
//           //       services.removeLikeFromNotification(
//           //           post!.ownerId!, post!.postId!, currentUserId());
//           //     }
//           //   },
//           //   icon: docs.isEmpty
//           //       ? Icon(
//           //           CupertinoIcons.heart,
//           //         )
//           //       : Icon(
//           //           CupertinoIcons.heart_fill,
//           //           color: Colors.red,
//           //         ),
//           // );
//           Future<bool> onLikeButtonTapped(bool isLiked) async {
//             if (docs.isEmpty) {
//               likesRef.add({
//                 'userId': currentUserId(),
//                 'postId': post!.postId,
//                 'dateCreated': Timestamp.now(),
//               });
//               addLikesToNotification();
//               return !isLiked;
//             } else {
//               likesRef.doc(docs[0].id).delete();
//               services.removeLikeFromNotification(
//                 post!.ownerId,
//                 post!.postId,
//                 currentUserId(),
//               );
//               return isLiked;
//             }
//           }
//
//           return LikeButton(
//             onTap: onLikeButtonTapped,
//             size: 25.0,
//             circleColor: CircleColor(
//               start: Color(0xffFFC0CB),
//               end: Color(0xffff0000),
//             ),
//             bubblesColor: BubblesColor(
//               dotPrimaryColor: Color(0xffFFA500),
//               dotSecondaryColor: Color(0xffd8392b),
//               dotThirdColor: Color(0xffFF69B4),
//               dotLastColor: Color(0xffff8c00),
//             ),
//             likeBuilder: (bool isLiked) {
//               return Icon(
//                 docs.isEmpty ? Ionicons.heart_outline : Ionicons.heart,
//                 color:
//                     docs.isEmpty
//                         ? Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white
//                             : Colors.black
//                         : Colors.red,
//                 size: 25,
//               );
//             },
//           );
//         }
//         return Container();
//       },
//     );
//   }
