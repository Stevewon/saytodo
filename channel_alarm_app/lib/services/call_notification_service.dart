import 'package:flutter/material.dart';
import '../screens/call/incoming_call_screen.dart';
import 'dart:async';

class CallNotificationService {
  static final CallNotificationService _instance = CallNotificationService._internal();
  factory CallNotificationService() => _instance;
  CallNotificationService._internal();
  
  BuildContext? _context;
  
  Future<void> initialize(BuildContext context) async {
    _context = context;
    // 웹 버전에서는 간단한 초기화만
  }
  
  // 전화 알림 표시 (전체 화면)
  Future<void> showIncomingCallNotification({
    required String channelName,
    required String senderName,
    required String messageType,
    String? mediaUrl,
    String? youtubeUrl,
  }) async {
    // 즉시 전체 화면으로 전환
    _showIncomingCall(
      channelName: channelName,
      senderName: senderName,
      messageType: messageType,
      mediaUrl: mediaUrl,
      youtubeUrl: youtubeUrl,
    );
  }
  
  void _showIncomingCall({
    required String channelName,
    required String senderName,
    required String messageType,
    String? mediaUrl,
    String? youtubeUrl,
  }) {
    if (_context == null) return;
    
    // 전체 화면으로 전환
    Navigator.of(_context!).push(
      MaterialPageRoute(
        builder: (context) => IncomingCallScreen(
          channelName: channelName,
          senderName: senderName,
          messageType: messageType,
          mediaUrl: mediaUrl,
          youtubeUrl: youtubeUrl,
        ),
        fullscreenDialog: true,
      ),
    ).then((accepted) {
      if (accepted == true) {
        // 수락됨
        debugPrint('Call accepted');
      } else {
        // 거절됨
        debugPrint('Call rejected');
      }
    });
  }
  
  // 알림 취소 (웹에서는 동작 없음)
  Future<void> cancelNotification() async {}
  
  // 모든 알림 취소 (웹에서는 동작 없음)
  Future<void> cancelAllNotifications() async {}
}

// 사용 예시:
// 
// 1. 앱 시작 시 초기화:
// await CallNotificationService().initialize(context);
//
// 2. 메시지 수신 시 전화 알림 표시:
// await CallNotificationService().showIncomingCallNotification(
//   channelName: 'Family Channel',
//   senderName: 'John Doe',
//   messageType: 'voice', // 'voice', 'video', 'youtube'
//   mediaUrl: 'https://example.com/audio.mp3',
// );
