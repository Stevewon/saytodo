# 시큐렛 메신저 - 안드로이드 APK 빌드 가이드

## 📱 모바일 앱 빌드 완료!

Capacitor를 사용하여 웹앱을 안드로이드 앱으로 변환했습니다.

## 🛠 사전 준비 (로컬 환경)

### 1. Android Studio 설치
- https://developer.android.com/studio 에서 다운로드
- Android SDK 설치
- Java JDK 17 이상 설치

### 2. 환경 변수 설정
```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## 📦 APK 빌드 방법

### 방법 1: Android Studio 사용 (권장)

1. **Android Studio에서 프로젝트 열기**
```bash
cd /home/user/webapp
npx cap open android
```

2. **Gradle Sync 완료 대기**
   - Android Studio가 자동으로 의존성 다운로드

3. **APK 빌드**
   - `Build` → `Build Bundle(s) / APK(s)` → `Build APK(s)`
   - 또는 메뉴에서 `Build` → `Generate Signed Bundle / APK`

4. **APK 위치**
   - Debug APK: `android/app/build/outputs/apk/debug/app-debug.apk`
   - Release APK: `android/app/build/outputs/apk/release/app-release.apk`

### 방법 2: 커맨드 라인 사용

#### Debug APK 빌드
```bash
cd /home/user/webapp/android
./gradlew assembleDebug
```

출력: `android/app/build/outputs/apk/debug/app-debug.apk`

#### Release APK 빌드 (서명 필요)
```bash
cd /home/user/webapp/android
./gradlew assembleRelease
```

## 🔐 서명된 Release APK 만들기

### 1. Keystore 생성
```bash
keytool -genkey -v -keystore securet-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias securet-key
```

### 2. Gradle 설정 추가

`android/app/build.gradle` 파일 수정:

```gradle
android {
    ...
    signingConfigs {
        release {
            storeFile file('securet-release-key.jks')
            storePassword 'your-store-password'
            keyAlias 'securet-key'
            keyPassword 'your-key-password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. Release APK 빌드
```bash
cd /home/user/webapp/android
./gradlew assembleRelease
```

## 📲 APK 설치 방법

### Android 기기에 설치

1. **개발자 옵션 활성화**
   - 설정 → 휴대전화 정보 → 빌드 번호를 7번 탭

2. **USB 디버깅 허용**
   - 설정 → 개발자 옵션 → USB 디버깅 활성화

3. **APK 설치**
```bash
# USB 연결 후
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

또는 APK 파일을 직접 기기로 전송하여 설치

## 🔄 코드 업데이트 후 재빌드

```bash
# 1. 웹 빌드
npm run build

# 2. Capacitor 동기화
npx cap sync android

# 3. APK 재빌드
cd android && ./gradlew assembleDebug
```

## 📋 현재 설정

### 앱 정보
- **앱 이름**: Securet Messenger
- **패키지명**: com.securet.messenger
- **서버 URL**: https://3001-i9hxkysto1zzwy5b3ntbw-2e77fc33.sandbox.novita.ai

### 권한
- ✅ 인터넷 (필수)
- ✅ 카메라 (QR 스캔)
- ✅ 파일 읽기/쓰기
- ✅ 푸시 알림
- ✅ 오디오 녹음 (음성통화)

### 기능
- ✅ QR 코드 스캔
- ✅ 실시간 채팅
- ✅ 파일 공유
- ✅ 푸시 알림 준비
- 🔄 음성/영상 통화 (개발 중)

## 🚀 Google Play Store 배포

### 1. 서명된 AAB 생성
```bash
cd android
./gradlew bundleRelease
```

### 2. Google Play Console
1. https://play.google.com/console 접속
2. 앱 생성
3. AAB 파일 업로드: `android/app/build/outputs/bundle/release/app-release.aab`
4. 스토어 등록 정보 입력
5. 심사 제출

## 📝 주의사항

### 프로덕션 배포 전 체크리스트
- [ ] 서버 URL을 실제 프로덕션 URL로 변경 (`.env.production`)
- [ ] Keystore 안전하게 보관
- [ ] 앱 버전 업데이트 (`android/app/build.gradle`)
- [ ] 아이콘 교체 (`android/app/src/main/res/mipmap-*/`)
- [ ] 스플래시 화면 커스터마이징
- [ ] ProGuard 설정 (난독화)
- [ ] 보안 검토
- [ ] 테스트 완료

## 🎨 앱 아이콘 교체

아이콘 파일 위치:
```
android/app/src/main/res/
├── mipmap-hdpi/
├── mipmap-mdpi/
├── mipmap-xhdpi/
├── mipmap-xxhdpi/
└── mipmap-xxxhdpi/
```

각 폴더에 `ic_launcher.png`와 `ic_launcher_round.png` 교체

## 🔧 문제 해결

### Gradle 빌드 실패
```bash
cd android
./gradlew clean
./gradlew assembleDebug --stacktrace
```

### Capacitor 동기화 문제
```bash
npx cap sync android --force
```

### 의존성 문제
```bash
cd android
./gradlew --refresh-dependencies
```

## 📞 지원

- Capacitor 문서: https://capacitorjs.com/docs
- Android 개발자 가이드: https://developer.android.com

---

**이제 모바일 앱으로 시큐렛 메신저를 사용할 수 있습니다!** 📱✨
