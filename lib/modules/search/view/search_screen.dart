import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    
    _searchController.addListener(() {print("change");});
  }

  /*
  * Un focus TextField
  */
  void _unFocusTextField(){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /*
  * Searching people
  */


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
              padding: EdgeInsets.only(top: height * 0.02,right: 8),
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

      ),
    );
  }
}
