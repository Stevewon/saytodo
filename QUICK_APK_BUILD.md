# ⚡ APK 빌드 - 초간단 가이드

## 🎯 목표
모바일에서 바로 테스트할 수 있는 APK 파일 다운로드!

---

## 📦 방법 1: Expo EAS Build (가장 빠름!)

### PC에서 실행:
```bash
# 1. 소스 다운로드 & 압축 해제
# https://github.com/Stevewon/saytodo/archive/refs/heads/main.zip

# 2. 빌드 실행
cd saytodo-main/SayToDo
npm install
npm install -g eas-cli
eas login
eas build -p android --profile preview
```

### 5분 후:
- 터미널에 APK 다운로드 링크 표시
- 모바일에서 링크 열기
- APK 다운로드 & 설치
- 테스트 시작! 🎉

---

## 📦 방법 2: 로컬 빌드 (JDK 17 필요)

```bash
cd saytodo-main/SayToDo
npm install
cd android
./gradlew assembleRelease
```

APK: `app/build/outputs/apk/release/app-release.apk`

---

## 🔗 링크

- **소스 다운로드**: https://github.com/Stevewon/saytodo/archive/refs/heads/main.zip
- **저장소**: https://github.com/Stevewon/saytodo
- **Expo 가입**: https://expo.dev/signup

---

## 💡 팁

- EAS Build: 무료 (월 30회)
- 빌드 시간: 5-10분
- APK 크기: 30-50 MB
- 설치 시 "출처 모르는 앱" 허용 필요

---

**지금 바로 시작!** 5분이면 충분합니다! 🚀
