import 'package:chat_app_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  late int voipId;
  late String action;
  late String? callerAvtUrl;
  late String callerUserName;
  late String callType;

  @override
  void initState() {
    super.initState();
    var arguments = Get.arguments;
    conversationId = arguments['conversationId'] ?? 0;
    conversationName = arguments['conversationName'] ?? '';
    sdp = arguments['sdp'] ?? '';
    voipId = arguments['voipId'];
    action = arguments['action'] ?? '';
    callerAvtUrl = arguments['callerAvtUrl'];
    callerUserName = arguments['callerUserName'] ?? 'Unknown';
    callType = arguments['title'];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 0.1, height * 0.1, width * 0.1, 0),
        child: Column(
          children: [
            if (callerAvtUrl != null) ...[
              Center(
                child: CircleAvatar(
                  radius: 48, // Image radius
                  backgroundImage: NetworkImage(callerAvtUrl!),
                ),
              ),
            ] else ...[
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: width * 0.3, // Adjust icon size as needed
                  ),
                ),
              ),
            ],
            SizedBox(height: height * 0.02,),
            Text(
              callerUserName,
              style: TextStyle(color: Colors.white, fontSize: width * 0.05),
            ),
            SizedBox(
              height: height * 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.large(
                  heroTag: UniqueKey(),
                  onPressed: () {
                    if(callType == Constants.AUDIO_CALL){
                      Get.offNamed(AppRoutes.AUDIO_CALL, arguments: {
                        'conversationId': conversationId,
                        'isOffer': false, // create answer
                        'conversationName':
                        ApisBase.currentUser.username ?? 'Unknown',
                        'sdp': sdp,
                        'voipId': voipId,
                        'action': action,
                      });
                    } else {
                      Get.offNamed(AppRoutes.VIDEO_CALL, arguments: {
                        'conversationId': conversationId,
                        'isOffer': false, // create answer
                        'conversationName':
                        ApisBase.currentUser.username ?? 'Unknown',
                        'sdp': sdp,
                        'voipId': voipId,
                        'action': action,
                      });
                    }
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
                FloatingActionButton.large(
                  heroTag: UniqueKey(),
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
