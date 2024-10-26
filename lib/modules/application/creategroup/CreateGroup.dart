import 'package:flutter/material.dart';

class AddNewPage extends StatelessWidget {
  const AddNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Chat'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the page and go back
          },
          child: const Text('Add Chat'),
        ),
      ),
    );
  }
}
