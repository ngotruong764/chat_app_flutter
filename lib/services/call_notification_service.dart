import 'dart:developer';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/main.dart';
import 'package:chat_app_flutter/modules/video_call/view/video_call_screen.dart';
import 'package:chat_app_flutter/services/webrtc_signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';

import '../data/api/apis_base.dart';
import '../routes/app_routes.dart';

class CallNotificationService {
  final String nameCaller;
  final String avatarImgUrl;
  final int conversationId;
  final int currentUserId;
  final String conversationName;
  final String callType;
  final String sdp;


  CallNotificationService({
    required this.nameCaller,
    required this.avatarImgUrl,
    required this.conversationId,
    required this.currentUserId,
    required this.conversationName,
    required this.callType,
    required this.sdp,
  });

  /*
  * Method to receive an incoming call
  *   Type:
  *     0: audio call
  *     1: video call
  * */
  void incomingCall() async {
    CallKitParams callKitParams = CallKitParams(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nameCaller: nameCaller,
      appName: Constants.APP_NAME,
      avatar: avatarImgUrl,
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 30000,
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          textColor: '#ffffff',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
          isShowCallID: false
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    callListenerEvent();
  }

  /*
  * Method to show missCall notification
  *   Type:
  *     0: audio call
  *     1: video call
  * */
  // void missCall() async {
  //   CallKitParams callKitParams = CallKitParams(
  //     id: DateTime.now().microsecondsSinceEpoch.toString(),
  //     nameCaller: nameCaller,
  //     appName: Constants.APP_NAME,
  //     avatar: avatarImgUrl,
  //     type: 0,
  //     text
  //     textDecline: 'Decline',
  //     duration: 30000,
  //   );
  //
  //   await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  // }

  /*
  * Method to listen to call action
  * */
  Future<void> callListenerEvent() async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        switch (event!.event) {
          case Event.actionCallAccept:
            // accept an incoming call
            onIncomingCallEvent(Constants.AGREE_CALL);
            break;
          case Event.actionCallDecline:
            //declined an incoming call
            onIncomingCallEvent(Constants.DECLINE_CALL);
            break;
          default:
            log('Unhandled CallkitIncoming event: ${event.event}');
        }
        // callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void onIncomingCallEvent(String action) {
    if(action == Constants.AGREE_CALL){
      // if agree call
      // Get.offAllNamed(AppRoutes.VIDEO_CALL, arguments: {
      //   'conversationId': conversationId,
      //   'isOffer': false, // create answer
      //   'conversationName': ApisBase.currentUser.username ?? 'Unknown',
      //   'sdp': sdp,
      //   'action': action,
      // });

      Get.offAllNamed(AppRoutes.SETTINGS);

    } else if (action == Constants.DECLINE_CALL) {
      // if decline call
      // WebRTCSignalingService signalingService = WebRTCSignalingService(
      //   conversationId: conversationId,
      //   currentUserId: currentUserId,
      //   conversationName: conversationName,
      //   callType: callType,
      //   incomingCallAction: action,
      // );
      //
      // // initialize WebRTCSignalingService
      // signalingService.initialize().then((_) {
      //   // send answer to signaling service and disconnect socket
      //   signalingService.createAnswer();
      // });
    }

    log('On incoming call event $action');
  }
}
