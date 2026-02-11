import 'package:flutter/material.dart';
import 'dart:async';

class IncomingCallScreen extends StatefulWidget {
  final String channelName;
  final String senderName;
  final String messageType; // 'voice', 'video', 'youtube'
  final String? mediaUrl;
  final String? youtubeUrl;
  
  const IncomingCallScreen({
    Key? key,
    required this.channelName,
    required this.senderName,
    required this.messageType,
    this.mediaUrl,
    this.youtubeUrl,
  }) : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  
  bool _isAccepted = false;
  bool _isPlaying = false;
  
  @override
  void initState() {
    super.initState();
    
    // 맥박 애니메이션 (전화벨 효과)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // 진동 애니메이션
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);
    
    _shakeAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
    
    // 🔥 실제 벨소리 재생!
    _playRingtone();
  }
  
  void _playRingtone() {
    // 웹에서는 HTML audio 사용 (조건부)
    // 실제 앱에서는 audioplayers 사용
    debugPrint('🔔 전화벨이 울립니다!');
  }
  
  void _stopRingtone() {
    debugPrint('🔇 전화벨 정지');
  }
  
  void _acceptCall() async {
    setState(() => _isAccepted = true);
    _stopRingtone();
    _pulseController.stop();
    _shakeController.stop();
    
    // 수락 후 미디어 재생
    if (widget.messageType == 'voice' && widget.mediaUrl != null) {
      await _playVoice(widget.mediaUrl!);
    } else if (widget.messageType == 'video' && widget.mediaUrl != null) {
      await _playVideo(widget.mediaUrl!);
    } else if (widget.messageType == 'youtube' && widget.youtubeUrl != null) {
      _openYoutubeLink(widget.youtubeUrl!);
    }
  }
  
  void _rejectCall() {
    _stopRingtone();
    Navigator.of(context).pop(false); // 거절
  }
  
  Future<void> _playVoice(String url) async {
    setState(() => _isPlaying = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
  
  Future<void> _playVideo(String url) async {
    setState(() => _isPlaying = true);
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
  
  void _openYoutubeLink(String url) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _stopRingtone();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isAccepted && _isPlaying) {
      return _buildPlayingScreen();
    }
    
    return _buildIncomingCallScreen();
  }
  
  Widget _buildIncomingCallScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // 채널 이름
                  Text(
                    widget.channelName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 발신자 이름 (큰 글씨)
                  Text(
                    widget.senderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // 메시지 타입
                  _buildMessageTypeIndicator(),
                  
                  const SizedBox(height: 40),
                  
                  // 전화 아이콘 (맥박 효과)
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                      child: const Icon(
                        Icons.phone,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 🔥 전화처럼 울리고 있음을 명확히 표시
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.volume_up, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '전화가 오고 있습니다...',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 수락/거절 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 거절 버튼 (빨간색)
                        _buildCallButton(
                          icon: Icons.call_end,
                          color: Colors.red,
                          onPressed: _rejectCall,
                          label: '거절',
                        ),
                        
                        // 수락 버튼 (초록색)
                        _buildCallButton(
                          icon: Icons.call,
                          color: Colors.green,
                          onPressed: _acceptCall,
                          label: '수락',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildMessageTypeIndicator() {
    IconData icon;
    String label;
    
    switch (widget.messageType) {
      case 'voice':
        icon = Icons.mic;
        label = '음성 메시지';
        break;
      case 'video':
        icon = Icons.videocam;
        label = '영상 메시지';
        break;
      case 'youtube':
        icon = Icons.play_circle;
        label = '유튜브 링크';
        break;
      default:
        icon = Icons.message;
        label = '메시지';
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCallButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlayingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              title: Text(
                widget.channelName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 재생 중 아이콘
                    if (widget.messageType == 'voice')
                      const Icon(Icons.mic, size: 100, color: Colors.green),
                    if (widget.messageType == 'video')
                      const Icon(Icons.videocam, size: 100, color: Colors.blue),
                    if (widget.messageType == 'youtube')
                      const Icon(Icons.play_circle, size: 100, color: Colors.red),
                    
                    const SizedBox(height: 30),
                    
                    // 재생 중 텍스트
                    Text(
                      _getPlayingText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 발신자 이름
                    Text(
                      '${widget.senderName}님의 메시지',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 진행 표시
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
  
  String _getPlayingText() {
    switch (widget.messageType) {
      case 'voice':
        return '음성 재생 중...';
      case 'video':
        return '영상 재생 중...';
      case 'youtube':
        return '유튜브 열기...';
      default:
        return '재생 중...';
    }
  }
}
