#!/bin/bash

echo "🚀 시큐렛 메신저 APK 빌드 스크립트"
echo "===================================="
echo ""

# Java 버전 확인
echo "📋 Java 버전 확인 중..."
java -version

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F'.' '{print $1}')

if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 이상이 필요합니다. 현재 버전: $JAVA_VERSION"
    echo ""
    echo "Java 17 설치 방법:"
    echo "  Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "  macOS: brew install openjdk@17"
    echo "  Windows: https://adoptium.net/ 에서 다운로드"
    exit 1
fi

echo "✅ Java 버전 확인 완료"
echo ""

# 웹 빌드
echo "🔨 웹 애플리케이션 빌드 중..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ 웹 빌드 실패"
    exit 1
fi

echo "✅ 웹 빌드 완료"
echo ""

# Capacitor 동기화
echo "🔄 Capacitor 동기화 중..."
npx cap sync android

echo "✅ 동기화 완료"
echo ""

# APK 빌드
echo "📦 APK 빌드 중..."
cd android
./gradlew assembleDebug

if [ $? -ne 0 ]; then
    echo "❌ APK 빌드 실패"
    exit 1
fi

echo ""
echo "✅ APK 빌드 완료!"
echo ""
echo "📱 APK 위치:"
echo "   android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "🎉 빌드가 완료되었습니다!"
echo ""
echo "📲 설치 방법:"
echo "   1. APK 파일을 Android 기기로 전송"
echo "   2. 파일 관리자에서 APK 파일 탭하여 설치"
echo "   3. 또는 ADB 사용: adb install app-debug.apk"
echo ""
