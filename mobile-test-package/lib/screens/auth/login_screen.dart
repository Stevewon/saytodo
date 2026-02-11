import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고/아이콘
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      size: 60,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 앱 이름
                  const Text(
                    'Channel Alarm',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 설명
                  Text(
                    '채널을 만들고 지인들에게\n음성/영상 알림을 보내보세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 64),
                  
                  // 구글 로그인 버튼
                  authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton.icon(
                          onPressed: () async {
                            final success = await authProvider.signInWithGoogle();
                            if (success && context.mounted) {
                              // 로그인 성공은 자동으로 ChannelListScreen으로 이동
                            }
                          },
                          icon: Image.network(
                            'https://www.google.com/favicon.ico',
                            width: 24,
                            height: 24,
                            errorBuilder: (_, __, ___) => const Icon(Icons.login),
                          ),
                          label: const Text(
                            'Google로 계속하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                        ),
                  
                  const SizedBox(height: 24),
                  
                  // 설명 아이콘들
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    children: [
                      _buildFeatureIcon(Icons.people, '채널 생성'),
                      _buildFeatureIcon(Icons.share, '지인 초대'),
                      _buildFeatureIcon(Icons.mic, '음성 전송'),
                      _buildFeatureIcon(Icons.videocam, '영상 공유'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
