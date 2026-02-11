import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/channel_provider.dart';

class CreateChannelScreen extends StatefulWidget {
  const CreateChannelScreen({super.key});

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final channelProvider = Provider.of<ChannelProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 채널 만들기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 안내 텍스트
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '채널을 만들고 지인들을 초대하여\n음성, 영상, 링크를 공유하세요!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 채널 아이콘 (임시)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.groups, size: 50, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 채널 이름
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '채널 이름',
                  hintText: '예: 가족 채널, 친구들',
                  prefixIcon: const Icon(Icons.label),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '채널 이름을 입력해주세요';
                  }
                  if (value.trim().length < 2) {
                    return '채널 이름은 2글자 이상이어야 합니다';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // 채널 설명
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '채널 설명',
                  hintText: '이 채널에 대해 간단히 설명해주세요',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '채널 설명을 입력해주세요';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // 생성 버튼
              ElevatedButton(
                onPressed: channelProvider.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final currentUser = authProvider.currentUser;
                          if (currentUser == null) return;
                          
                          final channel = await channelProvider.createChannel(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            ownerId: currentUser.id,
                            ownerName: currentUser.displayName,
                          );
                          
                          if (channel != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('채널 "${channel.name}" 생성 완료!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('채널 생성 실패. 다시 시도해주세요.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: channelProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        '채널 만들기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // 안내 카드
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💡 채널 생성 후',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('1️⃣ 초대 코드가 자동으로 생성됩니다'),
                      _buildInfoRow('2️⃣ 공유 버튼으로 지인을 초대하세요'),
                      _buildInfoRow('3️⃣ 음성/영상/링크를 전송할 수 있습니다'),
                      _buildInfoRow('4️⃣ 모든 멤버에게 푸시 알림이 전송됩니다'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }
}
