import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Dummy current user ID (this would normally be fetched from Firebase Auth)
  String currentUserId() {
    return 'user123';
  }

  // Dummy list of notifications to show in the UI
  List<ActivityModel> notifications = [
    ActivityModel(
      id: '1',
      message: 'You have a new follower!',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ActivityModel(
      id: '2',
      message: 'John liked your post!',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    ActivityModel(
      id: '3',
      message: 'Your comment was liked!',
      timestamp: DateTime.now().subtract(Duration(minutes: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () => deleteAllItems(),
              child: Text(
                'CLEAR',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(children: [getActivities()]),
    );
  }

  // This method returns the list of notifications (dummy data)
  getActivities() {
    if (notifications.isEmpty) {
      return Center(child: Text('No notifications.'));
    }

    return Column(
      children:
          notifications.map((activity) {
            return ActivityItems(activity: activity);
          }).toList(),
    );
  }

  // This method clears all notifications in the list
  deleteAllItems() {
    setState(() {
      notifications.clear(); // Clear the notifications list locally
    });

    // Optionally show a confirmation message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('All notifications cleared')));
  }
}

// Dummy Model for Activity
class ActivityModel {
  final String id;
  final String message;
  final DateTime timestamp;

  ActivityModel({
    required this.id,
    required this.message,
    required this.timestamp,
  });

  // Factory method to create ActivityModel from JSON (for future extension)
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}

// Dummy Widget to display each activity
class ActivityItems extends StatelessWidget {
  final ActivityModel activity;

  ActivityItems({required this.activity});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMd().add_jm().format(
      activity.timestamp,
    );

    return ListTile(
      title: Text(activity.message),
      subtitle: Text(formattedDate),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          // Delete single notification from the list (locally)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Notification deleted')));
        },
      ),
    );
  }
}
