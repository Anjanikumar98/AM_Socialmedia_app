import 'package:am_socialmedia_app/new_posts/mockposts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import '../chats/recent_chats.dart';
import '../models/post.dart';
import '../utils/constants.dart';
import '../widgets/indicators.dart';
import '../widgets/story_widget.dart';
import '../widgets/userpost.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CollectionReference postRef = FirebaseFirestore.instance.collection(
    'posts',
  );
  final String apiUrl =
      'https://jsonplaceholder.typicode.com/photos'; // Example API

  int page = 5;
  bool loadingMore = false;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  List<PostModel> postsList = [];
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    // Add a short delay to ensure the widget is fully built before loading data
    Future.delayed(Duration(milliseconds: 100), () {
      loadPosts();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!loadingMore && hasMoreData) {
          setState(() {
            loadingMore = true;
            page = page + 5;
          });
          //    loadMorePosts();
        }
      }
    });
  }

  Future<void> loadPosts() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      postsList = [];
    });

    // First, load mock posts
    List<PostModel> mockData = getMockPosts();

    try {
      // Start with mock data
      if (!mounted) return;

      setState(() {
        postsList = mockData;
      });

      // Then fetch API posts in the background
      try {
        final apiPosts = await fetchApiPosts(
          0,
          page,
        ).timeout(Duration(seconds: 5));

        // Ensure we're still mounted before updating state
        if (!mounted) return;

        // Add API posts to the existing mock posts
        setState(() {
          postsList = [...mockData, ...apiPosts];
          isLoading = false;
        });
      } catch (e) {
        print('API fetch error: $e');
        // If API fetch fails, we'll still show the mock posts
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in loadPosts: $e');

      // Ensure we're still mounted before updating state
      if (!mounted) return;

      // Always fall back to mock data on any error
      setState(() {
        print('Falling back to mock data due to error');
        postsList = mockData;
        isLoading = false;
      });
    }
  }

  // Future<void> loadMorePosts() async {
  //   if (!mounted) return;
  //
  //   try {
  //     // Calculate how many API posts we have already
  //     int currentApiCount = 0;
  //
  //     for (var post in postsList) {
  //       if (post.ownerId == "api_user") {
  //         currentApiCount++;
  //       }
  //     }
  //
  //     // Get more API posts
  //     List<PostModel> newApiPosts = [];
  //     try {
  //       newApiPosts = await fetchApiPosts(
  //         currentApiCount,
  //         5,
  //       ).timeout(Duration(seconds: 5));
  //     } catch (e) {
  //       print('Error loading more API posts: $e');
  //     }
  //
  //     // Ensure we're still mounted before updating state
  //     if (!mounted) return;
  //
  //     setState(() {
  //       if (newApiPosts.isEmpty) {
  //         // If we didn't get any new posts, we've reached the end
  //         hasMoreData = false;
  //       } else {
  //         postsList.addAll(newApiPosts);
  //       }
  //       loadingMore = false;
  //     });
  //   } catch (e) {
  //     print('Error in loadMorePosts: $e');
  //
  //     // Ensure we're still mounted before updating state
  //     if (!mounted) return;
  //
  //     setState(() {
  //       loadingMore = false;
  //
  //       // If loading more fails, add a couple of mock posts to demonstrate pagination
  //       int nextId = postsList.length + 1;
  //       postsList.add(
  //         PostModel(
  //           id: 'mock_$nextId',
  //           postId: 'mock_$nextId',
  //           ownerId: 'local_user_backup',
  //           username: 'backup_user',
  //           location: 'Backup Location',
  //           description: 'This is a backup post when loading more fails',
  //           mediaUrl: 'assets/images/am_beach.png',
  //           timestamp: DateTime.now().subtract(Duration(hours: nextId)),
  //           likes: ['user1'],
  //           comments: [
  //             {'user1': 'Comment!'},
  //           ],
  //         ),
  //       );
  //     });
  //   }
  // }

  Future<List<PostModel>> fetchApiPosts(int start, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?_start=$start&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((item) {
              try {
                return PostModel.fromApiJson(item);
              } catch (e) {
                print('Error parsing API post: $e');
                return null;
              }
            })
            .where((post) => post != null)
            .cast<PostModel>()
            .toList();
      }
    } catch (e) {
      print('API error: $e');
    }
    return [];
  }

  // Future<void> loadMorePosts() async {
  //   if (!mounted) return;
  //
  //   // Safety check - if we're already showing mock data, just add more mock data
  //   bool isShowingMockData =
  //       postsList.isNotEmpty &&
  //       postsList.any((post) => post.ownerId.startsWith('local_user'));
  //
  //   if (isShowingMockData) {
  //     // Add more mock posts with incremented IDs
  //     int nextId = postsList.length + 1;
  //     List<PostModel> moreMockPosts = [
  //       PostModel(
  //         id: 'mock_$nextId',
  //         postId: 'mock_$nextId',
  //         ownerId: 'local_user_${nextId}',
  //         username: 'user_${nextId}',
  //         location: 'Location $nextId',
  //         description: 'This is a mock post #$nextId',
  //         mediaUrl: 'assets/images/post${(nextId % 5) + 1}.jpg',
  //         timestamp: DateTime.now().subtract(Duration(hours: nextId)),
  //         likes: ['user1', 'user2'],
  //         comments: [
  //           {'user1': 'Great!'},
  //         ],
  //       ),
  //       PostModel(
  //         id: 'mock_${nextId + 1}',
  //         postId: 'mock_${nextId + 1}',
  //         ownerId: 'local_user_${nextId + 1}',
  //         username: 'user_${nextId + 1}',
  //         location: 'Location ${nextId + 1}',
  //         description: 'This is a mock post #${nextId + 1}',
  //         mediaUrl: 'assets/images/post${((nextId + 1) % 5) + 1}.jpg',
  //         timestamp: DateTime.now().subtract(Duration(hours: nextId + 1)),
  //         likes: ['user3', 'user4'],
  //         comments: [
  //           {'user2': 'Nice!'},
  //         ],
  //       ),
  //     ];
  //
  //     setState(() {
  //       postsList.addAll(moreMockPosts);
  //       loadingMore = false;
  //     });
  //     return;
  //   }
  //
  //   try {
  //     // Calculate how many more posts to fetch
  //     int currentFirebaseCount = 0;
  //     int currentApiCount = 0;
  //
  //     for (var post in postsList) {
  //       if (post.ownerId == "api_user") {
  //         currentApiCount++;
  //       } else if (!post.ownerId.startsWith('local_user')) {
  //         currentFirebaseCount++;
  //       }
  //     }
  //
  //     // Get more Firebase posts
  //     List<PostModel> newFirebasePosts = [];
  //     try {
  //       final snapshot = await postRef
  //           .orderBy('timestamp', descending: true)
  //           .limit(page)
  //           .get()
  //           .timeout(Duration(seconds: 5));
  //
  //       if (snapshot.docs.isNotEmpty) {
  //         newFirebasePosts =
  //             snapshot.docs
  //                 .map((doc) {
  //                   try {
  //                     return PostModel.fromJson(
  //                       doc.data() as Map<String, dynamic>,
  //                     );
  //                   } catch (e) {
  //                     print('Error parsing Firebase post: $e');
  //                     return null;
  //                   }
  //                 })
  //                 .where((post) => post != null)
  //                 .cast<PostModel>()
  //                 .where(
  //                   (post) =>
  //                       !postsList.any(
  //                         (p) => p.id == post.id && p.ownerId != "api_user",
  //                       ),
  //                 )
  //                 .toList();
  //       }
  //     } catch (e) {
  //       print('Error loading more Firebase posts: $e');
  //     }
  //
  //     // Get more API posts
  //     List<PostModel> newApiPosts = [];
  //     try {
  //       newApiPosts = await fetchApiPosts(
  //         currentApiCount,
  //         5,
  //       ).timeout(Duration(seconds: 5));
  //     } catch (e) {
  //       print('Error loading more API posts: $e');
  //     }
  //
  //     final List<PostModel> newPosts = [...newFirebasePosts, ...newApiPosts];
  //
  //     // Ensure we're still mounted before updating state
  //     if (!mounted) return;
  //
  //     setState(() {
  //       if (newPosts.isEmpty) {
  //         // If we didn't get any new posts, we've reached the end
  //         hasMoreData = false;
  //       } else {
  //         postsList.addAll(newPosts);
  //       }
  //       loadingMore = false;
  //     });
  //   } catch (e) {
  //     print('Error in loadMorePosts: $e');
  //
  //     // Ensure we're still mounted before updating state
  //     if (!mounted) return;
  //
  //     setState(() {
  //       loadingMore = false;
  //
  //       // If loading more fails, add a couple of mock posts to demonstrate pagination
  //       int nextId = postsList.length + 1;
  //       postsList.add(
  //         PostModel(
  //           id: 'mock_$nextId',
  //           postId: 'mock_$nextId',
  //           ownerId: 'local_user_backup',
  //           username: 'backup_user',
  //           location: 'Backup Location',
  //           description: 'This is a backup post when loading more fails',
  //           mediaUrl: 'assets/images/post1.jpg',
  //           timestamp: DateTime.now().subtract(Duration(hours: nextId)),
  //           likes: ['user1'],
  //           comments: [
  //             {'user1': 'Comment!'},
  //           ],
  //         ),
  //       );
  //     });
  //   }
  // }

  Future<void> onRefresh() async {
    setState(() {
      page = 5;
      hasMoreData = true;
    });
    await loadPosts();
    return Future.value();
  }

  // Get mock posts data with robust error handling
  List<PostModel> getMockPosts() {
    try {
      return [
        PostModel(
          id: '1',
          postId: '1',
          ownerId: 'Twg7i0fL4Xc2aKG697qKLPo5ZnP2',
          username: 'Anjanikumar',
          location: 'Pune',
          description: 'Enjoying a beautiful day in Central Park!',
          mediaUrl: 'assets/images/central_park.jpg',
          timestamp: DateTime.now(),
          likes: ['user1', 'user2'],
          comments: [
            {'user1': 'Great photo!'},
            {'user3': 'Looks amazing!'},
          ],
        ),
        PostModel(
          id: '2',
          postId: '2',
          ownerId: 'u2xyzLMNopQRStuvwXYZ',
          username: 'Kartikay',
          location: 'Los Angeles',
          description: 'Beach day with friends! #summer #sunshine',
          mediaUrl: 'assets/images/sunshine.jpg',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          likes: ['user3', 'user4', 'user5'],
          comments: [
            {'user2': 'Having fun!'},
            {'user4': 'Wish I was there!'},
          ],
        ),
        PostModel(
          id: '3',
          postId: '3',
          ownerId: 'u3EFGabcJKLmnopQRS',
          username: 'Navneet',
          location: 'Paris',
          description: 'Finally visited the Eiffel Tower! A dream come true.',
          mediaUrl: 'assets/images/tower.jpg',
          timestamp: DateTime.now().subtract(Duration(hours: 5)),
          likes: ['user1', 'user6', 'user7', 'user8'],
          comments: [
            {'user5': 'Beautiful view!'},
            {'user6': 'On my bucket list!'},
          ],
        ),
        PostModel(
          id: '4',
          postId: '4',
          ownerId: 'u4MNOdefGHIrstUVW',
          username: 'food_lover',
          location: 'Tokyo',
          description: 'Best ramen I\'ve ever had! #foodie #japan',
          mediaUrl: 'assets/images/foodie.jpg',
          timestamp: DateTime.now().subtract(Duration(hours: 8)),
          likes: ['user2', 'user3', 'user9'],
          comments: [
            {'user7': 'Looks delicious!'},
            {'user9': 'Recipe please!'},
          ],
        ),
        PostModel(
          id: '5',
          postId: '5',
          ownerId: 'u5XYZghiJKLmnopTUV',
          username: 'fitness_guru',
          location: 'Miami',
          description: 'Morning workout on the beach. Start your day right!',
          mediaUrl: 'assets/images/am_city.png',
          timestamp: DateTime.now().subtract(Duration(hours: 10)),
          likes: ['user4', 'user10'],
          comments: [
            {'user8': 'Great routine!'},
            {'user10': 'Inspiring!'},
          ],
        ),
      ];
    } catch (e) {
      print('Error creating mock posts: $e');
      return [
        PostModel(
          id: 'fallback_1',
          postId: 'fallback_1',
          ownerId: 'fallback_user',
          username: 'fallback_user',
          location: 'Fallback Location',
          description: 'This is a fallback post when everything else fails',
          mediaUrl: 'assets/images/am_city.png',
          timestamp: DateTime.now(),
          likes: [],
          comments: [],
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Ionicons.chatbubble_ellipses, size: 30.0),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => Chats()),
              );
            },
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: onRefresh,
        child: Column(
          children: [
            // Story widget at the top
            StoryWidget(),
            // Main content with posts
            Expanded(
              child:
                  isLoading
                      ? circularProgress(context)
                      : postsList.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Feeds Available',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  postsList = getMockPosts();
                                });
                              },
                              child: Text('Load Sample Posts'),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        controller: scrollController,
                        itemCount: postsList.length + (loadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == postsList.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: UserPost(post: postsList[index]),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
