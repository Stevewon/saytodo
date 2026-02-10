# 📱 SayToDo APK 빌드 가이드

## ⚠️ 현재 상황

샌드박스 환경의 Java 버전(11)과 Gradle 요구사항(Java 17) 불일치로 인해
직접 APK 빌드가 제한됩니다.

## 🎯 해결 방법

### 방법 1: 로컬 개발 환경에서 빌드 (권장)

#### 사전 요구사항
- Node.js 18 이상
- JDK 17 이상
- Android Studio 또는 Android SDK

#### 빌드 단계

```bash
# 1. 소스 코드 백업 파일 압축 해제
tar -xzf saytodo_source_20260210_214412.tar.gz
cd webapp/SayToDo

# 2. 의존성 설치
npm install

# 3. Android 디렉토리로 이동
cd android

# 4. APK 빌드
./gradlew assembleRelease

# 5. APK 위치
# android/app/build/outputs/apk/release/app-release.apk
```

#### APK 파일 위치
빌드 완료 후 APK 파일은 다음 위치에 생성됩니다:
```
SayToDo/android/app/build/outputs/apk/release/app-release.apk
```

---

### 방법 2: GitHub Actions 자동 빌드 (추천)

프로젝트에 GitHub Actions 워크플로우가 이미 설정되어 있습니다.

#### 단계

1. **GitHub에 프로젝트 푸시**
   ```bash
   cd /home/user/webapp
   git remote add origin https://github.com/YOUR_USERNAME/saytodo.git
   git push -u origin main
   ```

2. **Secrets 설정**
   - GitHub Repository → Settings → Secrets and variables → Actions
   - 다음 Secrets 추가:
     - `FIREBASE_SERVICE_ACCOUNT`: firebase-service-account.json 내용
     - `GOOGLE_SERVICES_JSON`: google-services.json 내용

3. **워크플로우 트리거**
   - GitHub Actions 탭으로 이동
   - "Build Android APK" 워크플로우 실행
   - 또는 새 커밋 푸시 시 자동 빌드

4. **APK 다운로드**
   - 워크플로우 완료 후 Artifacts에서 APK 다운로드

---

### 방법 3: Expo EAS Build (온라인 빌드)

React Native CLI 대신 Expo를 사용하여 클라우드에서 빌드할 수 있습니다.

#### 단계

1. **Expo 설치**
   ```bash
   npm install -g eas-cli
   eas login
   ```

2. **프로젝트 설정**
   ```bash
   cd SayToDo
   eas build:configure
   ```

3. **APK 빌드**
   ```bash
   eas build -p android --profile preview
   ```

4. **APK 다운로드**
   빌드 완료 후 제공되는 링크에서 APK 다운로드

---

## 📦 빌드 파일 정보

### 필요한 파일 (이미 설정됨)
```
✅ SayToDo/android/app/google-services.json
✅ SayToDo/App.tsx (Web Client ID 설정)
✅ AndroidManifest.xml (권한 및 인텐트 필터)
✅ build.gradle (의존성)
```

### Firebase 설정 완료
```
✅ Project ID: saytodo-3bbc6
✅ Package: com.saytodo
✅ Web Client ID: 1068989331005-3k2i2btovivbnquol72s1r8mu3kum5if.apps.googleusercontent.com
```

---

## 🚀 빠른 시작 (로컬 환경)

로컬에서 빠르게 빌드하려면:

```bash
# 소스 코드 압축 해제
tar -xzf saytodo_source_20260210_214412.tar.gz

# 의존성 설치
cd webapp/SayToDo
npm install

# APK 빌드
cd android
chmod +x gradlew
./gradlew assembleRelease

# APK 위치
ls -lh app/build/outputs/apk/release/app-release.apk
```

---

## 📱 APK 설치 방법

### Android 기기에 설치

1. **APK 파일 전송**
   - 이메일
   - USB 케이블
   - Google Drive
   - Dropbox
   - 기타 파일 공유 방법

2. **설치 허용**
   - 설정 → 보안
   - "알 수 없는 출처" 허용
   - 또는 "이 출처 허용" (Android 8.0 이상)

3. **APK 실행**
   - 파일 관리자에서 APK 파일 터치
   - "설치" 버튼 클릭

4. **앱 실행**
   - 설치 완료 후 "열기" 버튼 클릭
   - 또는 앱 서랍에서 "SayToDo" 아이콘 찾기

---

## 🔧 문제 해결

### Java 버전 문제
```bash
# Java 17 설치 (Ubuntu/Debian)
sudo apt-get install openjdk-17-jdk

# JAVA_HOME 설정
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# 확인
java -version  # 17.x.x 출력되어야 함
```

### Gradle 캐시 문제
```bash
cd android
./gradlew clean
rm -rf ~/.gradle/caches
./gradlew assembleRelease
```

### 메모리 부족
```bash
# gradle.properties에 추가
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
```

---

## 📊 예상 APK 크기

- **Debug APK**: ~50-80MB
- **Release APK**: ~30-50MB (압축 및 최적화)
- **Split APK**: ~20-30MB (아키텍처별 분리)

---

## 🎯 다음 단계

### APK 빌드 후
1. ✅ 모바일 기기에 설치
2. ✅ Google 로그인 테스트
3. ✅ 채널 생성 테스트
4. ✅ 초대 링크 공유 테스트
5. ✅ 긴급 알림 발송 테스트

### Google Play 배포 (선택)
1. Google Play Console 등록
2. Release 키스토어 생성
3. 앱 서명 설정
4. 스토어 리스팅 작성
5. 앱 제출 및 심사

---

## 📚 관련 문서

- **FIREBASE_SUCCESS.md** - Firebase 설정 완료
- **SAYTODO_SUMMARY.md** - 프로젝트 요약
- **BACKUP_README.md** - 백업 파일 가이드
- **README.md** - 메인 README

---

## 💡 팁

### APK 크기 줄이기
```gradle
// android/app/build.gradle
android {
    splits {
        abi {
            enable true
            reset()
            include 'armeabi-v7a', 'arm64-v8a'
            universalApk false
        }
    }
}
```

### 난독화 활성화
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

---

**프로젝트:** SayToDo  
**버전:** 1.0.0  
**상태:** 빌드 준비 완료  
**마지막 업데이트:** 2026-02-10

---

**🎊 축하합니다!**  
모든 소스 코드와 설정이 완료되었습니다!  
로컬 환경에서 빌드하거나 GitHub Actions를 사용하세요!

