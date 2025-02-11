import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/api/apis_base.dart';
import '../../../routes/app_routes.dart';

class TestReceiveCallScreen extends StatefulWidget {
  const TestReceiveCallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TestReceiveCallScreenState();
}

class _TestReceiveCallScreenState extends State<TestReceiveCallScreen> {
  late int conversationId;
  bool isOffer = false;
  String? conversationName = ApisBase.currentUser.username;
  late String sdp;
  late String action;

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    conversationId = arguments['conversationId'] ?? 0;
    conversationName = arguments['conversationName'] ?? '';
    sdp = arguments['sdp'] ?? '';
    action = arguments['action'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.VIDEO_CALL, arguments: {
                'conversationId': conversationId,
                'isOffer': false, // create answer
                'conversationName': ApisBase.currentUser.username ?? 'Unknown',
                'sdp': sdp,
                'action': action,
              });
            },
            child: Text('Agree')),
        TextButton(onPressed: () {}, child: Text('Decline')),
      ],
    );
  }
}
