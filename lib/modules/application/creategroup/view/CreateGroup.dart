import 'package:chat_app_flutter/modules/application/creategroup/controller/create_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:typed_data' as typed_data; // Import with prefix
import '../../../../model/user_info.dart';
import '../../../chat/screen/chat_box.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({Key? key}) : super(key: key);

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final List<UserInfo> addedUsers = [];

/////
  final CreateGroupController _createGroupController =
      Get.put(CreateGroupController());

  final TextEditingController _searchControllerText = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<UserInfo> _filteredUsers = [];
  bool _isLoadingMore = true;

  // params to paginate
  int _currentPage = 0;
  final int _pageSize = 10;

  // Hàm xử lý khi thêm người dùng
  void toggleUser(UserInfo user) {
    setState(() {
      // Kiểm tra nếu người dùng đã tồn tại trong danh sách
      final isAdded = addedUsers.any((u) => u.id == user.id);
      if (isAdded) {
        // Nếu đã tồn tại, xóa người dùng khỏi danh sách
        addedUsers.removeWhere((u) => u.id == user.id);
      } else {
        // Nếu chưa tồn tại, thêm người dùng vào danh sách
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
    });
  }

  void _findUserByUserNameOrEmail(
      String value, int pageNo, int pageSize) async {
    _isLoadingMore = true;

    List<UserInfo> searchedUser =
        await _createGroupController.findUserByUserNameOrEmail(
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

  void _onCreateGroup() async {
    if (addedUsers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please select at least 2 users to create a group.",
            ),
          )
      );
      return; // Stop the process if less than 2 users selected
    }
    if (addedUsers.isNotEmpty) {
      _createGroupController.createGroup(addedUsers).then((groupId) async {
        print('groupId: $groupId'); // add this line to log group id
        if (groupId != null) {
          // Đọc ảnh từ assets
          final typed_data.ByteData data = await rootBundle.load('assets/group_avatar.png'); // Replace with path to your image
          final typed_data.Uint8List avatarBytes = data.buffer.asUint8List();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBox(
                conversationId: groupId,
                conversationPartner: addedUsers.first,
                name: 'Group Name',
                conversation: null,
                conversationAvatar: avatarBytes, // Truyền ảnh vào đây
              ),
            ),
          );
        }
      }).catchError((error) {
        print("Error creating group: $error");
      });
    } else {
      print("No users selected!");
    }
  }

  // Hàm xử lý khi thêm hoặc xóa người dùng

  // @override
  // Widget build(BuildContext context) {
  //   double height = MediaQuery.of(context).size.height;
  //   return GestureDetector(
  //     onTap: _unFocusTextField,
  //     child: Scaffold(
  //       appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: height * 0.02),
  //         child: Row(
  //           children: [
  //             // Nút Create
  //             Flexible(
  //               flex: 1, // Chiếm 1 phần tỷ lệ
  //               child: TextButton(
  //                 onPressed: () {
  //                   // Logic cho Create
  //                 },
  //                 child: const Text(
  //                   'Create',
  //                   style: TextStyle(fontSize: 10), // Kích thước chữ nhỏ hơn
  //                 ),
  //               ),
  //             ),
  //             // Thanh tìm kiếm
  //             Flexible(
  //               flex: 4, // Chiếm 4 phần tỷ lệ
  //               child: Container(
  //                 height: 40,
  //                 margin: const EdgeInsets.symmetric(horizontal: 8), // Tạo khoảng cách hai bên
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFe9eaec),
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: TextField(
  //                   controller: _searchControllerText,
  //                   autofocus: true,
  //                   cursorColor: Colors.grey,
  //                   decoration: const InputDecoration(
  //                     border: InputBorder.none,
  //                     hintText: 'Search',
  //                     prefixIcon: Icon(Icons.search),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             // Nút Cancel
  //             Flexible(
  //               flex: 1, // Chiếm 1 phần tỷ lệ
  //               child: TextButton(
  //                 onPressed: () {
  //                   _unFocusTextField();
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text(
  //                   'Cancel',
  //                   style: TextStyle(fontSize: 10), // Kích thước chữ nhỏ hơn
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //
  //       body: NotificationListener<ScrollNotification>(
  //         onNotification: (scrollInfo) {
  //           if (scrollInfo.metrics.pixels ==
  //               scrollInfo.metrics.maxScrollExtent) {
  //             _loadMoreUsers(); // Gọi hàm tải thêm khi cuộn tới cuối danh sách
  //           }
  //           return true;
  //         },
  //         child: _showSearchedUser(),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: _unFocusTextField,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
            children: [
              // Nút Create
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onCreateGroup,
                    child: const Text(
                      'Create',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    "Create group chat",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      _unFocusTextField();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16), // Kích thước chữ vừa phải
                    ),
                  ),
                ],
              ),
              // Thanh tìm kiếm
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                // Tạo khoảng cách giữa các phần tử
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
              // Nút Cancel

              // Phần hiển thị kết quả tìm kiếm và cuộn danh sách
              Expanded(
                // Đảm bảo phần này chiếm hết không gian còn lại
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      _loadMoreUsers(); // Gọi hàm tải thêm khi cuộn tới cuối danh sách
                    }
                    return true;
                  },
                  child:
                      _showSearchedUser(), // Hàm này hiển thị kết quả tìm kiếm
                ),
              ),
            ],
          ),
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
                      label: Text(user.username ?? 'No username'),
                      // Hiển thị username
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
                final isAdded = addedUsers.any((u) => u.id == user.id);

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: _renderUserAvatar(user), // Hiển thị avatar
                    title: Text(user.username ?? 'No username'),
                    subtitle: Text(user.status == true ? 'Active' : 'Inactive'),
                    trailing: IconButton(
                      icon: Icon(
                        isAdded
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: isAdded ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        toggleUser(
                            user); // Gọi hàm toggle với đối tượng `UserInfo`
                      },
                    ),
                  ),
                );
              },
            ),
          )
        // Hiển thị khi không tìm thấy người dùng
        else if (_filteredUsers.isEmpty &&
            _searchControllerText.text.isNotEmpty)
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

  Widget _renderUserAvatar(UserInfo user) {
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

  void _findUserByUserNameOrEmail2(
      String value, int pageNo, int pageSize) async {
    _isLoadingMore = true;

    List<UserInfo> createGroup =
        await _createGroupController.findUserByUserNameOrEmail(
            value, _createGroupController.currentUser.id!, pageNo, pageSize);

    if (createGroup.isNotEmpty) {
      setState(() {
        // clear the list before add
        addedUsers.clear();
        addedUsers.addAll(createGroup);
      });
    }
  }
}
