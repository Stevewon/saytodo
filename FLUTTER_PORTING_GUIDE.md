# 🚀 SayToDo Flutter 포팅 가이드

React Native → Flutter 완전 전환 가이드

---

## 📋 목차

1. [개요](#개요)
2. [Flutter 프로젝트 생성](#flutter-프로젝트-생성)
3. [패키지 설정](#패키지-설정)
4. [프로젝트 구조](#프로젝트-구조)
5. [화면별 구현](#화면별-구현)
6. [Firebase 연동](#firebase-연동)
7. [기능 구현](#기능-구현)
8. [빌드 & 배포](#빌드--배포)

---

## 개요

### 왜 Flutter?
- ✅ **빠른 빌드**: APK 생성 5-10분 (React Native 대비 안정적)
- ✅ **단일 코드베이스**: iOS + Android 동시 지원
- ✅ **우수한 성능**: 네이티브 수준 성능
- ✅ **풍부한 UI**: Material Design + Cupertino 기본 제공
- ✅ **강력한 커뮤니티**: 방대한 패키지 생태계

### React Native vs Flutter 비교

| 항목 | React Native | Flutter |
|------|--------------|---------|
| 언어 | JavaScript/TypeScript | Dart |
| UI 프레임워크 | React Components | Widgets |
| 빌드 시간 | 느림 (10-20분) | 빠름 (5-10분) |
| Hot Reload | ✅ | ✅ |
| 패키지 관리 | npm | pub.dev |
| Firebase | ✅ | ✅ |

---

## Flutter 프로젝트 생성

### 1️⃣ Flutter 설치

**Windows:**
```bash
# 1. Flutter SDK 다운로드
https://docs.flutter.dev/get-started/install/windows

# 2. 압축 해제
# C:\flutter 에 압축 해제

# 3. 환경 변수 설정
# Path에 추가: C:\flutter\bin

# 4. 확인
flutter doctor
```

**Mac:**
```bash
# Homebrew로 설치
brew install --cask flutter

# 확인
flutter doctor
```

**Linux:**
```bash
# Flutter SDK 다운로드
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

# Path 추가
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 확인
flutter doctor
```

### 2️⃣ 프로젝트 생성

```bash
# 새 Flutter 프로젝트 생성
flutter create saytodo_flutter

# 프로젝트 이동
cd saytodo_flutter

# 실행 확인
flutter run
```

---

## 패키지 설정

### pubspec.yaml

```yaml
name: saytodo_flutter
description: AI-powered voice to todo app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
    
  # UI/UX
  cupertino_icons: ^1.0.2
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  
  # 상태 관리
  provider: ^6.1.1
  get: ^4.6.6
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_messaging: ^14.7.9
  firebase_storage: ^11.5.6
  
  # Google 로그인
  google_sign_in: ^6.1.6
  
  # 음성 녹음 & STT
  speech_to_text: ^6.6.0
  permission_handler: ^11.1.0
  record: ^5.0.4
  
  # HTTP & API
  http: ^1.1.2
  dio: ^5.4.0
  
  # 로컬 저장소
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  
  # 날짜 & 시간
  intl: ^0.18.1
  
  # 기타 유틸리티
  uuid: ^4.2.2
  flutter_local_notifications: ^16.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

### 패키지 설치

```bash
flutter pub get
```

---

## 프로젝트 구조

```
saytodo_flutter/
├── lib/
│   ├── main.dart                 # 앱 진입점
│   ├── config/
│   │   ├── theme.dart           # 테마 설정
│   │   └── routes.dart          # 라우팅 설정
│   ├── models/
│   │   ├── todo_model.dart      # Todo 모델
│   │   └── user_model.dart      # User 모델
│   ├── providers/
│   │   ├── auth_provider.dart   # 인증 상태 관리
│   │   ├── todo_provider.dart   # Todo 상태 관리
│   │   └── voice_provider.dart  # 음성 상태 관리
│   ├── services/
│   │   ├── firebase_service.dart     # Firebase 서비스
│   │   ├── speech_service.dart       # STT 서비스
│   │   └── notification_service.dart # 알림 서비스
│   ├── screens/
│   │   ├── splash_screen.dart        # 스플래시
│   │   ├── auth/
│   │   │   └── login_screen.dart     # 로그인
│   │   ├── home/
│   │   │   └── home_screen.dart      # 홈
│   │   ├── voice/
│   │   │   └── voice_record_screen.dart  # 음성 녹음
│   │   ├── todo/
│   │   │   ├── todo_list_screen.dart     # 할 일 목록
│   │   │   ├── todo_detail_screen.dart   # 할 일 상세
│   │   │   └── todo_edit_screen.dart     # 할 일 편집
│   │   └── profile/
│   │       └── profile_screen.dart       # 프로필
│   ├── widgets/
│   │   ├── todo_item.dart       # Todo 아이템
│   │   ├── voice_button.dart    # 음성 버튼
│   │   └── loading_widget.dart  # 로딩
│   └── utils/
│       ├── constants.dart       # 상수
│       └── helpers.dart         # 헬퍼 함수
├── android/
├── ios/
└── pubspec.yaml
```

---

## 화면별 구현

### 1️⃣ main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saytodo_flutter/providers/auth_provider.dart';
import 'package:saytodo_flutter/providers/todo_provider.dart';
import 'package:saytodo_flutter/config/theme.dart';
import 'package:saytodo_flutter/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'SayToDo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

### 2️⃣ theme.dart (테마 설정)

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 컬러
  static const primaryColor = Color(0xFF6366F1);
  static const secondaryColor = Color(0xFF8B5CF6);
  static const backgroundColor = Color(0xFFF9FAFB);
  static const cardColor = Colors.white;
  
  // Light 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primaryColor,
      ),
    );
  }
  
  // Dark 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: const Color(0xFF111827),
    );
  }
}
```

### 3️⃣ Todo 모델

```dart
// lib/models/todo_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final String category;
  final int priority; // 1: 높음, 2: 보통, 3: 낮음
  final DateTime createdAt;
  final DateTime? dueDate;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.category = '일반',
    this.priority = 2,
    required this.createdAt,
    this.dueDate,
  });

  // Firestore에서 읽기
  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      category: data['category'] ?? '일반',
      priority: data['priority'] ?? 2,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dueDate: data['dueDate'] != null 
          ? (data['dueDate'] as Timestamp).toDate() 
          : null,
    );
  }

  // Firestore에 쓰기
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'category': category,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }

  // 복사 메서드
  TodoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    String? category,
    int? priority,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
```

### 4️⃣ 로그인 화면

```dart
// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saytodo_flutter/providers/auth_provider.dart';
import 'package:saytodo_flutter/screens/home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.mic,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 타이틀
              Text(
                'SayToDo',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '음성으로 할 일을 관리하세요',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Google 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          final success = await authProvider.signInWithGoogle();
                          if (success && context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                  icon: authProvider.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Image.asset(
                          'assets/images/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                  label: Text(
                    authProvider.isLoading ? '로그인 중...' : 'Google로 계속하기',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 에러 메시지
              if (authProvider.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authProvider.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 5️⃣ 홈 화면

```dart
// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saytodo_flutter/providers/todo_provider.dart';
import 'package:saytodo_flutter/screens/voice/voice_record_screen.dart';
import 'package:saytodo_flutter/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Todo 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SayToDo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // 프로필 화면으로 이동
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoProvider.todos.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => todoProvider.loadTodos(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return TodoItem(
                  todo: todo,
                  onTap: () {
                    // Todo 상세로 이동
                  },
                  onToggle: () {
                    todoProvider.toggleTodo(todo.id);
                  },
                  onDelete: () {
                    todoProvider.deleteTodo(todo.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VoiceRecordScreen(),
            ),
          );
        },
        icon: const Icon(Icons.mic),
        label: const Text('음성 녹음'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            '할 일이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '음성 녹음으로 할 일을 추가하세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VoiceRecordScreen(),
                ),
              );
            },
            icon: const Icon(Icons.mic),
            label: const Text('음성 녹음 시작'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 6️⃣ 음성 녹음 화면

```dart
// lib/screens/voice/voice_record_screen.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRecordScreen extends StatefulWidget {
  const VoiceRecordScreen({super.key});

  @override
  State<VoiceRecordScreen> createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            _confidence = result.confidence;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _saveTodo() {
    if (_text.isNotEmpty) {
      // Todo 저장 로직
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
```

---

## Firebase 연동

### 1️⃣ Firebase 프로젝트 설정

React Native의 Firebase 프로젝트를 **그대로 사용** 가능합니다!

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Flutter 프로젝트에서 Firebase 설정
cd saytodo_flutter
firebase login
flutterfire configure
```

### 2️⃣ Firebase 서비스

```dart
// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saytodo_flutter/models/todo_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 사용자 ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Todo 생성
  Future<String> createTodo(TodoModel todo) async {
    try {
      final docRef = await _firestore
          .collection('todos')
          .add(todo.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('할 일 생성 실패: $e');
    }
  }

  // Todo 목록 가져오기
  Stream<List<TodoModel>> getTodos() {
    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TodoModel.fromFirestore(doc))
          .toList();
    });
  }

  // Todo 업데이트
  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('todos').doc(id).update(data);
    } catch (e) {
      throw Exception('할 일 업데이트 실패: $e');
    }
  }

  // Todo 삭제
  Future<void> deleteTodo(String id) async {
    try {
      await _firestore.collection('todos').doc(id).delete();
    } catch (e) {
      throw Exception('할 일 삭제 실패: $e');
    }
  }

  // Todo 완료 토글
  Future<void> toggleTodo(String id, bool isCompleted) async {
    await updateTodo(id, {'isCompleted': !isCompleted});
  }
}
```

---

## 기능 구현

### Provider (상태 관리)

```dart
// lib/providers/todo_provider.dart
import 'package:flutter/foundation.dart';
import 'package:saytodo_flutter/models/todo_model.dart';
import 'package:saytodo_flutter/services/firebase_service.dart';

class TodoProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<TodoModel> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Todo 목록 로드
  void loadTodos() {
    _isLoading = true;
    notifyListeners();

    _firebaseService.getTodos().listen(
      (todos) {
        _todos = todos;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Todo 추가
  Future<void> addTodo(TodoModel todo) async {
    try {
      await _firebaseService.createTodo(todo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Todo 완료 토글
  Future<void> toggleTodo(String id) async {
    final todo = _todos.firstWhere((t) => t.id == id);
    await _firebaseService.toggleTodo(id, todo.isCompleted);
  }

  // Todo 삭제
  Future<void> deleteTodo(String id) async {
    await _firebaseService.deleteTodo(id);
  }
}
```

---

## 빌드 & 배포

### Android APK 빌드

```bash
# 1. 의존성 설치
flutter pub get

# 2. APK 빌드 (Release)
flutter build apk --release

# 3. APK 위치
# build/app/outputs/flutter-apk/app-release.apk
```

⏱️ **빌드 시간: 약 5-10분** (React Native보다 빠름!)

### iOS 빌드

```bash
# iOS 빌드
flutter build ios --release

# IPA 위치
# build/ios/iphoneos/Runner.app
```

### 앱 번들 (Google Play)

```bash
# AAB 빌드
flutter build appbundle --release

# AAB 위치
# build/app/outputs/bundle/release/app-release.aab
```

---

## 완성 체크리스트

### ✅ 완료해야 할 작업

- [ ] Flutter 프로젝트 생성
- [ ] 패키지 설치 (pubspec.yaml)
- [ ] Firebase 연동
- [ ] 로그인 화면 구현
- [ ] 홈 화면 구현
- [ ] Todo 모델 & Provider 구현
- [ ] 음성 녹음 화면 구현
- [ ] Todo 상세/편집 화면 구현
- [ ] 프로필 화면 구현
- [ ] 푸시 알림 설정
- [ ] 권한 요청 (마이크, 알림)
- [ ] 에러 처리
- [ ] 로딩 상태 처리
- [ ] APK 빌드 & 테스트

---

## 예상 작업 시간

| 작업 | 시간 |
|------|------|
| 프로젝트 설정 | 1-2시간 |
| Firebase 연동 | 1시간 |
| 화면 구현 (7개) | 1-2일 |
| 기능 구현 | 2-3일 |
| 테스트 & 버그 수정 | 1-2일 |
| **총 예상 시간** | **5-7일** |

---

## 🎯 다음 단계

### 1️⃣ 즉시 시작하기

```bash
# 1. SayToDo React Native 소스 다운로드
wget https://github.com/Stevewon/saytodo/raw/main/SayToDo-Source-Final.tar.gz
tar -xzf SayToDo-Source-Final.tar.gz

# 2. Flutter 프로젝트 생성
flutter create saytodo_flutter
cd saytodo_flutter

# 3. 이 가이드를 참고하여 화면별 포팅 시작!
```

### 2️⃣ React Native 소스 참고

- `SayToDo-Source-Temp/src/screens/` - 화면 UI/UX 참고
- `SayToDo-Source-Temp/src/services/` - 로직 참고
- `SayToDo-Source-Temp/android/app/google-services.json` - Firebase 설정 그대로 사용

### 3️⃣ Flutter 커뮤니티

- **공식 문서**: https://flutter.dev/docs
- **pub.dev**: https://pub.dev (패키지 검색)
- **Flutter 한국 커뮤니티**: https://flutter-korea.github.io

---

## 💡 팁 & 트릭

### Hot Reload 활용
```bash
# 앱 실행 중 'r' 키 입력으로 Hot Reload
flutter run
# r - Hot Reload
# R - Hot Restart
# q - 종료
```

### 디버깅
```dart
// print 대신 debugPrint 사용
debugPrint('Todo 추가: ${todo.title}');

// Flutter DevTools
flutter run --observatory-port=8888
```

### 성능 최적화
```dart
// const 위젯 사용
const Text('SayToDo');

// ListView.builder 사용 (많은 아이템)
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) => TodoItem(todo: todos[index]),
);
```

---

## 🚀 시작하세요!

Flutter로 SayToDo를 포팅하면:
- ✅ **빠른 빌드**: 5-10분 안에 APK 생성
- ✅ **안정적**: React Native 대비 빌드 오류 적음
- ✅ **고성능**: 네이티브 수준 성능
- ✅ **iOS 지원**: 하나의 코드로 양쪽 지원

**지금 바로 시작하세요!** 🎉

---

궁금한 점이 있으면 언제든 물어보세요! 😊
