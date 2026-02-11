# 📱 Channel Alarm APK 빌드 가이드

## 🎯 목표: 모바일 테스트용 APK 파일 생성

---

## 📦 1. 소스 코드 다운로드

### GitHub에서 직접 다운로드:
```bash
curl -L -O https://github.com/Stevewon/saytodo/raw/main/Channel-Alarm-Schedule-20260211_172350.zip
```

**또는 브라우저에서:**
```
https://github.com/Stevewon/saytodo/raw/main/Channel-Alarm-Schedule-20260211_172350.zip
```

---

## 🔧 2. 필요한 환경

### 필수 설치 항목:

1. **Flutter SDK** (최신 stable 버전)
   - https://flutter.dev/docs/get-started/install
   
2. **Android Studio** (Android SDK 포함)
   - https://developer.android.com/studio
   
3. **JDK 17 이상**
   - Android Studio에 포함되어 있음

---

## 🚀 3. APK 빌드 방법

### Step 1: 압축 해제
```bash
unzip Channel-Alarm-Schedule-20260211_172350.zip
cd channel_alarm_app
```

### Step 2: Flutter 의존성 설치
```bash
flutter pub get
```

### Step 3: Flutter 환경 확인
```bash
flutter doctor
```

**모든 체크가 ✅ 되어야 합니다!**

### Step 4: APK 빌드
```bash
flutter build apk --release
```

**빌드 시간:** 약 2-5분

### Step 5: APK 파일 위치
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📲 4. APK 설치 방법

### Android 기기에 설치:

1. **APK 파일을 폰으로 전송**
   - USB 케이블
   - 이메일
   - 카카오톡
   - Google Drive

2. **설치**
   - 파일 매니저에서 APK 클릭
   - "알 수 없는 출처" 허용
   - 설치 진행

---

## 🔥 대안: 웹으로 즉시 테스트!

**APK 빌드 없이 바로 테스트하고 싶다면:**

### 📱 모바일 브라우저 접속:
```
https://4000-i831dov1p3qmbwxmdvsyx-5634da27.sandbox.novita.ai
```

### 🎯 테스트 순서:
1. 스마트폰 Chrome/Safari에서 위 링크 접속
2. 로그인 (Google로 계속하기)
3. 채널 생성
4. **"알람 예약하기"** 클릭
5. 콘텐츠 선택 (음성/영상/링크)
6. 날짜 + 시간 선택
7. 예약 완료!
8. **예약 시간에 자동으로 전화 알람!** 📞

### ✅ 웹 버전의 장점:
- 즉시 테스트 (0초)
- 설치 불필요
- 모든 기능 동작
- 최신 버전 자동 반영

---

## 🎨 PWA로 앱처럼 사용하기

### Android:
1. Chrome에서 위 링크 접속
2. 메뉴 (⋮) → "홈 화면에 추가"
3. "설치" 클릭

### iOS:
1. Safari에서 위 링크 접속
2. 공유 버튼 → "홈 화면에 추가"
3. "추가" 클릭

**결과:** 앱처럼 사용 가능! 📱

---

## 🏆 추천 흐름

### 빠른 테스트 (추천):
```
1. 모바일 브라우저로 접속
   ↓
2. 모든 기능 테스트
   ↓
3. PWA로 홈 화면 추가
   ↓
4. 앱처럼 사용!
```

### 정식 APK 필요 시:
```
1. 소스 다운로드
   ↓
2. 로컬 환경 세팅
   ↓
3. flutter build apk
   ↓
4. APK 설치
```

---

## 🎯 결론

**즉시 테스트하려면:**
- **웹 버전** 사용 (추천!)
- URL: https://4000-i831dov1p3qmbwxmdvsyx-5634da27.sandbox.novita.ai

**정식 APK 필요하면:**
- 소스 다운로드 후 로컬 빌드
- ZIP: https://github.com/Stevewon/saytodo/raw/main/Channel-Alarm-Schedule-20260211_172350.zip

---

## 📞 핵심 기능 확인

### ✅ 예약 시스템:
- 콘텐츠 선택 (음성/영상/링크)
- 날짜 + 시간 선택
- 예약 목록 표시

### ✅ 자동 전화 알람:
- 예약 시간에 자동 실행
- 전체 화면 전환
- 맥박 + 진동 효과
- 수락/거절 버튼
- 음성/영상 자동 재생

---

**🚀 지금 바로 테스트하세요!**
```
https://4000-i831dov1p3qmbwxmdvsyx-5634da27.sandbox.novita.ai
```
