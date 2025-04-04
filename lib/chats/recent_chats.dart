import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/chat_item.dart';
import '../models/message.dart';
import '../utils/firebase.dart';
import '../view_models/user/user_view_model.dart';
import '../widgets/indicators.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ionicons/ionicons.dart';
import 'dart:math';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late UserViewModel viewModel;
  bool isLoading = true;
  List<DummyChat> dummyChats = [];

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();

    // Add a delay to simulate network loading
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        dummyChats = generateDummyChats();
        isLoading = false;
      });
    });
  }

  List<DummyChat> generateDummyChats() {
    final random = Random();
    final now = DateTime.now();

    final chats = [
      DummyChat(
        userId: 'user1',
        username: 'Sarah Johnson',
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        lastMessage: 'Hey! Are you going to the event tomorrow?',
        time: now.subtract(Duration(minutes: 5)),
        unreadCount: 2,
      ),
      DummyChat(
        userId: 'user2',
        username: 'Mike Peterson',
        avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        lastMessage: 'Check out this new photo I took 📷',
        time: now.subtract(Duration(hours: 1, minutes: 23)),
        unreadCount: 0,
      ),
      DummyChat(
        userId: 'user3',
        username: 'Emma Wilson',
        avatarUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        lastMessage: 'Thanks for your help yesterday 🙏',
        time: now.subtract(Duration(hours: 4)),
        unreadCount: random.nextBool() ? 1 : 0,
      ),
      DummyChat(
        userId: 'user4',
        username: 'John Smith',
        avatarUrl: 'https://randomuser.me/api/portraits/men/59.jpg',
        lastMessage: 'Did you see the new post from Alex? 👀',
        time: now.subtract(Duration(days: 1, hours: 2)),
        unreadCount: 0,
      ),
      DummyChat(
        userId: 'user5',
        username: 'Lisa Chen',
        avatarUrl: 'https://randomuser.me/api/portraits/women/79.jpg',
        lastMessage: 'I’ll send you the details later 📧',
        time: now.subtract(Duration(days: 2, minutes: 15)),
        unreadCount: 0,
      ),
      DummyChat(
        userId: 'user6',
        username: 'Carlos Gomez',
        avatarUrl: 'https://randomuser.me/api/portraits/men/77.jpg',
        lastMessage: 'Let’s catch up this weekend! 🍕',
        time: now.subtract(Duration(days: 3, hours: 5)),
        unreadCount: 3,
      ),
    ];

    // Shuffle for realism
    chats.shuffle();

    return chats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, size: 24),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Text("Chats", style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Implement new chat creation
            },
            tooltip: 'Start New Chat',
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child:
                          dummyChats.isEmpty
                              ? AnimatedOpacity(
                                opacity: 1.0,
                                duration: Duration(milliseconds: 300),
                                child: _buildEmptyState(),
                              )
                              : ListView.separated(
                                itemCount: dummyChats.length,
                                padding: EdgeInsets.only(top: 8, bottom: 16),
                                itemBuilder:
                                    (context, index) =>
                                        _buildChatItem(dummyChats[index]),
                                separatorBuilder:
                                    (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 88,
                                        right: 16,
                                        top: 4,
                                        bottom: 4,
                                      ),
                                      child: Divider(
                                        height: 0.5,
                                        thickness: 0.6,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                              ),
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewChatDialog,
        icon: Icon(Icons.chat_bubble_outline),
        label: Text("New Chat"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your own Lottie or image if you have one
            Icon(
              Ionicons.chatbubble_ellipses_outline,
              size: 90,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24),
            Text(
              'No Conversations Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Start chatting with your friends to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              onPressed: () {
                setState(() {
                  dummyChats = generateDummyChats();
                });
              },
              icon: Icon(Icons.refresh),
              label: Text(
                'Load Sample Conversations',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(DummyChat chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ChatDetail(
                  userId: chat.userId,
                  username: chat.username,
                  avatarUrl: chat.avatarUrl,
                ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          chat.avatarUrl.startsWith('http')
                              ? NetworkImage(chat.avatarUrl)
                              : AssetImage('assets/images/placeholder.png')
                                  as ImageProvider,
                    ),
                    if (chat.unreadCount > 0)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    chat.unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            timeago.format(chat.time),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  chat.unreadCount > 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              chat.unreadCount > 0
                                  ? Colors.black87
                                  : Colors.grey[600],
                          fontWeight:
                              chat.unreadCount > 0 ? FontWeight.w500 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 88, height: 0), // optional subtle divider
        ],
      ),
    );
  }

  void _showNewChatDialog() {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Start New Chat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the name of the contact you want to chat with:',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Contact Name',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.chat_bubble_outline, size: 18),
              label: Text('Create'),
              onPressed: () {
                final enteredName =
                    _nameController.text.trim().isEmpty
                        ? 'New Contact'
                        : _nameController.text.trim();

                setState(() {
                  dummyChats.insert(
                    0,
                    DummyChat(
                      userId: 'new_user_${dummyChats.length + 1}',
                      username: enteredName,
                      avatarUrl: 'assets/images/placeholder.png',
                      lastMessage: 'Tap to start chatting',
                      time: DateTime.now(),
                      unreadCount: 1,
                    ),
                  );
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Chat Detail Screen for sending messages
class ChatDetail extends StatefulWidget {
  final String userId;
  final String username;
  final String avatarUrl;

  ChatDetail({
    required this.userId,
    required this.username,
    required this.avatarUrl,
  });

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  final List<DummyMessage> _messages = [];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load dummy messages
    _loadDummyMessages();

    // Simulate typing indicators
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
              _addReceivedMessage(
                "Thanks for reaching out! How can I help you today?",
              );
            });
          }
        });
      }
    });
  }

  void _loadDummyMessages() {
    final random = Random();
    DateTime time = DateTime.now().subtract(Duration(days: 2, hours: 4));

    final dummyData = [
      {"sender": widget.userId, "content": "Hey there! 👋", "delay": 0},
      {"sender": "me", "content": "Hi! How are you doing?", "delay": 5},
      {
        "sender": widget.userId,
        "content": "I'm good, just exploring this app.",
        "delay": 3,
      },
      {
        "sender": "me",
        "content": "Nice! Let me know if you have any feedback.",
        "delay": 2,
      },
      {
        "sender": widget.userId,
        "content": "Sure! So far, it's very smooth and clean.",
        "delay": 1440, // Jump 1 day
      },
      {"sender": "me", "content": "Thanks, I appreciate that!", "delay": 1},
      {
        "sender": widget.userId,
        "content": "Also, love the typing indicator. Looks cool!",
        "delay": 3,
      },
      {
        "sender": "me",
        "content": "Haha thanks 😄 Trying to keep it user-friendly.",
        "delay": 2,
      },
    ];

    for (var item in dummyData) {
      time = time.add(Duration(minutes: item['delay'] as int));
      _messages.add(
        DummyMessage(
          senderId: item['sender'] as String,
          content: item['content'] as String,
          time: time,
          isMe: item['sender'] == "me",
        ),
      );
    }

    _messages.sort((a, b) => a.time.compareTo(b.time));
  }

  void _addReceivedMessage(String content) async {
    // Optional: Show typing indicator before receiving message
    setState(() => _isTyping = true);

    // Simulate a short typing delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isTyping = false;
      _messages.add(
        DummyMessage(
          senderId: widget.userId,
          content: content,
          time: DateTime.now(),
          isMe: false,
        ),
      );
    });

    // Allow the UI to rebuild before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final sentMessage = DummyMessage(
      senderId: "me",
      content: text,
      time: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(sentMessage);
    });

    _scrollToBottom();

    _simulateTypingAndRespond(text);
  }

  void _simulateTypingAndRespond(String userMessage) async {
    if (!mounted) return;

    setState(() => _isTyping = true);

    // Simulate human-like typing delay (1–3 seconds)
    final typingDuration = Duration(seconds: 1 + Random().nextInt(3));
    await Future.delayed(typingDuration);

    if (!mounted) return;

    setState(() => _isTyping = false);

    final response = _generateResponse(userMessage);
    _addReceivedMessage(response);
  }

  String _generateResponse(String message) {
    final msg = message.toLowerCase().trim();

    if (_containsAny(msg, ['hello', 'hi', 'hey'])) {
      return _randomResponse([
        "Hey there! 👋",
        "Hello! How's it going?",
        "Hi! What can I do for you today?",
      ]);
    } else if (_containsAny(msg, ['how are you', 'how r u', 'hru'])) {
      return _randomResponse([
        "I'm doing great, thanks for asking! 😊 How about you?",
        "Feeling fantastic! What about you?",
        "I'm good! Ready to chat anytime.",
      ]);
    } else if (_containsAny(msg, ['thanks', 'thank you', 'thx'])) {
      return _randomResponse([
        "You're most welcome! 🙌",
        "Anytime!",
        "Glad I could help 😊",
      ]);
    } else if (_containsAny(msg, ['bye', 'goodbye', 'see you'])) {
      return _randomResponse([
        "Catch you later! 👋",
        "Goodbye! Take care!",
        "Until next time!",
      ]);
    } else if (msg.endsWith('?')) {
      return _randomResponse([
        "That's a great question. Let me think... 🤔",
        "Hmm... I'm not sure, but let's find out!",
        "Interesting! Let's dig into that together.",
      ]);
    } else {
      return _randomResponse([
        "That's cool — tell me more!",
        "I see! Go on...",
        "Got it 👍 What’s next?",
        "Very interesting. Thanks for sharing!",
        "Hmm, that's something to think about.",
      ]);
    }
  }

  /// Helper to check if the message contains any keyword
  bool _containsAny(String message, List<String> keywords) {
    return keywords.any((kw) => message.contains(kw));
  }

  /// Helper to pick a random response
  String _randomResponse(List<String> options) {
    return options[Random().nextInt(options.length)];
  }

  void _scrollToBottom() {
    // Wait for the frame to be rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  widget.avatarUrl.startsWith('http')
                      ? NetworkImage(widget.avatarUrl)
                      : AssetImage('assets/images/placeholder.png')
                          as ImageProvider,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    if (_isTyping)
                      Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.only(right: 5, top: 2),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      _isTyping ? 'typing...' : 'online',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            _isTyping
                                ? Colors.greenAccent
                                : isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                        fontStyle:
                            _isTyping ? FontStyle.italic : FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: theme.iconTheme.color),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 6,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final showTimeStamp =
                      index == 0 || _shouldShowTimestamp(index);

                  return Column(
                    children: [
                      if (showTimeStamp) _buildTimestampWidget(message.time),
                      _buildMessageWidget(message),
                    ],
                  );
                },
              ),
            ),
          ),
          _buildTypingIndicator(context),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(int index) {
    // Show timestamp if messages are more than 10 minutes apart
    final currentMessage = _messages[index];
    final previousMessage = _messages[index - 1];
    return currentMessage.time.difference(previousMessage.time).inMinutes >= 10;
  }

  Widget _buildTimestampWidget(DateTime time) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.grey.withOpacity(0.25)
                    : Colors.grey.shade300.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            _formatTimestamp(time),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 12.5,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return 'Today, ${_formatTime(time)}';
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${_formatTime(time)}';
    } else {
      return '${time.day}/${time.month}/${time.year}, ${_formatTime(time)}';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildMessageWidget(DummyMessage message) {
    final isMe = message.isMe;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isMe
                  ? theme.colorScheme.secondary
                  : isDark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isMe ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontSize: 15.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    if (!_isTyping) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPulsingDot(0),
            _buildPulsingDot(300),
            _buildPulsingDot(600),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingDot(int delay) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 10,
      width: 10,
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.5, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
        onEnd: () {
          // restart the animation with delay
          Future.delayed(Duration(milliseconds: delay), () {
            // triggers rebuild for looping
            (context as Element).markNeedsBuild();
          });
        },
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: theme.iconTheme.color),
            onPressed: () {},
            splashRadius: 24,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class DummyChat {
  final String userId;
  final String username;
  final String avatarUrl;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;

  DummyChat({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
}

class DummyMessage {
  final String senderId;
  final String content;
  final DateTime time;
  final bool isMe;

  DummyMessage({
    required this.senderId,
    required this.content,
    required this.time,
    required this.isMe,
  });
}

// class Chats extends StatefulWidget {
//   @override
//   _ChatsState createState() => _ChatsState();
// }
//
// class _ChatsState extends State<Chats> {
//   late UserViewModel viewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = Provider.of<UserViewModel>(context, listen: false);
//     viewModel.setUser();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Icon(Icons.keyboard_backspace),
//         ),
//         title: Text("Chats"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: userChatsStream(viewModel.user?.uid ?? ""),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: circularProgress(context));
//           }
//
//           if (snapshot.hasData) {
//             List chatList = snapshot.data!.docs;
//             if (chatList.isEmpty) {
//               return Center(child: Text('No Chats'));
//             }
//
//             return ListView.separated(
//               itemCount: chatList.length,
//               itemBuilder: (context, index) {
//                 DocumentSnapshot chatDoc = chatList[index];
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: messageListStream(chatDoc.id),
//                   builder: (context, messageSnapshot) {
//                     if (messageSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return SizedBox.shrink();
//                     }
//
//                     if (messageSnapshot.hasData &&
//                         messageSnapshot.data!.docs.isNotEmpty) {
//                       List messages = messageSnapshot.data!.docs;
//                       Message message = Message.fromJson(
//                         messages.first.data() as Map<String, dynamic>,
//                       );
//
//                       List<dynamic> users = chatDoc.get('users');
//                       String recipient = users.firstWhere(
//                         (id) => id != viewModel.user?.uid,
//                       );
//
//                       return ChatItem(
//                         userId: recipient,
//                         messageCount: messages.length,
//                         msg: message.content ?? '',
//                         time: message.time,
//                         chatId: chatDoc.id,
//                         type: message.type,
//                         currentUserId: viewModel.user?.uid ?? '',
//                       );
//                     } else {
//                       return SizedBox.shrink();
//                     }
//                   },
//                 );
//               },
//               separatorBuilder:
//                   (context, index) => Align(
//                     alignment: Alignment.centerRight,
//                     child: Container(
//                       height: 0.5,
//                       width: MediaQuery.of(context).size.width / 1.3,
//                       child: Divider(),
//                     ),
//                   ),
//             );
//           } else {
//             return Center(child: Text('Something went wrong.'));
//           }
//         },
//       ),
//     );
//   }
//
//   Stream<QuerySnapshot> userChatsStream(String uid) {
//     return chatRef
//         .where('users', arrayContains: uid)
//         .orderBy('lastTextTime', descending: true)
//         .snapshots();
//   }
//
//   Stream<QuerySnapshot> messageListStream(String chatId) {
//     return chatRef
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('time', descending: true)
//         .snapshots();
//   }
// }
