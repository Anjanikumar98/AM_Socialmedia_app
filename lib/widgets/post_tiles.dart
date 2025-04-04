import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/view_image.dart';
import 'cached_image.dart';

class PostTile extends StatefulWidget {
  final PostModel? post;

  PostTile({this.post});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the image view page when tapped
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => ViewImage(post: widget.post)),
        );
      },
      child: Container(
        height: 100, // Adjust the height for your design
        width: 150, // Adjust the width for your design
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
          ),
          elevation: 5, // Elevation to create a shadow effect
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            // Check if the mediaUrl is a network URL or an asset path
            child:
                widget.post?.mediaUrl != null &&
                        widget.post!.mediaUrl.isNotEmpty
                    ? widget.post!.mediaUrl.startsWith('http')
                        ? cachedNetworkImage(
                          widget.post!.mediaUrl,
                        ) // For network image
                        : Image.asset(
                          widget.post!.mediaUrl, // For asset image
                          fit: BoxFit.cover,
                        )
                    : Center(child: Icon(Icons.image_not_supported)),
          ),
        ),
      ),
    );
  }
}

Widget cachedNetworkImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    fit: BoxFit.cover, // Ensures the image fits properly inside the container
  );
}
