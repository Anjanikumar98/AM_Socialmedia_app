import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:am_socialmedia_app/models/post.dart';

class UserPost extends StatelessWidget {
  final PostModel post;

  const UserPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 User Profile & Post Time
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/am_nature.png", // Static image for now
              ),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(timeago.format(post.timestamp)),
            trailing: const Icon(Icons.more_vert),
          ),

          /// 🔹 Handle both Local & Network Images
          _buildPostImage(post),

          /// 🔹 Post Description
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(post.description, style: const TextStyle(fontSize: 14)),
          ),

          /// 🔹 Likes & Comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: post.likes.isNotEmpty ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 5),
                Text("${post.likes.length} likes"),
                const SizedBox(width: 20),
                const Icon(Icons.comment, color: Colors.grey),
                const SizedBox(width: 5),
                Text("${post.comments.length} comments"),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// 🔹 Helper: Show image from asset or network
  Widget _buildPostImage(PostModel post) {
    if (post.isLocalAsset()) {
      // print("Loading image: ${post.mediaUrl}");
      return Image.asset(
        post.mediaUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: post.mediaUrl,
        placeholder:
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (context, url, error) =>
                Image.asset("assets/images/placeholder.png"),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    }
  }
}
