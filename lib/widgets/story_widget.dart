import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust avatar size based on screen width
    double avatarRadius = screenWidth * 0.12; // 12% of screen width

    final List<Map<String, String>> mockStories = [
      {
        "userId": "1",
        "username": "Alice",
        "photoUrl": "https://randomuser.me/api/portraits/women/1.jpg",
        "storyId": "story_1",
      },
      {
        "userId": "2",
        "username": "Bob",
        "photoUrl": "https://randomuser.me/api/portraits/men/2.jpg",
        "storyId": "story_2",
      },
      {
        "userId": "3",
        "username": "Charlie",
        "photoUrl": "https://randomuser.me/api/portraits/men/3.jpg",
        "storyId": "story_3",
      },
      {
        "userId": "4",
        "username": "David",
        "photoUrl": "https://randomuser.me/api/portraits/men/4.jpg",
        "storyId": "story_4",
      },
    ];

    return SizedBox(
      height: avatarRadius * 2 + 45, // Slightly increased for better padding
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: mockStories.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (BuildContext context, int index) {
            var story = mockStories[index];

            return _buildStatusAvatar(
              context,
              story["userId"]!,
              story["storyId"]!,
              story["username"]!,
              story["photoUrl"]!,
              avatarRadius,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusAvatar(
    BuildContext context,
    String userId,
    String storyId,
    String username,
    String photoUrl,
    double avatarRadius,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => StatusScreen(userId: userId, storyId: storyId),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: CachedNetworkImageProvider(photoUrl),
              ),
            ),
          ),
          const SizedBox(height: 3),

          SizedBox(
            width: avatarRadius * 2,
            child: Text(
              username,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: avatarRadius * 0.35,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy StatusScreen (Replace with actual implementation)

class StatusScreen extends StatefulWidget {
  final String userId;
  final String storyId;

  const StatusScreen({Key? key, required this.userId, required this.storyId})
    : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  // Mock user data (Replace with Firestore data)
  final Map<String, dynamic> mockUserData = {
    "1": {
      "username": "Alice",
      "photoUrl": "https://randomuser.me/api/portraits/women/1.jpg",
    },
    "2": {
      "username": "Bob",
      "photoUrl": "https://randomuser.me/api/portraits/men/2.jpg",
    },
    "3": {
      "username": "Charlie",
      "photoUrl": "https://randomuser.me/api/portraits/men/3.jpg",
    },
    "4": {
      "username": "David",
      "photoUrl": "https://randomuser.me/api/portraits/men/4.jpg",
    },
  };

  // Mock stories for each user (Replace with Firestore data)
  final Map<String, List<Map<String, String>>> mockStories = {
    "1": [
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
        "caption": "Enjoying the sunset 🌅",
      },
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
        "caption": "Hiking adventure 🏔️",
      },
    ],
    "2": [
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1540747913346-19e32dc3e97e",
        "caption": "Night lights ✨",
      },
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1511919884226-fd3cad34687c",
        "caption": "Fast and Furious 🚗💨",
      },
    ],
    "3": [
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1511919884226-fd3cad34687c",
        "caption": "Fast and Furious 🚗💨",
      },
    ],
    "4": [
      {
        "imageUrl":
            "https://images.unsplash.com/photo-1522219406765-3e9f8e59d97b",
        "caption": "Relaxing at the beach 🏖️",
      },
    ],
  };

  void _onTap(TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.globalPosition.dx < screenWidth / 2) {
      // Tap left - go to previous story
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
        });
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pop(context); // Close screen if at first story
      }
    } else {
      // Tap right - go to next story
      if (_currentIndex < mockStories[widget.userId]!.length - 1) {
        setState(() {
          _currentIndex++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pop(context); // Close screen if at last story
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get correct user data
    var user =
        mockUserData[widget.userId] ?? {"username": "Unknown", "photoUrl": ""};
    var stories = mockStories[widget.userId] ?? [];

    return GestureDetector(
      onTapUp: _onTap,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          Navigator.pop(context); // Swipe down to exit
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Fullscreen Story Viewer
            PageView.builder(
              controller: _pageController,
              itemCount: stories.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: stories[index]["imageUrl"]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 50,
                      ),
                );
              },
            ),

            // Gradient Overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Combined top content: story progress + user info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story progress indicators
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: List.generate(stories.length, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    index <= _currentIndex
                                        ? Colors.white
                                        : Colors.white38,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // User info & close button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    user["photoUrl"]!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                          user["photoUrl"]!,
                                        )
                                        : null,
                                child:
                                    user["photoUrl"]!.isEmpty
                                        ? const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                user["username"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Caption
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                minimum: EdgeInsets.only(
                  bottom: 20,
                ), // adds some breathing room
                child: Text(
                  stories.isNotEmpty ? stories[_currentIndex]["caption"]! : "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class StoryWidget extends StatelessWidget {
//   const StoryWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100.0,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 5.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: userChatsStream(FirebaseAuth.instance.currentUser!.uid),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No Status Available'));
//             }
//
//             List chatList = snapshot.data!.docs;
//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               itemCount: chatList.length,
//               scrollDirection: Axis.horizontal,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemBuilder: (BuildContext context, int index) {
//                 DocumentSnapshot statusListSnapshot = chatList[index];
//
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: messageListStream(statusListSnapshot.id),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const SizedBox();
//                     }
//
//                     List statuses = snapshot.data!.docs;
//                     var statusData =
//                         statuses.first.data() as Map<String, dynamic>?;
//                     if (statusData == null) return const SizedBox();
//
//                     String? statusId = statusData["statusId"];
//                     List users = statusListSnapshot.get('whoCanSee');
//                     users.remove(FirebaseAuth.instance.currentUser!.uid);
//
//                     return _buildStatusAvatar(
//                       statusListSnapshot.get('userId'),
//                       statusListSnapshot.id,
//                       statusId!,
//                       index,
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusAvatar(
//     String userId,
//     String chatId,
//     String messageId,
//     int index,
//   ) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const SizedBox();
//         }
//
//         var userData = snapshot.data!.data() as Map<String, dynamic>?;
//         if (userData == null) return const SizedBox();
//
//         String username = userData['username'] ?? "Unknown";
//         String? photoUrl = userData['photoUrl'];
//
//         return Padding(
//           padding: const EdgeInsets.only(right: 10.0),
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder:
//                           (_) => StatusScreen(
//                             statusId: chatId,
//                             storyId: messageId,
//                             initPage: index,
//                             userId: userId,
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         offset: const Offset(0.0, 0.0),
//                         blurRadius: 2.0,
//                         spreadRadius: 0.0,
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     radius: 35.0,
//                     backgroundColor: Colors.grey,
//                     backgroundImage:
//                         photoUrl != null && photoUrl.isNotEmpty
//                             ? CachedNetworkImageProvider(photoUrl)
//                             : const AssetImage('assets/default_avatar.png')
//                                 as ImageProvider,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 username,
//                 style: const TextStyle(
//                   fontSize: 10.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Stream<QuerySnapshot> userChatsStream(String uid) {
//     return FirebaseFirestore.instance
//         .collection('status')
//         .where('whoCanSee', arrayContains: uid)
//         .snapshots();
//   }
//
//   Stream<QuerySnapshot> messageListStream(String documentId) {
//     return FirebaseFirestore.instance
//         .collection('status')
//         .doc(documentId)
//         .collection('statuses')
//         .snapshots();
//   }
// }
