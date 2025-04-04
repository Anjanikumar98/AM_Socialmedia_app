import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String postId;
  String ownerId;
  String username;
  String location;
  String description;
  String mediaUrl;
  DateTime timestamp; // Properly parsed timestamp
  List<String> likes;
  List<Map<String, String>> comments;

  PostModel({
    required this.id,
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
  });

  /// 🔹 Convert Firestore JSON to Model (Handles Timestamp or String)
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      ownerId: json['ownerId'] ?? '',
      username: json['username'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown',
      description: json['description'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      timestamp:
          json['timestamp'] is Timestamp
              ? (json['timestamp'] as Timestamp).toDate()
              : DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
                  DateTime.now(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<Map<String, String>>.from(json['comments'] ?? []),
    );
  }

  /// 🔹 Convert API JSON to Model (Supports Local Assets)
  factory PostModel.fromApiJson(
    Map<String, dynamic> json, {
    bool isLocal = false,
  }) {
    int idValue = json['id'] ?? 0;
    return PostModel(
      id: idValue.toString(),
      postId: idValue.toString(),
      ownerId: "api_user",
      username: "API User",
      location: "Unknown",
      description: json['title']?.toString() ?? '',
      mediaUrl:
          isLocal
              ? "assets/images/${json['filename']}"
              : json['url']?.toString() ?? '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );
  }

  /// 🔹 Convert Model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'ownerId': ownerId,
      'username': username,
      'location': location,
      'description': description,
      'mediaUrl': mediaUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments,
    };
  }

  /// 🔹 Check if Media is Local Asset
  bool isLocalAsset() {
    return mediaUrl.startsWith("assets/");
  }
}
