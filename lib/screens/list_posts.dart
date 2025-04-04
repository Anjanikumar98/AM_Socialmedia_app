import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../models/post.dart';
import '../utils/firebase.dart';
import '../widgets/indicators.dart';
import '../widgets/userpost.dart';

class ListPosts extends StatefulWidget {
  final userId;

  final username;

  const ListPosts({Key? key, required this.userId, required this.username})
    : super(key: key);

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Ionicons.chevron_back),
        ),
        title: Column(
          children: [
            Text(
              widget.username.toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              'Posts',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future:
              postRef
                  .where('ownerId', isEqualTo: widget.userId)
                  // .orderBy('timestamp', descending: true) // 🔴 Remove if index is not ready
                  .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress(context);
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Feeds',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              );
            }

            var snap = snapshot.data!;
            List docs = snap.docs;

            // 🔵 Manually sort by timestamp (if index is not ready)
            docs.sort(
              (a, b) => (b['timestamp'] as Timestamp).compareTo(
                a['timestamp'] as Timestamp,
              ),
            );

            return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var postData = docs[index].data() as Map<String, dynamic>;
                PostModel posts = PostModel.fromJson(
                  postData,
                ); // ✅ Cast explicitly
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: UserPost(post: posts),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
