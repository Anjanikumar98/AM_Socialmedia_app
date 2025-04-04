import 'package:flutter/material.dart';

class DummyProfileScreen extends StatelessWidget {
  final String profileId;

  DummyProfileScreen({required this.profileId});

  // Dummy data for 3 users
  final Map<String, Map<String, dynamic>> dummyUsers = {
    "user_1": {
      "username": "Anjanikumar Choubey",
      "photoUrl": "",
      "country": "USA",
      "email": "anjanikumar2314@gmail.com",
      "bio": "Loving life 🌸",
      "posts": 3,
      "followers": 15,
      "following": 10,
    },
    "user_2": {
      "username": "Kartikay",
      "photoUrl": "",
      "country": "Canada",
      "email": "kartikay1@gmail.com",
      "bio": "Flutter Dev 🚀",
      "posts": 6,
      "followers": 22,
      "following": 30,
    },
    "user_3": {
      "username": "Navneet ",
      "photoUrl": "",
      "country": "UK",
      "email": "navneet9@gmail.com",
      "bio": "Travel & Food ❤️",
      "posts": 2,
      "followers": 8,
      "following": 5,
    },
  };

  Widget buildCount(String label, int count) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = dummyUsers[profileId] ?? dummyUsers["user_1"]!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff886EE4),
        title: Text("AM SocialMedia App"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Dummy logout
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            user["username"][0],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user["username"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              user["country"],
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(user["email"], style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if ((user["bio"] as String).isNotEmpty)
                      Text(
                        user["bio"],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCount("POSTS", user["posts"]),
                        buildCount("FOLLOWERS", user["followers"]),
                        buildCount("FOLLOWING", user["following"]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(title: Text("All Posts"), trailing: Icon(Icons.grid_on)),
              // Replace with actual mock posts if needed
              Container(
                height: 150,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Text("Post grid goes here (mocked)"),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
