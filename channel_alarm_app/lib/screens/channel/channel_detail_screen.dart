import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/channel_model.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../message/send_message_screen.dart';

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
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    
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
                  content: Text('📞 전화 알람이 울립니다!'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
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
          // 🔥 채팅 없음 - 깔끔한 화면
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.channel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.channel.memberIds.length}명의 멤버',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 테스트 버튼 크게
                  ElevatedButton.icon(
                    onPressed: () {
                      messageProvider.simulateIncomingMessage(
                        widget.channel.id,
                        widget.channel.name,
                      );
                    },
                    icon: const Icon(Icons.phone, size: 28),
                    label: const Text(
                      '전화 알람 테스트',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '아래 버튼으로 알림을 전송하세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 하단 전송 버튼들 (크게!)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 음성 버튼
                _buildBigActionButton(
                  context,
                  icon: Icons.mic,
                  label: '음성 메시지 전송',
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
                const SizedBox(height: 12),
                // 영상 버튼
                _buildBigActionButton(
                  context,
                  icon: Icons.videocam,
                  label: '영상 메시지 전송',
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
                const SizedBox(height: 12),
                // 링크 버튼
                _buildBigActionButton(
                  context,
                  icon: Icons.link,
                  label: '유튜브 링크 전송',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBigActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
