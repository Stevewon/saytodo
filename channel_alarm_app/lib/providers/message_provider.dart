import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'package:uuid/uuid.dart';

class MessageProvider with ChangeNotifier {
  final Map<String, List<Message>> _channelMessages = {};
  bool _isLoading = false;
  
  // 새 메시지 콜백 (전화 알람 트리거용)
  Function(Message)? onNewMessage;
  
  bool get isLoading => _isLoading;
  
  // 채널의 메시지 목록 가져오기
  List<Message> getChannelMessages(String channelId) {
    return _channelMessages[channelId] ?? [];
  }
  
  // 메시지 전송
  Future<Message?> sendMessage({
    required String channelId,
    required String senderId,
    required String senderName,
    required MessageType type,
    required String content,
    String? mediaUrl,
    int? duration,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final message = Message(
        id: const Uuid().v4(),
        channelId: channelId,
        senderId: senderId,
        senderName: senderName,
        type: type,
        content: content,
        mediaUrl: mediaUrl,
        duration: duration,
        createdAt: DateTime.now(),
        readBy: [senderId],  // 보낸 사람은 자동으로 읽음
      );
      
      if (_channelMessages[channelId] == null) {
        _channelMessages[channelId] = [];
      }
      _channelMessages[channelId]!.add(message);
      
      // 🔥 새 메시지 수신 시 자동으로 전화 알람 트리거!
      if (onNewMessage != null && senderId != 'current_user') {
        onNewMessage!(message);
      }
      
      _isLoading = false;
      notifyListeners();
      return message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
  
  // 메시지 읽음 처리
  void markAsRead(String channelId, String messageId, String userId) {
    final messages = _channelMessages[channelId];
    if (messages != null) {
      final message = messages.firstWhere((m) => m.id == messageId);
      if (!message.readBy.contains(userId)) {
        message.readBy.add(userId);
        notifyListeners();
      }
    }
  }
  
  // 샘플 메시지 로드
  void loadSampleMessages(String channelId, String userId) {
    if (_channelMessages[channelId] == null) {
      _channelMessages[channelId] = [
        Message(
          id: '1',
          channelId: channelId,
          senderId: userId,
          senderName: '나',
          type: MessageType.voice,
          content: '안녕하세요! 오늘 저녁 6시에 모임 있어요',
          mediaUrl: 'https://example.com/voice1.mp3',
          duration: 15,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          readBy: [userId],
        ),
        Message(
          id: '2',
          channelId: channelId,
          senderId: 'user2',
          senderName: '친구',
          type: MessageType.youtube,
          content: 'https://youtube.com/watch?v=example',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          readBy: ['user2'],
        ),
      ];
      notifyListeners();
    }
  }
  
  // 🔥 실시간 메시지 수신 시뮬레이션 (테스트용)
  void simulateIncomingMessage(String channelId, String channelName) {
    final message = Message(
      id: const Uuid().v4(),
      channelId: channelId,
      senderId: 'other_user',
      senderName: '채널 소유자',
      type: MessageType.voice,
      content: '긴급 알림! 지금 바로 확인해주세요!',
      mediaUrl: 'https://example.com/urgent.mp3',
      duration: 10,
      createdAt: DateTime.now(),
      readBy: ['other_user'],
    );
    
    if (_channelMessages[channelId] == null) {
      _channelMessages[channelId] = [];
    }
    _channelMessages[channelId]!.add(message);
    
    // 🔥 즉시 전화 알람 트리거!
    if (onNewMessage != null) {
      onNewMessage!(message);
    }
    
    notifyListeners();
  }
}
