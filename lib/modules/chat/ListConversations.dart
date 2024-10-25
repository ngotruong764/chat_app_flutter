import 'package:flutter/material.dart';
import 'package:chat_ui/screens/ChatDetailPage.dart';
import 'package:chat_ui/screens/AddNewPage.dart';

class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  ConversationsState createState() => ConversationsState();
}

class ConversationsState extends State<Conversations> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> activeUsers = [
    {
      "name": "Alice",
      "imageUrl": "https://randomuser.me/api/portraits/women/1.jpg",
      "isOnline": true,
    },
    {
      "name": "Bob",
      "imageUrl": "https://randomuser.me/api/portraits/men/1.jpg",
      "isOnline": false,
    },
    {
      "name": "Mee",
      "imageUrl": "https://randomuser.me/api/portraits/women/2.jpg",
      "isOnline": false,
    },
    {
      "name": "Mari",
      "imageUrl": "https://randomuser.me/api/portraits/women/3.jpg",
      "isOnline": false,
    },
    {
      "name": "Peter",
      "imageUrl": "https://randomuser.me/api/portraits/men/22.jpg",
      "isOnline": true,
    },
    {
      "name": "Dad",
      "imageUrl": "https://randomuser.me/api/portraits/men/33.jpg",
      "isOnline": true,
    },
    {
      "name": "Cherry",
      "imageUrl": "https://randomuser.me/api/portraits/women/43.jpg",
      "isOnline": false,
    },
    {
      "name": "Ken",
      "imageUrl": "https://randomuser.me/api/portraits/men/41.jpg",
      "isOnline": true,
    },
  ];

  Widget _activeUsersBar() {
    List<Map<String, dynamic>> onlineUsers =
        activeUsers.where((user) => user['isOnline']).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(onlineUsers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(onlineUsers[index]['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 75,
                  child: Align(
                    child: Text(
                      onlineUsers[index]['name'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Map<String, dynamic>> conversationList = [
    {
      "name": "Alice",
      "imageUrl": "https://randomuser.me/api/portraits/women/1.jpg",
      "message": "Hi",
      "time": "10:30 AM",
      "isOnline": true,
      "status": "received",
      "isMine": true,
    },
    {
      "name": "Bob",
      "imageUrl": "https://randomuser.me/api/portraits/men/1.jpg",
      "message": "i'm hungry",
      "time": "9:45 AM",
      "isOnline": false,
      "status": "sent",
      "isMine": false,
    },
    {
      "name": "Mee",
      "imageUrl": "https://randomuser.me/api/portraits/women/22.jpg",
      "message": "Nice to meet you",
      "time": "5:30 AM",
      "isOnline": false,
      "status": "received",
      "isMine": true,
    },
    {
      "name": "Mari",
      "imageUrl": "https://randomuser.me/api/portraits/women/3.jpg",
      "message": "Nice!",
      "time": "1:30 PM",
      "isOnline": false,
      "status": "sent",
      "isMine": true,
    },
    {
      "name": "Peter",
      "imageUrl": "https://randomuser.me/api/portraits/men/22.jpg",
      "message": "ok",
      "time": "4:20 PM",
      "isOnline": true,
      "status": "sent",
      "isMine": true,
    },
    {
      "name": "Dad",
      "imageUrl": "https://randomuser.me/api/portraits/men/33.jpg",
      "message": "ok",
      "time": "2:45 AM",
      "isOnline": true,
      "status": "sent",
      "isMine": false,
    },
    {
      "name": "Cherry",
      "imageUrl": "https://randomuser.me/api/portraits/women/43.jpg",
      "message": "so do I",
      "time": "8:00 PM",
      "isOnline": false,
      "status": "sent",
      "isMine": true,
    },
    {
      "name": "Ken",
      "imageUrl": "https://randomuser.me/api/portraits/men/41.jpg",
      "message": "see ya",
      "time": "6:00 PM",
      "isOnline": true,
      "status": "received",
      "isMine": true,
    },
  ];

  Widget _conversations(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: conversationList.length,
      itemBuilder: (context, index) {
        final conversation = conversationList[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailPage(
                  name: conversation['name'],
                  imageUrl: conversation['imageUrl'],
                  message: conversation['message'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(conversation['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (conversation['isOnline'])
                        Positioned(
                          top: 38,
                          left: 42,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF66BB6A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        conversation['name'],
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (conversation['isMine'] ? "You: " : "") +
                                  conversation['message'] +
                                  " - " +
                                  conversation['time'],
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color(0xFF000000).withOpacity(0.7)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (conversation['isMine']) ...[
                            Icon(
                              conversation['status'] == "received"
                                  ? Icons.check_circle
                                  : Icons.check,
                              color: conversation['status'] == "received"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFe9eaec),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _searchController,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _activeUsersBar(),
              const SizedBox(height: 20),
              _conversations(context),
            ],
          ),
        ),
      ),
    );
  }
}
