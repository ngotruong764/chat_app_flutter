import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  // void initState() {
  //   super.initState();
  //
  //   _searchController.addListener(() {print("change");});
  // }

  /*
  * Un focus TextField
  */
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Sao chép danh sách ban đầu
    _filteredUsers = List.from(_allUsers);

    // Lắng nghe thay đổi trong TextField
    _searchController.addListener(() {
      setState(() {
        _filteredUsers = _allUsers
            .where((user) =>
            user['name']
                .toString()
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

  final List<Map<String, dynamic>> _allUsers = [
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
  List<Map<String, dynamic>> _filteredUsers = [];


  /*
  * Searching people
  */


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
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
        body: ListView.builder(
          itemCount: _filteredUsers.length,
          itemBuilder: (context, index) {
            final user = _filteredUsers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['imageUrl']),
              ),
              title: Text(user['name']),
              subtitle: Text(user['isOnline'] ? 'Online' : 'Offline'),
              trailing: user['isOnline']
                  ? const Icon(Icons.circle, color: Colors.green, size: 12)
                  : null,
              onTap: () {
                // Xử lý khi chọn một user
                print('Selected user: ${user['name']}');
              },
            );
          },
        ),
      ),
    );
  }
}




