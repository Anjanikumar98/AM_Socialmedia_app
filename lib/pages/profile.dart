import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../auth/register/register.dart';
import '../components/stream_grid_wrapper.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../screens/edit_profile.dart';
import '../screens/list_posts.dart';
import '../screens/settings.dart';
import '../utils/firebase.dart';
import '../widgets/post_tiles.dart';

class Profile extends StatefulWidget {
  final profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool isLoading = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  UserModel? users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  // currentUserId() {
  //   return firebaseAuth.currentUser?.uid;
  // }

  // Dummy current user ID (this would be fetched from Firebase Auth)
  currentUserId() {
    return 'user123';
  }

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc =
        await followersRef
            .doc(widget.profileId)
            .collection('userFollowers')
            .doc(currentUserId())
            .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Removes shadow for a clean look
        backgroundColor: Color(0xff886EE4), // Modern color touch
        title: Text(
          'AM SocialMedia App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        actions: [
          if (widget.profileId == firebaseAuth.currentUser!.uid)
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await firebaseAuth.signOut();
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
              ),
            ),
        ],
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            toolbarHeight: 5.0,
            collapsedHeight: 6.0,
            expandedHeight: 225.0,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: usersRef.doc(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    // Dummy data when no user data is available
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Center(
                                  child: Text(
                                    "A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 31.0),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 130.0,
                                          child: Text(
                                            "Anjanikumar ",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 130.0,
                                          child: Text(
                                            "India",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "anjanikumar2314@gmail.com",
                                              style: TextStyle(fontSize: 10.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    widget.profileId == currentUserId()
                                        ? InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                builder: (_) => Setting(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Ionicons.settings_outline,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                              ),
                                              Text(
                                                'settings',
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : const Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Container(
                            width: 200,
                            child: Text(
                              "I am Anjanikumar from India",
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                buildCount("POSTS", 2), // Dummy posts count
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.grey,
                                  ),
                                ),
                                buildCount(
                                  "FOLLOWERS",
                                  2,
                                ), // Dummy followers count
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.grey,
                                  ),
                                ),
                                buildCount(
                                  "FOLLOWING",
                                  1,
                                ), // Dummy following count
                              ],
                            ),
                          ),
                        ),
                        buildProfileButton(
                          UserModel(username: "Dummy User"),
                        ), // Dummy button
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>,
                    );
                    // The existing code to display actual user data goes here
                  }
                  return Container();
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              if (index > 0) return null;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          'All Posts',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            DocumentSnapshot doc =
                                await usersRef.doc(widget.profileId).get();
                            if (doc.exists) {
                              var currentUser = UserModel.fromJson(
                                doc.data() as Map<String, dynamic>,
                              );
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder:
                                      (_) => ListPosts(
                                        userId: widget.profileId,
                                        username: currentUser.username,
                                      ),
                                ),
                              );
                            } else {
                              // Fallback to a default action or show a message if no user found
                              print("No user found for the profile.");
                            }
                          },
                          icon: Icon(Ionicons.grid_outline),
                        ),
                      ],
                    ),
                  ),
                  // If actual posts are available, use the following code,
                  // otherwise, show dummy posts.
                  StreamBuilder(
                    stream:
                        postRef
                            .where('ownerId', isEqualTo: widget.profileId)
                            .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        // Show dummy posts if no data is found
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Text(
                                "No posts available",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              color: Colors.grey[200],
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Everything is going well, by the grace of God.",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  // Image for Post 1
                                  Image.asset(
                                    'assets/images/am_sunset.png',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              color: Colors.grey[200],
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "At Park",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  // Image for Post 2
                                  Image.asset(
                                    'assets/images/central_park.jpg',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      if (snapshot.hasData) {
                        QuerySnapshot<Object?>? snap = snapshot.data;
                        List<DocumentSnapshot> docs = snap!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (context, postIndex) {
                            var post = docs[postIndex];
                            // Replace the following with your actual post view code
                            return FutureBuilder<DocumentSnapshot>(
                              future: postRef.doc(post.id).get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data?.data() == null) {
                                  return Center(
                                    child: Text("No post data available"),
                                  );
                                }

                                PostModel postData = PostModel.fromJson(
                                  snapshot.data!.data() as Map<String, dynamic>,
                                );

                                return PostTile(post: postData);
                              },
                            );
                          },
                        );
                      }

                      return Container(); // Default container if no data is available
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
        SizedBox(height: 3.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
      ],
    );
  }

  buildProfileButton(user) {
    //if isMe then display "edit profile"
    bool isMe = widget.profileId == firebaseAuth.currentUser!.uid;
    if (isMe) {
      return buildButton(
        text: "Edit Profile",
        function: () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (_) => EditProfile(user: user)));
        },
      );
      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollow);
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildButton(text: "Follow", function: handleFollow);
    }
  }

  buildButton({String? text, Function()? function}) {
    return Center(
      child: GestureDetector(
        onTap: function!,
        child: Container(
          height: 40.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Color(0xff597FDB),
              ],
            ),
          ),
          child: Center(
            child: Text(text!, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  handleUnfollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = false;
    });
    //remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
    //remove following
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
    //remove from notifications feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .get()
        .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
  }

  handleFollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = true;
    });
    //updates the followers collection of the followed user
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({});
    //updates the following collection of the currentUser
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    //update the notification feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .set({
          "type": "follow",
          "ownerId": widget.profileId,
          "username": users?.username,
          "userId": users?.id,
          "userDp": users?.photoUrl,
          "timestamp": timestamp,
        });
  }

  buildPostView() {
    return buildGridPost();
  }

  buildGridPost() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          postRef
              .where('ownerId', isEqualTo: widget.profileId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Show dummy posts if no posts are found
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "No posts available",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Post 1: Everything is going good by blessing of god.",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    // Image for Post 1
                    Image.asset(
                      'assets/images/am_sunset.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Post 2: At Park", style: TextStyle(fontSize: 14.0)),
                    SizedBox(height: 10.0),
                    // Image for Post 2
                    Image.asset(
                      'assets/images/central_park.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        // If posts are available, display them in a grid
        List<DocumentSnapshot> posts = snapshot.data!.docs;
        return StreamGridWrapper(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          stream:
              postRef
                  .where('ownerId', isEqualTo: widget.profileId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, DocumentSnapshot snapshot) {
            PostModel post = PostModel.fromJson(
              snapshot.data() as Map<String, dynamic>,
            );
            return PostTile(post: post);
          },
        );
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream:
          favUsersRef
              .where('postId', isEqualTo: widget.profileId)
              .where('userId', isEqualTo: currentUserId())
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
          return GestureDetector(
            onTap: () {
              if (docs.isEmpty) {
                favUsersRef.add({
                  'userId': currentUserId(),
                  'postId': widget.profileId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                favUsersRef.doc(docs[0].id).delete();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  docs.isEmpty
                      ? CupertinoIcons.heart
                      : CupertinoIcons.heart_fill,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
