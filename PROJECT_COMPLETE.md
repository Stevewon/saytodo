# 🎉 세이투두 (SayToDo) - 완성! 

**전화벨처럼 울리는 할 일 알림 시스템**

[![Status](https://img.shields.io/badge/status-functional-success)](https://github.com)
[![Backend](https://img.shields.io/badge/backend-node.js-green)](https://nodejs.org)
[![Frontend](https://img.shields.io/badge/frontend-react--native-blue)](https://reactnative.dev)
[![Platform](https://img.shields.io/badge/platform-android-brightgreen)](https://android.com)

---

## 📱 프로젝트 개요

중요한 메시지를 **전화벨처럼** 울려서 절대 놓치지 않게 만드는 긴급 알림 앱입니다.

> 💡 **핵심 아이디어**: 사람들은 문자나 톡은 잘 안 봐도 전화가 오면 반드시 받습니다!

## ✅ 구현 완료 기능 (13/14)

### 🎯 **백엔드 서버** (Node.js + Express)
- ✅ JWT 인증 시스템
- ✅ 구글 로그인 자동 가입/로그인
- ✅ 채널 생성 및 관리
- ✅ 멤버 초대 (이메일 기반)
- ✅ 긴급 알림 발송 (FCM High Priority)
- ✅ 알림 응답 처리 (수락/거절/미응답)
- ✅ 미디어 파일 업로드 (음성/영상, 최대 50MB)
- ✅ YouTube URL 지원
- ✅ Socket.io 실시간 통신
- ✅ SQLite 데이터베이스

### 📱 **Android 앱** (React Native 0.83.1)
- ✅ 구글 로그인 (자동 가입)
- ✅ FCM 푸시 알림 수신
- ✅ **Full-Screen Intent** (전화벨 UI)
- ✅ 채널 목록 화면
- ✅ 채널 생성 화면
- ✅ 채널 상세 화면
- ✅ 멤버 관리 (추가/나가기)
- ✅ 알림 발송 화면
- ✅ 미디어 타입 선택 (텍스트/음성/영상/YouTube)
- ✅ React Navigation 통합
- ⏳ 미디어 재생 (음성/영상) - 준비 중

## 🎨 화면 구성

```
로그인 화면 (LoginScreen)
    ↓ 구글 로그인
채널 목록 (ChannelsListScreen)
    ↓ 채널 선택
채널 상세 (ChannelDetailScreen)
    ├→ 멤버 관리
    └→ 알림 발송 (SendAlertScreen)
         └→ 미디어 선택 및 발송
```

## 🚀 빠른 시작

### 1️⃣ 백엔드 서버 실행

```bash
cd voip-server
npm install
npm start
```

**서버 주소**: `http://localhost:3002`

### 2️⃣ Android 앱 실행

```bash
cd SayToDo
npm install
npm run android
```

### 3️⃣ Firebase 설정

#### 백엔드 (FCM 발송)
1. Firebase Console → 서비스 계정 → 비공개 키 생성
2. 다운로드한 JSON을 `voip-server/firebase-service-account.json`에 저장

#### Android 앱 (FCM 수신 + 구글 로그인)
1. Firebase Console → Android 앱 추가
2. 패키지 이름: `com.saytodo`
3. **SHA-1 인증서** 추가 (필수!)
   ```bash
   cd SayToDo/android
   ./gradlew signingReport
   ```
4. `google-services.json` 다운로드
5. `SayToDo/android/app/google-services.json`에 저장
6. Web Client ID 복사
7. `SayToDo/App.tsx`에서 `GOOGLE_WEB_CLIENT_ID` 교체

자세한 설정: [GOOGLE_LOGIN_SETUP.md](SayToDo/GOOGLE_LOGIN_SETUP.md)

## 📊 프로젝트 구조

```
saytodo-project/
├── voip-server/              ✅ 백엔드 서버
│   ├── routes/              ✅ API 라우트
│   │   ├── auth.js         ✅ 인증 (구글 로그인 포함)
│   │   ├── channels.js     ✅ 채널 관리
│   │   ├── alerts.js       ✅ 알림 발송/응답
│   │   └── media.js        ✅ 미디어 업로드
│   ├── database.js         ✅ SQLite DB
│   ├── firebase.js         ✅ FCM Push
│   └── index.js            ✅ 서버 엔트리
│
└── SayToDo/                  ✅ React Native 앱
    ├── android/              ✅ 안드로이드 네이티브
    │   └── app/src/main/java/com/saytodo/fcm/
    │       └── FCMService.java  ✅ 커스텀 FCM 서비스
    ├── src/
    │   ├── screens/          ✅ UI 화면
    │   │   ├── LoginScreen.tsx
    │   │   ├── ChannelsListScreen.tsx
    │   │   ├── CreateChannelScreen.tsx
    │   │   ├── ChannelDetailScreen.tsx
    │   │   └── SendAlertScreen.tsx
    │   ├── navigation/       ✅ React Navigation
    │   ├── services/         ✅ API & FCM 서비스
    │   ├── types/            ✅ TypeScript 타입
    │   └── utils/            ✅ 설정
    └── App.tsx               ✅ 메인 앱
```

## 🎯 사용 시나리오

### 1. 회원가입 및 로그인
```
앱 실행 → Google 로그인 버튼 클릭 → 구글 계정 선택 → 자동 가입/로그인 완료!
```

### 2. 채널 생성
```
채널 목록 → + 새 채널 → 이름 입력 → 생성 완료 (자동으로 관리자)
```

### 3. 멤버 초대
```
채널 상세 → + 추가 버튼 → 이메일 입력 → 멤버 추가 완료
```

### 4. 긴급 알림 발송
```
채널 상세 → 📢 긴급 알림 발송 → 제목/메시지 입력 → 미디어 선택 → 발송!
```

### 5. 알림 수신 (수신자)
```
FCM Push 수신 → 전화벨처럼 화면 켜짐 → 수락/거절 선택 → 미디어 재생 또는 종료
```

## 🔔 알림 동작 방식

| 앱 상태 | 동작 |
|---------|------|
| **포그라운드** | Alert 다이얼로그 표시 + 수락/거절 버튼 |
| **백그라운드** | Full-screen 알림 (전화 UI) + 벨소리 + 진동 |
| **종료 상태** | 앱 자동 시작 + Full-screen 알림 |

**특징**: 무음/진동 모드에서도 울림! 📞

## 🛠 기술 스택

### Backend
- **Node.js 20+** + Express
- **SQLite** - 데이터베이스
- **Firebase Admin SDK** - FCM Push
- **Socket.io** - 실시간 통신
- **Multer** - 파일 업로드
- **JWT** - 인증

### Frontend
- **React Native 0.83.1** + TypeScript
- **Firebase Cloud Messaging** - 푸시 수신
- **Google Sign-In** - 구글 로그인
- **React Navigation** - 화면 네비게이션
- **Axios** - HTTP 클라이언트
- **AsyncStorage** - 로컬 저장소

## 📡 API 엔드포인트

### 인증
```
POST /api/auth/register       - 회원가입 (일반)
POST /api/auth/login          - 로그인 (일반)
POST /api/auth/google-login   - 구글 로그인 (자동 가입)
POST /api/auth/fcm-token      - FCM 토큰 등록
```

### 채널
```
POST   /api/channels/create              - 채널 생성
GET    /api/channels/my-channels         - 내 채널 목록
GET    /api/channels/:id                 - 채널 상세
POST   /api/channels/:id/add-member      - 멤버 추가
DELETE /api/channels/:id/leave           - 채널 나가기
```

### 알림
```
POST /api/alerts/send                     - 긴급 알림 발송
POST /api/alerts/respond                  - 알림 응답
GET  /api/alerts/:id                      - 알림 상세
GET  /api/alerts/channel/:id/history      - 채널 알림 히스토리
```

### 미디어
```
POST   /api/media/upload      - 미디어 업로드
GET    /api/media/:id          - 미디어 정보
GET    /api/media/my/uploads   - 내 업로드 목록
DELETE /api/media/:id          - 미디어 삭제
```

## 🎨 UI 스크린샷 (개념도)

### 로그인 화면
- 📞 앱 로고 + 설명
- Google 로그인 버튼

### 채널 목록
- 📢 내 채널 카드 리스트
- Admin 뱃지 표시
- Pull-to-refresh

### 채널 상세
- 📋 채널 정보
- 👥 멤버 목록
- 📢 긴급 알림 발송 버튼 (빨간색)

### 알림 발송
- 📝 제목/메시지 입력
- 🎤 미디어 타입 선택 (음성/영상/YouTube)
- ⚠️ 경고 메시지

## 🔐 보안

- ✅ JWT 토큰 인증
- ✅ bcrypt 비밀번호 암호화
- ✅ Firebase Admin SDK 서버사이드 검증
- ✅ 파일 크기 제한 (50MB)
- ✅ 채널 접근 권한 검증
- ✅ 관리자/멤버 역할 분리

## 🚧 향후 개발 계획

- [ ] 미디어 재생 시스템 (음성/영상 플레이어)
- [ ] 파일 업로드 UI (이미지 피커)
- [ ] 알림 히스토리 화면
- [ ] 프로필 수정
- [ ] 다크 모드
- [ ] iOS 버전 (CallKit)
- [ ] Push 알림 설정
- [ ] 알림 통계 대시보드

## 🎓 배운 점

1. **VoIP Push 알림** - Full-Screen Intent로 전화처럼 울리기
2. **구글 로그인 통합** - 자동 가입/로그인 처리
3. **React Native + TypeScript** - 타입 안전한 모바일 앱
4. **Firebase Cloud Messaging** - High Priority Push
5. **React Navigation** - 화면 전환 및 네비게이션

## 📄 문서

- [메인 README](README_SAYTODO.md) - 전체 프로젝트 개요
- [백엔드 README](voip-server/README.md) - API 문서
- [Android README](SayToDo/README.md) - 앱 문서
- [구글 로그인 가이드](SayToDo/GOOGLE_LOGIN_SETUP.md) - Firebase 설정

## 🤝 기여

이 프로젝트는 오픈 소스입니다. 기여를 환영합니다!

## 📝 라이선스

MIT License

---

**세이투두 - 절대 놓치지 않는 알림 시스템** 🔔

Made with ❤️ by GenSpark AI Developer
