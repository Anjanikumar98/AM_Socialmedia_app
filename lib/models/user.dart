import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? photoUrl;
  String? country;
  String? bio;
  String? id;
  DateTime? signedUpAt;
  DateTime? lastSeen;
  bool? isOnline;

  UserModel({
    this.username,
    this.email,
    this.id,
    this.photoUrl,
    this.signedUpAt,
    this.isOnline,
    this.lastSeen,
    this.bio,
    this.country,
  });

  /// 🔹 Convert Firestore JSON to UserModel (Handles Timestamp or String)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      country: json['country'],
      photoUrl: json['photoUrl'],
      signedUpAt: _convertToDateTime(json['signedUpAt']),
      lastSeen: _convertToDateTime(json['lastSeen']),
      isOnline: json['isOnline'] ?? false,
      bio: json['bio'],
      id: json['id'],
    );
  }

  /// 🔹 Convert Model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'country': country,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'signedUpAt': signedUpAt != null ? Timestamp.fromDate(signedUpAt!) : null,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'isOnline': isOnline ?? false,
      'id': id,
    };
  }

  /// 🔹 Helper to safely convert Firestore Timestamps or String to DateTime
  static DateTime? _convertToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
