import 'package:chat_app_flutter/modules/search/controller/search_user_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../model/user_info.dart';
import '../../chat/screen/chat_box.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchUserController _searchUserController =
      Get.find<SearchUserController>();

  final TextEditingController _searchControllerText = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<UserInfo> _filteredUsers = [];
  bool _isLoadingMore = true;

  // params to paginate
  int _currentPage = 0;
  final int _pageSize = 10;

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

  // void _loadMoreUsers() async {
  //   if (_isLoadingMore) return; // Tránh gọi lại nhiều lần
  //
  //   setState(() {
  //     _isLoadingMore = true;
  //   });
  //
  //   try {
  //     final List<UserInfo> users = await ApiSearch.fetchUserList(
  //       _searchControllerText.text,
  //       1,
  //       page: _currentPage + 1,
  //       size: _pageSize, // Mỗi lần tải thêm 10 người dùng
  //     );
  //
  //     setState(() {
  //       _currentPage++;
  //       _allUsers.addAll(users);
  //       _filteredUsers = List.from(_allUsers);
  //     });
  //   } catch (error) {
  //     log('Error loading more users: $error');
  //   } finally {
  //     setState(() {
  //       _isLoadingMore = false;
  //     });
  //   }
  // }

  /*
  * Method to load more users
  */
  void _loadMoreUsers() async {
    if (!_isLoadingMore) return; // Tránh gọi lại nhiều lần

    final List<UserInfo> users =
        await _searchUserController.findUserByUserNameOrEmail(
            _searchControllerText.text,
            _searchUserController.currentUser.id!,
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

  // void _fetchUsersFromApi() async {
  //   try {
  //     final String username =
  //         _searchControllerText.text; // Lấy username từ TextField
  //     int currentUserId = _searchUserController.currentUser.id!; // Gán giá trị currentUserId tạm thời
  //     final List<UserInfo> users = await ApiSearch.fetchUserList(
  //       username,
  //       currentUserId,
  //     );
  //
  //     setState(() {
  //       _allUsers = users;
  //       _filteredUsers = List.from(_allUsers);
  //     });
  //   } catch (error) {
  //     log('Error fetching users: $error');
  //   }
  // }

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
    if (_filteredUsers.isNotEmpty) {
      return ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];

          return InkWell(
            onTap: () async {
              // Điều hướng đến màn hình ChatBox
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
            child: ListTile(
              title: Text(user.username ?? 'No username'),
              subtitle: Text(user.status == true ? 'Active' : 'Inactive'),
              leading:
                  _renderUserAvatar(user), // Hiển thị icon nếu không có avatar
            ),
          );
        },
      );
    } else if (_filteredUsers.isEmpty &&
        _searchControllerText.text.isNotEmpty) {
      return const Center(
        child: Text("User not found!"),
      );
    } else {
      return const SizedBox.shrink();
    }
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

  /*
  * Method to find user by username or email
  */
  void _findUserByUserNameOrEmail(
      String value, int pageNo, int pageSize) async {
    _isLoadingMore = true;

    List<UserInfo> searchedUser =
        await _searchUserController.findUserByUserNameOrEmail(
            value, _searchUserController.currentUser.id!, pageNo, pageSize);

    if (searchedUser.isNotEmpty) {
      setState(() {
        // clear the list before add
        _filteredUsers.clear();
        _filteredUsers.addAll(searchedUser);
      });
    }
  }
}
