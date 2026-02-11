import 'package:flutter/material.dart';

class VoiceRecordScreen extends StatefulWidget {
  const VoiceRecordScreen({super.key});

  @override
  State<VoiceRecordScreen> createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _text = '';
  double _confidence = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    // TODO: 실제 음성 인식 구현
    setState(() => _isListening = true);
    
    // 임시 시뮬레이션
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _text = '내일 오후 3시에 회의 참석하기';
      _confidence = 0.95;
    });
  }

  void _stopListening() {
    setState(() => _isListening = false);
  }

  void _saveTodo() {
    if (_text.isNotEmpty) {
      // TODO: Todo 저장 로직
      Navigator.of(context).pop(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음성 녹음'),
        actions: [
          if (_text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveTodo,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 녹음 애니메이션
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: 200 + (_animationController.value * 40),
                    height: 200 + (_animationController.value * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      boxShadow: _isListening
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 20,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 80,
                      color: _isListening
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              // 인식된 텍스트
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _text.isEmpty ? '음성을 입력하세요' : _text,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_confidence > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '신뢰도: ${(_confidence * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // 녹음 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(_isListening ? Icons.stop : Icons.mic),
                  label: Text(
                    _isListening ? '녹음 중지' : '녹음 시작',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
