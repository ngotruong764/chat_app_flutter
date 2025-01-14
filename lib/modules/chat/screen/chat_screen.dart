
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/modules/chat/controller/chat_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/modules/application/creategroup/view/CreateGroup.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../../../data/api/apis_chat.dart';
import '../../../helper/helper.dart';
import '../../../model/conversation.dart';
import 'chat_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();

  // final TextEditingController _searchController = TextEditingController();

  late final Stream? conversationStream;

  @override
  void initState() {
    super.initState();
    conversationStream = ApisChat.listenMessageInChatScreen(
        conversationList: chatController.conversationList);
  }

  @override
  void dispose() {
    super.dispose();
    // chatController.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Constants.GRADIENT_APP_BAR_COLORS,
              ),
            ),
          ),
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
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
                    // controller: _searchController,
                    cursorColor: Colors.grey,
                    // disable cursor
                    showCursor: false,
                    // disable keyboard
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onTap: () {
                      // navigate to search screen
                      Get.toNamed(AppRoutes.SEARCH);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _activeUsersBar(),
                const SizedBox(height: 20),
                // render conversation list
                _conversations(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conversations(BuildContext context) {
    return StreamBuilder(
      stream: conversationStream,
      initialData: chatController.conversationList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //waiting for data
        if (snapshot.connectionState == ConnectionState.waiting &&
            chatController.conversationList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if has no data
        if (!snapshot.hasData) {
          return const Text('Have no conversation');
        }
        // if has data
        return Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chatController.conversationList.length,
            itemBuilder: (context, index) {
              Conversation conversation =
                  chatController.conversationList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBox(
                        conversationId: conversation.id ?? 0,
                        name: conversation.conservationName ?? '',
                        conversationAvatar: conversation.conservationAvatarBytes!,
                        conversation: conversation,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      // display conservation avatar
                      _displayConservationAvatar(conversation, context),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // conversation name
                            Text(
                              conversation.conservationName ?? 'Empty name',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),

                            // display last message
                            _displayLastMessage(conversation),

                            const Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /*
  * Method to display avatar of each conservation in conversation list
  */
  Widget _displayConservationAvatar(
      Conversation conservation, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Color statusColor = Colors.yellow;
    if(conservation.isOnline!){
      statusColor = Colors.green;
    }

    return Stack(
      children: <Widget>[
        if (conservation.conservationAvatarBytes!.isNotEmpty)
          Container(
            width: width * 0.15,
            height: width * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: MemoryImage(conservation.conservationAvatarBytes!),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Container(
            width: width * 0.15,
            height: width * 0.15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_circle,
              color: Colors.grey,
              size: width *
                  0.15, // Set the size of the icon to match the container
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: width * 0.04,
            height: width * 0.04,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );

  }

  /*
  * Method to display last message
  */
  Widget _displayLastMessage(Conversation conversation) {
    String lastMessageUserName = 'You:';

    if (conversation.userLastMessageId != ApisBase.currentUser.id) {
      lastMessageUserName = conversation.userLastMessageName != null &&
              conversation.userLastMessageName!.isNotEmpty
          ? '${conversation.userLastMessageName}:'
          : '';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: Get.width * 0.4,
          child: Text(
            '$lastMessageUserName ${conversation.lastMessage ?? ''}',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
        Text(
          Helper.formatLastMessageTime(conversation.lastMessageTime),
        ),
      ],
    );
  }
}
