import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/channel_model.dart';

class ChannelProvider with ChangeNotifier {
  final List<Channel> _channels = [];
  bool _isLoading = false;
  
  List<Channel> get channels => _channels;
  bool get isLoading => _isLoading;
  
  // 채널 생성
  Future<Channel?> createChannel({
    required String name,
    required String description,
    required String ownerId,
    required String ownerName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // 초대 코드 생성 (6자리)
      final inviteCode = _generateInviteCode();
      
      final channel = Channel(
        id: const Uuid().v4(),
        name: name,
        description: description,
        ownerId: ownerId,
        ownerName: ownerName,
        memberIds: [ownerId],  // 생성자는 자동으로 멤버
        inviteCode: inviteCode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _channels.add(channel);
      _isLoading = false;
      notifyListeners();
      return channel;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
  
  // 초대 코드로 채널 찾기
  Channel? findChannelByInviteCode(String inviteCode) {
    try {
      return _channels.firstWhere((c) => c.inviteCode == inviteCode);
    } catch (e) {
      return null;
    }
  }
  
  // 채널에 멤버 추가
  Future<bool> joinChannel(String channelId, String userId) async {
    try {
      final channel = _channels.firstWhere((c) => c.id == channelId);
      if (!channel.memberIds.contains(userId)) {
        channel.memberIds.add(userId);
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // 내 채널 목록 가져오기
  List<Channel> getMyChannels(String userId) {
    return _channels.where((c) => 
      c.memberIds.contains(userId) || c.ownerId == userId
    ).toList();
  }
  
  // 6자리 초대 코드 생성
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    
    for (int i = 0; i < 6; i++) {
      code += chars[(random + i) % chars.length];
    }
    
    return code;
  }
  
  // 샘플 채널 추가 (테스트용)
  void loadSampleChannels(String userId) {
    if (_channels.isEmpty) {
      _channels.addAll([
        Channel(
          id: '1',
          name: '가족 채널 👨‍👩‍👧‍👦',
          description: '우리 가족만의 알림 채널',
          ownerId: userId,
          ownerName: '나',
          memberIds: [userId],
          inviteCode: 'FAM123',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now(),
        ),
        Channel(
          id: '2',
          name: '친구들 🎉',
          description: '친구들과 함께하는 알림',
          ownerId: userId,
          ownerName: '나',
          memberIds: [userId, 'user2', 'user3'],
          inviteCode: 'FRN456',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now(),
        ),
      ]);
      notifyListeners();
    }
  }
}
