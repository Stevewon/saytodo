# 🚀 SayToDo APK 즉시 다운로드 가이드

## ⚡ **가장 빠른 방법: Expo EAS Build (5분)**

GitHub Actions는 권한 문제로 사용할 수 없어, **Expo EAS Build**를 사용합니다!

---

## 📦 **1단계: 소스 코드 다운로드**

```
https://github.com/Stevewon/saytodo/archive/refs/heads/main.zip
```

---

## 🛠️ **2단계: APK 빌드 (PC에서 실행)**

### Windows:
```cmd
# ZIP 압축 해제 후
cd saytodo-main\SayToDo

# 의존성 설치
npm install

# EAS CLI 설치 (관리자 권한 필요)
npm install -g eas-cli

# Expo 로그인
eas login

# APK 빌드 시작!
eas build -p android --profile preview
```

### Mac/Linux:
```bash
# ZIP 압축 해제 후
cd saytodo-main/SayToDo

# 의존성 설치
npm install

# EAS CLI 설치
sudo npm install -g eas-cli

# Expo 로그인
eas login

# APK 빌드 시작!
eas build -p android --profile preview
```

---

## 📱 **3단계: APK 다운로드 (5-10분 후)**

빌드가 완료되면 터미널에 다음과 같은 메시지가 표시됩니다:

```
✅ Build finished

📱 https://expo.dev/accounts/stevewon/builds/abc123-def456-ghi789

Download the artifact with:
  eas build:download --id abc123-def456-ghi789
```

**이 링크를 모바일 브라우저에서 열면 APK를 바로 다운로드할 수 있습니다!**

---

## 🎯 **4단계: 모바일 설치**

1. 위 링크를 모바일 브라우저에서 열기
2. **Download artifact** 클릭
3. `SayToDo.apk` 다운로드
4. 설정 → 보안 → "출처 모르는 앱 허용" 활성화
5. APK 파일 클릭해서 설치
6. SayToDo 앱 실행! 🎉

---

## 💡 **EAS Build 장점**

- ✅ **5-10분** 안에 APK 생성
- ✅ **무료** (월 30회 빌드 제공)
- ✅ **클라우드 빌드** (PC 사양 무관)
- ✅ **자동 서명** (Release APK 생성)
- ✅ **직접 다운로드** (모바일에서 바로 설치)

---

## 🔧 **로컬 빌드 (대안)**

PC에 JDK 17 + Android SDK가 있다면:

```bash
cd saytodo-main/SayToDo
npm install
cd android
./gradlew assembleRelease
```

APK 위치: `android/app/build/outputs/apk/release/app-release.apk`

---

## 📞 **문제 발생 시**

### EAS 로그인 안 됨
```bash
eas login
# 이메일/비밀번호 입력
# 또는 GitHub 계정으로 로그인
```

### 빌드 실패
```bash
# 로그 확인
eas build:list
eas build:view [BUILD_ID]
```

### APK 다운로드 링크 다시 보기
```bash
eas build:list
# 최근 빌드 목록에서 링크 확인
```

---

## 🎯 **요약**

1. ✅ **소스 다운로드**: https://github.com/Stevewon/saytodo/archive/refs/heads/main.zip
2. ✅ **빌드 명령어**: `cd SayToDo && npm install && eas build -p android --profile preview`
3. ✅ **5분 대기**: 빌드 완료 대기
4. ✅ **APK 다운로드**: 터미널에 표시된 링크를 모바일에서 열기
5. ✅ **즉시 테스트**: 설치 후 바로 사용!

---

**지금 바로 시작하세요!** 5분 후면 모바일에서 테스트할 수 있습니다! 🚀
