import 'package:flutter/material.dart';
import 'package:chat_app_flutter/data/api/api_list_user.dart';

import '../../../model/conversation.dart';
import '../../../model/user_info.dart';
import '../../chat/screen/chat_box.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<UserInfo> _allUsers = [];
  List<UserInfo> _filteredUsers = [];

// xu lý logic hiện users
  int _currentPage = 0;
  bool _isLoadingMore = false;

  void _loadMoreUsers() async {
    if (_isLoadingMore) return; // Tránh gọi lại nhiều lần

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final List<UserInfo> users = await CustomerService.fetchUserList(
        _searchController.text,
        1,
        page: _currentPage + 1,
        size: 10, // Mỗi lần tải thêm 10 người dùng
      );

      setState(() {
        _currentPage++;
        _allUsers.addAll(users);
        _filteredUsers = List.from(_allUsers);
      });
    } catch (error) {
      print('Error loading more users: $error');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  @override

  // void initState() {
  //   super.initState();
  //
  //   _searchController.addListener(() {print("change");});
  // }

  /*
  * Un focus TextField
  */
  // void _fetchUsersFromApi() async {
  //   try {
  //     final List<UserInfo> users = await CustomerService.fetchUserList();
  //     setState(() {
  //       _allUsers = users;
  //       _filteredUsers = List.from(_allUsers);
  //     });
  //   } catch (error) {
  //     print('Error fetching users: $error');
  //   }
  // }
  void _fetchUsersFromApi() async {
    try {
      final String username = _searchController.text; // Lấy username từ TextField
      final int currentUserId = 1; // Gán giá trị currentUserId tạm thời
      final List<UserInfo> users = await CustomerService.fetchUserList(
        username,
        currentUserId,
      );

      setState(() {
        _allUsers = users;
        _filteredUsers = List.from(_allUsers);
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Sao chép danh sách ban đầu
    _fetchUsersFromApi();

    // Lắng nghe thay đổi trong TextField
    _searchController.addListener(() {
      setState(() {
        _filteredUsers = _allUsers
            .where((user) =>
                user.username != null &&
                user.username!
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  void _unFocusTextField() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: _unFocusTextField,
      child: Scaffold(
        appBar: AppBar(
          // hide leading button
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.fromLTRB(8, height * 0.03, 0, 8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFe9eaec),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                cursorColor: Colors.grey,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.02, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      // un focus text field
                      _unFocusTextField();
                      // get back to previous screen
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              _loadMoreUsers(); // Gọi hàm tải thêm khi cuộn tới cuối danh sách
            }
            return true;
          },
          child: ListView.builder(
            itemCount: _filteredUsers.length,
            itemBuilder: (context, index) {
              final user = _filteredUsers[index];

              final conversation = Conversation(
                id: user.id ?? 0,
                conservationName: user.username ?? 'Unknown',
                lastMessage: '', // Giá trị mặc định
                lastMessageTime: DateTime.now(),
                userLastMessageId: user.id,
                userLastMessageName: user.username ?? 'Unknown',
                conservationAvatarBytes: null, // Giá trị mặc định
              );

              return InkWell(
                onTap: () {
                  // Điều hướng đến màn hình ChatBox
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBox(
                        conversationId: 0, // Tạo một ID cuộc trò chuyện mới hoặc lấy từ API
                        name: user.username ?? 'No name',
                        imageUrl: '', // Không cần imageUrl nếu bỏ avatar
                        message: 'Start a conversation',
                        conversation: conversation,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(user.username ?? 'No username'),
                  subtitle: Text(user.status == true ? 'Active' : 'Inactive'),
                  leading: Icon(Icons.account_circle, size: 40, color: Colors.grey), // Hiển thị icon nếu không có avatar
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
