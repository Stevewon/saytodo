import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/channel_model.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../message/send_message_screen.dart';
import '../../services/call_notification_service.dart';

class ChannelDetailScreen extends StatefulWidget {
  final Channel channel;
  
  const ChannelDetailScreen({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 샘플 메시지 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      if (auth.currentUser != null) {
        messageProvider.loadSampleMessages(widget.channel.id, auth.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(context);
    final messages = messageProvider.getChannelMessages(widget.channel.id);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.channel.name, style: const TextStyle(fontSize: 18)),
            Text(
              '${widget.channel.memberIds.length}명',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          // 🔥 전화 알람 테스트 버튼
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.green),
            tooltip: '전화 알람 테스트',
            onPressed: () {
              messageProvider.simulateIncomingMessage(
                widget.channel.id,
                widget.channel.name,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📞 새 메시지가 도착했습니다! 전화 알람이 울립니다!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // 공유 버튼
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: '채널 공유',
            onPressed: () {
              _showShareDialog(context);
            },
          ),
          // 더보기 메뉴
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'info') {
                _showChannelInfo(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 12),
                    Text('채널 정보'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 목록
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          '아직 메시지가 없습니다',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '첫 메시지를 보내보세요!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,  // 최신 메시지가 아래로
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return _buildMessageCard(message, authProvider.currentUser!.id);
                    },
                  ),
          ),
          
          // 하단 액션 버튼들
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.mic,
                    label: '음성',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SendMessageScreen(
                            channel: widget.channel,
                            messageType: MessageType.voice,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.videocam,
                    label: '영상',
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SendMessageScreen(
                            channel: widget.channel,
                            messageType: MessageType.video,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.link,
                    label: '링크',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SendMessageScreen(
                            channel: widget.channel,
                            messageType: MessageType.youtube,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMessageCard(Message message, String currentUserId) {
    final isMe = message.senderId == currentUserId;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          // 메시지 클릭 시 전화 알람 시뮬레이션
          _testIncomingCall(message);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 보낸 사람
              if (!isMe)
                Text(
                  message.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              if (!isMe) const SizedBox(height: 4),
              
              // 메시지 타입 아이콘
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getMessageIcon(message.type),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message.content,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              
              // 시간
              const SizedBox(height: 4),
              Text(
                _formatTime(message.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              
              // 테스트 힌트
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '👆 탭하여 전화 알람 테스트',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 전화 알람 테스트 함수
  void _testIncomingCall(Message message) {
    String messageType;
    switch (message.type) {
      case MessageType.voice:
        messageType = 'voice';
        break;
      case MessageType.video:
        messageType = 'video';
        break;
      case MessageType.youtube:
        messageType = 'youtube';
        break;
      default:
        messageType = 'voice';
    }
    
    // 전화 알람 표시
    CallNotificationService().showIncomingCallNotification(
      channelName: widget.channel.name,
      senderName: message.senderName,
      messageType: messageType,
      mediaUrl: message.mediaUrl,
      youtubeUrl: message.content,
    );
  }
  
  Icon _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.voice:
        return const Icon(Icons.mic, size: 16, color: Colors.blue);
      case MessageType.video:
        return const Icon(Icons.videocam, size: 16, color: Colors.red);
      case MessageType.youtube:
        return const Icon(Icons.play_circle, size: 16, color: Colors.red);
      case MessageType.text:
        return const Icon(Icons.message, size: 16, color: Colors.grey);
    }
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inDays < 1) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
  
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채널 공유'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '초대 코드',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.channel.inviteCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.channel.getInviteLink(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.channel.inviteCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('초대 코드 복사됨')),
              );
            },
            child: const Text('코드 복사'),
          ),
          TextButton(
            onPressed: () {
              Share.share(
                '${widget.channel.name}에 초대합니다!\n'
                '초대 코드: ${widget.channel.inviteCode}\n'
                '링크: ${widget.channel.getInviteLink()}',
              );
            },
            child: const Text('공유하기'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
  
  void _showChannelInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채널 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('이름', widget.channel.name),
            _buildInfoRow('설명', widget.channel.description),
            _buildInfoRow('소유자', widget.channel.ownerName),
            _buildInfoRow('멤버', '${widget.channel.memberIds.length}명'),
            _buildInfoRow('초대 코드', widget.channel.inviteCode),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
