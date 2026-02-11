# SayToDo Flutter Starter

React Native SayToDo를 Flutter로 포팅하기 위한 스타터 템플릿입니다.

## 🚀 빠른 시작

### 1️⃣ Flutter 설치 확인
```bash
flutter doctor
```

### 2️⃣ 의존성 설치
```bash
flutter pub get
```

### 3️⃣ Firebase 설정
```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 프로젝트 연결
firebase login
flutterfire configure
```

### 4️⃣ 앱 실행
```bash
# Android
flutter run

# iOS
flutter run -d ios
```

## 📦 포함된 패키지

- **Firebase**: 인증, Firestore, 푸시 알림
- **Google 로그인**: google_sign_in
- **음성 인식**: speech_to_text
- **상태 관리**: provider
- **UI**: google_fonts, flutter_svg

## 📁 권장 프로젝트 구조

```
lib/
├── main.dart
├── config/
│   ├── theme.dart
│   └── routes.dart
├── models/
│   ├── todo_model.dart
│   └── user_model.dart
├── providers/
│   ├── auth_provider.dart
│   └── todo_provider.dart
├── services/
│   ├── firebase_service.dart
│   └── speech_service.dart
├── screens/
│   ├── auth/
│   ├── home/
│   └── voice/
└── widgets/
    └── todo_item.dart
```

## 🎯 다음 단계

1. React Native 소스 다운로드
   ```bash
   wget https://github.com/Stevewon/saytodo/raw/main/SayToDo-Source-Final.tar.gz
   ```

2. Flutter 포팅 가이드 참고
   - [FLUTTER_PORTING_GUIDE.md](../FLUTTER_PORTING_GUIDE.md)

3. 화면별로 포팅 시작!

## 📱 APK 빌드

```bash
# Release APK 빌드
flutter build apk --release

# APK 위치
# build/app/outputs/flutter-apk/app-release.apk
```

## ✅ 예상 작업 시간

- 프로젝트 설정: 1-2시간
- 화면 구현: 1-2일
- 기능 구현: 2-3일
- 테스트: 1-2일
- **총 예상: 5-7일**

---

**Happy Coding!** 🎉
