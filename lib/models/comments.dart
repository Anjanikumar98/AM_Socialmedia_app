import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? username;
  String? comment;
  Timestamp? timestamp;
  String? userDp;
  String? userId;

  CommentModel({
    this.username,
    this.comment,
    this.timestamp,
    this.userDp,
    this.userId,
  });

  // Factory constructor with null safety and type casting
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      username: json['username'] as String?,
      comment: json['comment'] as String?,
      timestamp: json['timestamp'] is Timestamp ? json['timestamp'] : null,
      userDp: json['userDp'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'comment': comment,
      'timestamp': timestamp ?? Timestamp.now(),
      'userDp': userDp,
      'userId': userId,
    };
  }
}
