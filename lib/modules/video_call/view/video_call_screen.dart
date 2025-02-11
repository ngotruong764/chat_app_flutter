import 'dart:async';
import 'dart:developer';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/modules/video_call/controller/video_call_controller.dart';
import 'package:chat_app_flutter/services/webrtc_signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:get/get.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCallScreen> {

  VideoCallController videoCallController = Get.find<VideoCallController>();

  final String callType = Constants.VIDEO_CALL;
  // params
  late final int conversationId;
  late final String conversationName;
  late final String? sdp;
  late final String? action;

  // create signaling service
  late final WebRTCSignalingService signalingService;

  late final rtc.MediaStream localStream;
  final _localVideoRenderer = rtc.RTCVideoRenderer(); // local video
  final _remoteVideoRenderer = rtc.RTCVideoRenderer(); // remote video

  // counting time
  // The seconds, minutes and hours
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  Timer? _timer;

  @override
  void initState() {
    // get params
    var arguments = Get.arguments;
    conversationId = arguments['conversationId'] ?? 0;
    bool isOffer = arguments['isOffer'];
    conversationName = arguments['conversationName'] ?? '';
    sdp = arguments['sdp'] ?? '';
    action = arguments['action'] ?? '';

    // init WebRTCSignalingService
    signalingService = WebRTCSignalingService(
      conversationId: conversationId,
      currentUserId: videoCallController.currentUser.id!,
      conversationName: conversationName,
      callType: callType,
      sdp: sdp,
      incomingCallAction: action,
      onCallEnded: () {
        Navigator.pop(context);
      },
    );

    // initialize local and remote stream
    initRenderers();

    // init signaling server
    signalingService.initialize().then((_) {
      // create offer
      if(isOffer){
        signalingService.createOffer();
      } else{
        signalingService.createAnswer();
      }

      setState(() {
        localStream = signalingService.localStream;
        _localVideoRenderer.srcObject = localStream;
      });

      signalingService.peerConnection.onTrack = (event) {
        if (event.streams.isNotEmpty) {
          setState(() {
            _remoteVideoRenderer.srcObject = event.streams[0];
          });
          log('Add remote stream');
          _startTimer();
        }
      };
    });
    // enterFullScreen();
    super.initState();
  }

  /*
  * Init local and remote stream
  */
  void initRenderers() async {
    _localVideoRenderer.initialize();
    _remoteVideoRenderer.initialize();
  }

  @override
  void dispose() async {
    _localVideoRenderer.dispose();
    _remoteVideoRenderer.dispose();
    super.dispose();
  }

  /*
  * Fullscreen mode
  */
  void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  /*
  * Exit fullscreen
  */
  void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  /*
  * Method used to end call
  */
  void endCall() async {
    // Stop all tracks in the media stream
    if (_localVideoRenderer.srcObject != null) {
      _localVideoRenderer.srcObject!.getTracks().forEach((track) {
        track.stop();
      });
    }
    // Clear the video renderer's source object
    _localVideoRenderer.srcObject = null;
    // Dispose of the video renderer
    await _localVideoRenderer.dispose();
    // disconnect socket
    signalingService.disconnectSocket();
    // Exit fullscreen mode
    exitFullScreen();
    // Navigate back to the previous screen
    Get.back();

    log('End call');
  }

  /*
  * Method to render media of both the local and remote user
  */
   List<Widget> _videoRenderers() {
    return <Widget>[
      if(_remoteVideoRenderer.srcObject == null)...[
        Positioned(child: Container(
          key: const Key('local'),
          child: rtc.RTCVideoView(
            _localVideoRenderer,
            mirror: true,
          ),
        ),),
      ]
    ];
  }

  // This function will be called when the user presses the start button
  // Start the timer
  // The timer will run every second
  // The timer will stop when the hours, minutes and seconds are all 0
  void _startTimer() {
    setState(() {
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if(_seconds == 59){
          _minutes ++;
          _seconds = 0;
        } else if(_minutes == 59){
          _hours ++;
          _minutes == 0;
          _seconds == 0;
        }
        _seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        if (_remoteVideoRenderer.srcObject == null) ...[
          // Local video only
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              key: const Key('local'),
              child: rtc.RTCVideoView(
                _localVideoRenderer,
                mirror: true,
                objectFit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
              ),
            ),
          ),
        ] else ...[
          // Remote video
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: Get.width,
              height: Get.height,
              key: const Key('remote'),
              child: rtc.RTCVideoView(
                _remoteVideoRenderer,
                objectFit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
          ),

          // Local video
          Positioned(
            top: Get.height * 0.09,
            right: Get.width * 0.03,
            width: Get.width * 0.4,
            height: Get.height * 0.3,
            child: Container(
              key: const Key('local'),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),  // Semi-transparent background to make it look more sleek
                borderRadius: BorderRadius.circular(20),  // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),  // Subtle shadow effect
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 4),  // Slight shadow offset
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,  // Ensure content fits within the rounded corners
              child: rtc.RTCVideoView(
                _localVideoRenderer,
                mirror: true,
                objectFit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover ,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, Get.height * 0.05, 0, 5),
                child: const Center(
                  child: Text(
                    "TALKIE",
                    style: TextStyle(fontSize: 18,
                    color: Colors.blue),
                  ),
                ),
              ),
              Text(
                  '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}'),
            ],
          ),

        ],

        // End call button
        Positioned(
          bottom: Get.height * 0.01,
          left: 0,
          right: 0,
          child: Container(
            height: Get.width * 0.18,
            width: Get.width * 0.18,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  endCall();
                },
                icon: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: Get.height * 0.05,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


