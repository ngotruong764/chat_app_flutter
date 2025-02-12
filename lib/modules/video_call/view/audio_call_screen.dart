import 'dart:async';
import 'dart:developer';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/modules/video_call/controller/video_call_controller.dart';
import 'package:chat_app_flutter/services/webrtc_signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:get/get.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key});

  @override
  State<AudioCallScreen> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCallScreen> {
  VideoCallController videoCallController = Get.find<VideoCallController>();

  final String callType = Constants.AUDIO_CALL;

  // params
  late final int conversationId;
  late final String conversationName;
  late final String? sdp;
  late final int voipId;
  late final String? action;
  late final bool isOffer;
  late final Uint8List? conversationAvatar;

  // create signaling service
  late final WebRTCSignalingService signalingService;

  late final rtc.MediaStream localStream;
  final _localVideoRenderer = rtc.RTCVideoRenderer(); // local video
  final _remoteVideoRenderer = rtc.RTCVideoRenderer(); // remote video

  // counting time
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    // get params
    var arguments = Get.arguments;
    conversationId = arguments['conversationId'] ?? 0;
    isOffer = arguments['isOffer'];
    conversationName = arguments['conversationName'] ?? '';
    sdp = arguments['sdp'] ?? '';
    voipId = arguments['voipId'] ?? 0;
    action = arguments['action'] ?? '';
    conversationAvatar = arguments['conversationAvatar'];

    // init WebRTCSignalingService
    signalingService = WebRTCSignalingService(
      conversationId: conversationId,
      currentUserId: videoCallController.currentUser.id!,
      conversationName: conversationName,
      callType: callType,
      sdp: sdp,
      voipId: voipId,
      incomingCallAction: action,
      onCallEnded: () {
        Navigator.pop(context);
      },
      handleError: endCall,
    );

    // initialize local and remote stream
    initRenderers();

    // init signaling server
    signalingService.initialize().then((_) {
      // create offer
      if (isOffer) {
        signalingService.createOffer();
      } else {
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
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
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
    _localVideoRenderer.dispose();
    // disconnect socket
    signalingService.disconnectSocket();
    // signalingService.endCall();

    Get.back();

    log('End call');
  }

  // This function will be called when the user presses the start button
  // Start the timer
  // The timer will run every second
  // The timer will stop when the hours, minutes and seconds are all 0
  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        setState(() {
          _secondsElapsed++;
        });
      });
    }
  }

  // Format the elapsed seconds into HH:MM:SS
  String get formattedTime {
    final minutes = _secondsElapsed ~/ 3600;
    final seconds = (_secondsElapsed % 3600) ~/ 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(width * 0.03, height * 0.06, width * 0.03, 0),
        child: Column(
          children: [
            Center(
              // ignore_for_file: avoid_low_contrast_text
              child: Text(
                "TALKIE",
                style: TextStyle(
                  fontSize: Get.width * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            if (conversationAvatar != null) ...[
              Container(
                width: width * 0.3,
                height: width * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(conversationAvatar!),
                    fit: BoxFit.cover,
                  ),
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
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              conversationName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.07,
              ),
            ),
            if (_remoteVideoRenderer.srcObject == null) ...[
              Text(
                'Ringing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                ),
              ),
            ] else ...[
              Text(
                formattedTime,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(
              height: height * 0.5,
            ),
            // End call button
            Container(
              height: Get.width * 0.18,
              width: Get.width * 0.18,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    // endCall();
                    signalingService.endCall();
                  },
                  icon: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: Get.height * 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
