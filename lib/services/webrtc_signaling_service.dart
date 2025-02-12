import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:chat_app_flutter/constants/constants.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/api/apis_base.dart';

class WebRTCSignalingService {
  // Params
  final int conversationId;
  final int currentUserId;
  final String conversationName;
  final String callType;
  String? incomingCallAction; // accept or decline a call
  final VoidCallback? onCallEnded;
  final String? sdp;
  int? voipId;
  final VoidCallback handleError;

  late RTCPeerConnection peerConnection;
  late WebSocketChannel webSocket;
  late MediaStream localStream;
  bool isOffer = true;

  WebRTCSignalingService({
    required this.conversationId,
    required this.currentUserId,
    required this.conversationName,
    required this.callType,
    this.incomingCallAction,
    this.onCallEnded,
    this.sdp,
    this.voipId,
    required this.handleError,
  });

  Future<void> initialize() async {
    bool isAudio = callType == Constants.AUDIO_CALL;
    // Initialize WebSocket connection
    int userId = ApisBase.currentUser.id ?? 0;
    final wsUrl =
    Uri.parse('${ApisBase.socketBaseVideoCallUrl}?userId=$userId');
    webSocket = WebSocketChannel.connect(wsUrl);

    // handle message
    webSocket.stream.listen(
      (message) => _handleSignalingMessage(
        jsonDecode(message),
      ),
      onDone: () {
        log('Handle error');
        // closeAllStream();
        handleError();
      },
    );

    // Create WebRTC peer connection
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": !isAudio,
      },
      "optional": [],
    };
    peerConnection = await createPeerConnection({}, offerSdpConstraints);

    peerConnection.onIceCandidate = (candidate) {
      log("Sending ICE candidate: ${jsonEncode(candidate.toMap())}");
      // Send ICE candidate to the signaling server
      webSocket.sink.add(
          jsonEncode({
            'type': 'candidate',
            'candidate': candidate.toMap(),
            'userId': currentUserId,
            'conversationId': conversationId,
            'conversationName': conversationName,
            'callType': callType,
            'sdp': '',
            'isOffer': isOffer,
            'voipId': voipId,
          }));
    };

    // if agree call
    if(incomingCallAction != Constants.DECLINE_CALL){
      // Get local media stream (camera & microphone)
      localStream = await navigator.mediaDevices
          .getUserMedia({'video': !isAudio, 'audio': true});
      localStream.getTracks().forEach((track) {
        peerConnection.addTrack(track, localStream);
      });

      log('Init local stream');
    }
  }

  Future<void> createOffer() async {
    RTCSessionDescription offer = await peerConnection.createOffer({'offerToReceiveVideo': 1});
    await peerConnection.setLocalDescription(offer);

    Map<String, dynamic> offerData = {
      'type': 'offer',
      'sdp': offer.sdp,
      'userId': currentUserId,
      'conversationId': conversationId,
      'conversationName': conversationName,
      'callType': callType,
    };

    // Send the offer to the signaling server
    webSocket.sink.add(jsonEncode(offerData));
    log('Create RTC Offer');
  }

  Future<void> createAnswer() async {
    log('Offer SDP: $sdp');
    isOffer = false;
    peerConnection.setRemoteDescription(RTCSessionDescription(sdp,'offer'));
    RTCSessionDescription answer = await peerConnection.createAnswer({'offerToReceiveVideo': 1});
    await peerConnection.setLocalDescription(answer);

    // Send the answer to the signaling server
    webSocket.sink.add(jsonEncode({
      'type': 'answer',
      'sdp': answer.sdp,
      'userId': currentUserId,
      'conversationId': conversationId,
      'conversationName': conversationName,
      'callType': callType,
      'action': incomingCallAction,
    }));

    log('Created answer: $incomingCallAction');
  }

  void _handleSignalingMessage(Map<String, dynamic> message) {
    log('Handle message $message');
    if (message['type'] == 'offer') {
      // peerConnection.setRemoteDescription(RTCSessionDescription(message['sdp'], 'offer')).then((_) {
      //   createAnswer();
      // });
    } else if (message['type'] == 'answer') {
      // accept call
      if(message['action'] == Constants.AGREE_CALL){
        peerConnection.setRemoteDescription(
            RTCSessionDescription(message['sdp'], 'answer'));
        log('Set remote description answer');
      } else {
        // decline call
        closeAllStream();
      }
    } else if (message['type'] == 'candidate') {
      peerConnection.addCandidate(RTCIceCandidate(
        message['candidate']['candidate'],
        message['candidate']['sdpMid'],
        message['candidate']['sdpMLineIndex'],
      ));
      log('Adding candidate');
    } else if(message['voipId'] != null){
      Constants.VOIP_CALL_ID_CALlER = message['voipId'];
      voipId = message['voipId'];
    }
  }

  void disconnectSocket() async {
    try {
      webSocket.sink.close();
    } catch (e) {
      log('Error disconnect socket: $e');
    }
  }

  void endCall(){
    try{
      webSocket.sink.add(jsonEncode({
        'callStatus': Constants.END_CALL,
        'userId': currentUserId,
        'conversationId': conversationId,
        'conversationName': conversationName,
        'callType': callType,
        'voipId': voipId,
      }));
    } catch(e){
      log('End call');
    }
  }

  void closeAllStream(){
    peerConnection.removeStream(localStream);
    localStream.dispose();
    // get back to chat box screen
    if(onCallEnded != null){
      onCallEnded!();
    }
    //disconnect socket
    webSocket.sink.close();
    log('Close all stream');
  }
}

