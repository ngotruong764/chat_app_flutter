import 'package:chat_app_flutter/modules/application/creategroup/controller/create_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../model/user_info.dart';
import '../../../chat/screen/chat_box.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({Key? key}) : super(key: key);

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final List<String> users = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
  ];

  // Danh sách người dùng đã thêm
  final List<String> addedUsers = [];

/////
  final CreateGroupController _createGroupController = Get.put(CreateGroupController());

  final TextEditingController _searchControllerText = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<UserInfo> _filteredUsers = [];
  bool _isLoadingMore = true;

  // params to paginate
  int _currentPage = 0;
  final int _pageSize = 10;

  // Hàm xử lý khi thêm người dùng
  void toggleUser(String user) {
    setState(() {
      if (addedUsers.contains(user)) {
        // Xóa người dùng nếu đã được thêm
        addedUsers.remove(user);
      } else {
        // Thêm người dùng nếu chưa có
        addedUsers.add(user);
      }
    });
  }

  ////

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Sao chép danh sách ban đầu
    // _fetchUsersFromApi();

    // Lắng nghe thay đổi trong TextField
    _searchControllerText.addListener(() {
      if (_searchControllerText.text.isNotEmpty) {
        _findUserByUserNameOrEmail(
            _searchControllerText.text, _currentPage, _pageSize);
      } else {
        _currentPage = 0;
        _filteredUsers.clear();
        setState(() {});
      }
      // setState(() {
      //   _filteredUsers = _allUsers
      //       .where((user) =>
      //   user.username != null &&
      //       user.username!
      //           .toLowerCase()
      //           .contains(_searchControllerText.text.toLowerCase()))
      //       .toList();
      // });
    });
  }

  void _findUserByUserNameOrEmail(String value, int pageNo,
      int pageSize) async {
    _isLoadingMore = true;

    List<UserInfo> searchedUser = await _createGroupController
        .findUserByUserNameOrEmail(
        value, _createGroupController.currentUser.id!, pageNo, pageSize);

    if (searchedUser.isNotEmpty) {
      setState(() {
        // clear the list before add
        _filteredUsers.clear();
        _filteredUsers.addAll(searchedUser);
      });
    }
  }

  void _loadMoreUsers() async {
    if (!_isLoadingMore) return; // Tránh gọi lại nhiều lần

    final List<UserInfo> users =
    await _createGroupController.findUserByUserNameOrEmail(
        _searchControllerText.text,
        _createGroupController.currentUser.id!,
        _currentPage++,
        _pageSize);

    // if users is empty -> no data response -> set loadingMore is false
    if (users.isEmpty) {
      _isLoadingMore = false;
      return;
    }
    setState(() {
      _filteredUsers.addAll(users);
    });
  }

  void _unFocusTextField() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  // Hàm xử lý khi thêm hoặc xóa người dùng



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: _unFocusTextField,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút Create và Cancel trong title
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Nút Create
                    TextButton(
                      onPressed: () {
                        // Logic cho Create
                      },
                      child: const Text('Create'),
                    ),
                    // Nút Cancel
                    TextButton(
                      onPressed: () {
                        _unFocusTextField();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                // Thanh tìm kiếm nằm ở dưới
                Container(
                  width: MediaQuery.of(context).size.width * 0.7, // Thanh tìm kiếm chiếm 70% chiều rộng
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFe9eaec),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchControllerText,
                    autofocus: true,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _loadMoreUsers(); // Gọi hàm tải thêm khi cuộn tới cuối danh sách
            }
            return true;
          },
          child: _showSearchedUser(),
        ),
      ),
    );
  }

  Widget _showSearchedUser() {
    return Column(
      children: [
        if (addedUsers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Users:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: addedUsers.map((user) {
                    return Chip(
                      label: Text(user),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        toggleUser(user); // Xóa user khỏi danh sách
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        if (_filteredUsers.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                final isAdded = addedUsers.contains(user.username);

                return Card(
                  elevation: 3, // Card có độ nổi
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: _renderUserAvatar(user), // Hiển thị avatar hoặc icon mặc định
                    title: Text(user.username ?? 'No username'),
                    subtitle: Text(user.status == true ? 'Active' : 'Inactive'),
                    trailing: IconButton(
                      icon: Icon(
                        isAdded ? Icons.check_circle : Icons.check_circle_outline,
                        color: isAdded ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          // Kiểm tra nếu username không phải null thì mới thêm vào addedUsers
                          if (user.username != null) {
                            if (isAdded) {
                              addedUsers.remove(user.username);
                            } else {
                              addedUsers.add(user.username!); // Dùng `!` để khẳng định không phải null
                            }
                          }
                        });
                      },
                    ),
                    onTap: () async {
                      // Điều hướng đến màn hình ChatBox khi nhấn vào người dùng
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatBox(
                            conversationId: 0,
                            conversationPartner: user,
                            name: user.username ?? 'No name',
                            conversationAvatar: user.profilePictureBytes!,
                            conversation: null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        // Hiển thị khi không tìm thấy người dùng
        else if (_filteredUsers.isEmpty && _searchControllerText.text.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text("User not found!"),
            ),
          )
        else
          const SizedBox.shrink(),

      ],
    );
  }

  Widget _renderUserAvatar(UserInfo user){
    final width = MediaQuery.of(context).size.width;
    if (user.profilePictureBytes!.isNotEmpty) {
      return Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(user.profilePictureBytes!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return SizedBox(
      width: width * 0.1,
      height: width * 0.1,
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
      ),
    );
  }

}