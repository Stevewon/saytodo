import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/channel_model.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';

class SendMessageScreen extends StatefulWidget {
  final Channel channel;
  final MessageType messageType;
  
  const SendMessageScreen({
    super.key,
    required this.channel,
    required this.messageType,
  });

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final _contentController = TextEditingController();
  bool _isRecording = false;
  int _recordingSeconds = 0;
  
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 채널 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.groups,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.channel.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${widget.channel.memberIds.length}명에게 전송됩니다',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 메시지 타입별 UI
            if (widget.messageType == MessageType.voice)
              _buildVoiceRecorder()
            else if (widget.messageType == MessageType.video)
              _buildVideoRecorder()
            else if (widget.messageType == MessageType.youtube)
              _buildYoutubeLinkInput(),
            
            const SizedBox(height: 32),
            
            // 전송 버튼
            ElevatedButton.icon(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
              label: Text(
                '전송하기 (${widget.channel.memberIds.length}명)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 안내
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications_active, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '알림 전송',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• 모든 멤버에게 푸시 알림이 전송됩니다\n'
                      '• 일반 전화처럼 알림이 표시됩니다\n'
                      '• 멤버들은 즉시 확인할 수 있습니다',
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getTitle() {
    switch (widget.messageType) {
      case MessageType.voice:
        return '음성 메시지 보내기';
      case MessageType.video:
        return '영상 보내기';
      case MessageType.youtube:
        return '유튜브 링크 공유';
      default:
        return '메시지 보내기';
    }
  }
  
  Widget _buildVoiceRecorder() {
    return Column(
      children: [
        // 녹음 애니메이션
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isRecording 
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
          ),
          child: Center(
            child: Icon(
              Icons.mic,
              size: 100,
              color: _isRecording ? Colors.red : Colors.blue,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 녹음 시간
        if (_isRecording)
          Text(
            '${_recordingSeconds}초',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        
        const SizedBox(height: 24),
        
        // 녹음 버튼
        ElevatedButton.icon(
          onPressed: _toggleRecording,
          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          label: Text(_isRecording ? '녹음 중지' : '녹음 시작'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRecording ? Colors.red : Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
        ),
        
        if (_recordingSeconds > 0 && !_isRecording)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              '녹음 완료: $_recordingSeconds초',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildVideoRecorder() {
    return Column(
      children: [
        // 비디오 프리뷰 영역
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecording ? Icons.videocam : Icons.videocam_off,
                  size: 80,
                  color: _isRecording ? Colors.red : Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording ? '녹화 중...' : '비디오 카메라',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                if (_isRecording)
                  Text(
                    '${_recordingSeconds}초',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 녹화 버튼
        ElevatedButton.icon(
          onPressed: _toggleRecording,
          icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
          label: Text(_isRecording ? '녹화 중지' : '녹화 시작'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRecording ? Colors.red : Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
        ),
        
        if (_recordingSeconds > 0 && !_isRecording)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              '녹화 완료: $_recordingSeconds초',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildYoutubeLinkInput() {
    return Column(
      children: [
        // 유튜브 아이콘
        Icon(
          Icons.play_circle,
          size: 100,
          color: Colors.red,
        ),
        
        const SizedBox(height: 24),
        
        // URL 입력
        TextField(
          controller: _contentController,
          decoration: InputDecoration(
            labelText: '유튜브 링크',
            hintText: 'https://youtube.com/watch?v=...',
            prefixIcon: const Icon(Icons.link),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.url,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          '유튜브 영상 링크를 입력하세요',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      
      if (_isRecording) {
        // 녹음 시작
        _recordingSeconds = 0;
        _startRecording();
      } else {
        // 녹음 중지
        _stopRecording();
      }
    });
  }
  
  void _startRecording() {
    // 시뮬레이션: 1초마다 증가
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRecording) return false;
      
      setState(() {
        _recordingSeconds++;
      });
      return true;
    });
  }
  
  void _stopRecording() {
    // 녹음 중지 처리
  }
  
  Future<void> _sendMessage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    
    if (currentUser == null) return;
    
    String content;
    int? duration;
    
    switch (widget.messageType) {
      case MessageType.voice:
        if (_recordingSeconds == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('음성을 녹음해주세요')),
          );
          return;
        }
        content = '음성 메시지';
        duration = _recordingSeconds;
        break;
        
      case MessageType.video:
        if (_recordingSeconds == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('영상을 녹화해주세요')),
          );
          return;
        }
        content = '영상';
        duration = _recordingSeconds;
        break;
        
      case MessageType.youtube:
        content = _contentController.text.trim();
        if (content.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유튜브 링크를 입력해주세요')),
          );
          return;
        }
        break;
        
      default:
        content = '';
    }
    
    final message = await messageProvider.sendMessage(
      channelId: widget.channel.id,
      senderId: currentUser.id,
      senderName: currentUser.displayName,
      type: widget.messageType,
      content: content,
      mediaUrl: 'https://example.com/media/${DateTime.now().millisecondsSinceEpoch}',
      duration: duration,
    );
    
    if (message != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.channel.memberIds.length}명에게 전송했습니다!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
