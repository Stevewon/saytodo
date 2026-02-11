import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/channel_provider.dart';

class JoinChannelScreen extends StatefulWidget {
  const JoinChannelScreen({super.key});

  @override
  State<JoinChannelScreen> createState() => _JoinChannelScreenState();
}

class _JoinChannelScreenState extends State<JoinChannelScreen> {
  final _codeController = TextEditingController();
  
  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final channelProvider = Provider.of<ChannelProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('채널 참가하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 안내
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.vpn_key,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '친구에게 받은 6자리\n초대 코드를 입력하세요',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 초대 코드 입력
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: '초대 코드',
                hintText: '예: FAM123',
                prefixIcon: const Icon(Icons.vpn_key),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              maxLength: 6,
              textCapitalization: TextCapitalization.characters,
            ),
            
            const SizedBox(height: 24),
            
            // 참가 버튼
            ElevatedButton.icon(
              onPressed: () async {
                final code = _codeController.text.trim().toUpperCase();
                if (code.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('6자리 코드를 입력해주세요'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                final channel = channelProvider.findChannelByInviteCode(code);
                if (channel == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('존재하지 않는 초대 코드입니다'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }
                
                final currentUser = authProvider.currentUser;
                if (currentUser == null) return;
                
                final success = await channelProvider.joinChannel(
                  channel.id,
                  currentUser.id,
                );
                
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('채널 "${channel.name}"에 참가했습니다!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('채널 참가 실패. 다시 시도해주세요.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.login),
              label: const Text(
                '채널 참가하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const Spacer(),
            
            // 예시
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 참가 방법',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. 친구에게 초대 코드를 받으세요\n'
                      '2. 위에 6자리 코드를 입력하세요\n'
                      '3. "채널 참가하기" 버튼을 누르세요\n'
                      '4. 채널에서 알림을 받을 수 있습니다',
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.8,
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
}
