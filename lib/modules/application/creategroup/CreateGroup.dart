import 'package:flutter/material.dart';

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

  // Hàm xử lý khi thêm người dùng
  void addUser(String user) {
    if (!addedUsers.contains(user)) {
      setState(() {
        addedUsers.add(user);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Chat'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(user),
              trailing: addedUsers.contains(user)
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                onPressed: () => addUser(user),
                child: const Text('Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}
