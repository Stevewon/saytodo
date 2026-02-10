#!/bin/bash

# SayToDo Firebase Setup - Interactive Guide
# Firebase 파일을 준비한 후 이 스크립트를 실행하세요

echo "🔥 SayToDo Firebase 설정 가이드"
echo "=================================="
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PROJECT_ROOT="/home/user/webapp"
BACKEND_DIR="$PROJECT_ROOT/voip-server"
ANDROID_DIR="$PROJECT_ROOT/SayToDo/android/app"
APP_TSX="$PROJECT_ROOT/SayToDo/App.tsx"

# 단계별 가이드
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📋 Firebase 설정이 필요한 파일들${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "다음 3개 파일이 필요합니다:"
echo ""
echo "1️⃣  firebase-service-account.json"
echo "   위치: $BACKEND_DIR/"
echo "   용도: Backend FCM Push 발송"
echo ""
echo "2️⃣  google-services.json"
echo "   위치: $ANDROID_DIR/"
echo "   용도: Android FCM 수신"
echo ""
echo "3️⃣  Web Client ID"
echo "   위치: $APP_TSX"
echo "   용도: Google Sign-In"
echo ""

# Step 1: firebase-service-account.json
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📱 Step 1: firebase-service-account.json${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -f "$BACKEND_DIR/firebase-service-account.json" ]; then
    echo -e "${GREEN}✅ 파일이 존재합니다!${NC}"
    echo "   위치: $BACKEND_DIR/firebase-service-account.json"
    
    # 파일 내용 검증
    if grep -q "project_id" "$BACKEND_DIR/firebase-service-account.json"; then
        PROJECT_ID=$(grep -o '"project_id": "[^"]*' "$BACKEND_DIR/firebase-service-account.json" | cut -d'"' -f4)
        echo -e "${GREEN}   Project ID: $PROJECT_ID${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  파일이 없습니다${NC}"
    echo ""
    echo "Firebase Console에서 다운로드하는 방법:"
    echo ""
    echo "1. https://console.firebase.google.com 접속"
    echo "2. 프로젝트 선택"
    echo "3. ⚙️ 프로젝트 설정 클릭"
    echo "4. '서비스 계정' 탭"
    echo "5. '새 비공개 키 생성' 버튼 클릭"
    echo "6. JSON 파일 다운로드"
    echo ""
    echo "다운로드 후:"
    echo "  cp ~/Downloads/YOUR-PROJECT-firebase-adminsdk-xxxxx.json \\"
    echo "     $BACKEND_DIR/firebase-service-account.json"
    echo ""
fi

# Step 2: google-services.json
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📲 Step 2: google-services.json${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -f "$ANDROID_DIR/google-services.json" ]; then
    echo -e "${GREEN}✅ 파일이 존재합니다!${NC}"
    echo "   위치: $ANDROID_DIR/google-services.json"
    
    # 패키지 이름 검증
    if grep -q "com.saytodo" "$ANDROID_DIR/google-services.json"; then
        echo -e "${GREEN}   Package: com.saytodo ✓${NC}"
    else
        echo -e "${YELLOW}   ⚠️  패키지 이름을 확인하세요${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  파일이 없습니다${NC}"
    echo ""
    echo "Firebase Console에서 다운로드하는 방법:"
    echo ""
    echo "1. https://console.firebase.google.com 접속"
    echo "2. 프로젝트 선택"
    echo "3. ⚙️ 프로젝트 설정 클릭"
    echo "4. '일반' 탭"
    echo "5. '내 앱' 섹션에서 Android 앱 찾기"
    echo "6. 'google-services.json' 다운로드 버튼 클릭"
    echo ""
    echo "다운로드 후:"
    echo "  cp ~/Downloads/google-services.json \\"
    echo "     $ANDROID_DIR/"
    echo ""
fi

# Step 3: Web Client ID
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔑 Step 3: Web Client ID${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if grep -q "YOUR_WEB_CLIENT_ID" "$APP_TSX"; then
    echo -e "${YELLOW}⚠️  Web Client ID가 설정되지 않았습니다${NC}"
    echo ""
    echo "Firebase Console에서 확인하는 방법:"
    echo ""
    echo "1. https://console.firebase.google.com 접속"
    echo "2. 프로젝트 선택"
    echo "3. ⚙️ 프로젝트 설정 클릭"
    echo "4. '일반' 탭"
    echo "5. 아래로 스크롤하여 '웹 API 키' 또는 '웹 클라이언트 ID' 확인"
    echo "   형식: xxxxx.apps.googleusercontent.com"
    echo ""
    echo "설정 방법:"
    echo "  nano $APP_TSX"
    echo ""
    echo "  다음 줄을 찾아서:"
    echo "  const GOOGLE_WEB_CLIENT_ID = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';"
    echo ""
    echo "  실제 값으로 변경:"
    echo "  const GOOGLE_WEB_CLIENT_ID = '123456789012-abcd...xyz.apps.googleusercontent.com';"
    echo ""
else
    echo -e "${GREEN}✅ Web Client ID가 설정되어 있습니다${NC}"
    WEB_CLIENT_ID=$(grep "GOOGLE_WEB_CLIENT_ID" "$APP_TSX" | grep -o "'[^']*'" | head -1 | tr -d "'")
    echo "   값: $WEB_CLIENT_ID"
fi

# Step 4: SHA-1 인증서
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔐 Step 4: SHA-1 인증서 등록${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "SHA-1 인증서를 Firebase에 등록해야 합니다."
echo ""
echo "SHA-1 확인 방법:"
echo "  cd $PROJECT_ROOT/SayToDo/android"
echo "  ./gradlew signingReport | grep SHA1"
echo ""
echo "출력 예시:"
echo "  SHA1: AA:BB:CC:DD:EE:FF:11:22:33:44:55:66:77:88:99:00:AA:BB:CC:DD"
echo ""
echo "Firebase Console에 등록:"
echo "1. https://console.firebase.google.com 접속"
echo "2. 프로젝트 설정 → 일반 탭"
echo "3. 내 앱 → SayToDo (Android)"
echo "4. 'SHA 인증서 지문' 섹션"
echo "5. '지문 추가' 버튼 클릭"
echo "6. SHA-1 값 붙여넣기 → 저장"
echo ""

# 최종 상태 확인
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 설정 상태 확인${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

COMPLETE=0
TOTAL=3

# Backend Firebase
if [ -f "$BACKEND_DIR/firebase-service-account.json" ]; then
    echo -e "${GREEN}✅ Backend Firebase 설정 완료${NC}"
    COMPLETE=$((COMPLETE+1))
else
    echo -e "${RED}❌ Backend Firebase 설정 필요${NC}"
fi

# Android Firebase
if [ -f "$ANDROID_DIR/google-services.json" ]; then
    echo -e "${GREEN}✅ Android Firebase 설정 완료${NC}"
    COMPLETE=$((COMPLETE+1))
else
    echo -e "${RED}❌ Android Firebase 설정 필요${NC}"
fi

# Web Client ID
if ! grep -q "YOUR_WEB_CLIENT_ID" "$APP_TSX"; then
    echo -e "${GREEN}✅ Google Sign-In 설정 완료${NC}"
    COMPLETE=$((COMPLETE+1))
else
    echo -e "${RED}❌ Google Sign-In 설정 필요${NC}"
fi

echo ""
echo -e "진행률: ${BLUE}$COMPLETE/$TOTAL${NC} ($(( COMPLETE * 100 / TOTAL ))%)"
echo ""

if [ $COMPLETE -eq $TOTAL ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 모든 Firebase 설정이 완료되었습니다!${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "다음 단계:"
    echo ""
    echo "1️⃣  Backend 실행:"
    echo "   cd $BACKEND_DIR"
    echo "   npm install"
    echo "   npm start"
    echo ""
    echo "2️⃣  Android 앱 실행:"
    echo "   cd $PROJECT_ROOT/SayToDo"
    echo "   npm install"
    echo "   npm run android"
    echo ""
else
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠️  아직 $((TOTAL - COMPLETE))개의 설정이 필요합니다${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "상세 가이드:"
    echo "  cat $PROJECT_ROOT/FIREBASE_QUICK_START.md"
    echo ""
    echo "또는:"
    echo "  cat $PROJECT_ROOT/FIREBASE_SETUP_GUIDE.md"
    echo ""
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📚 도움말 문서${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "빠른 시작: FIREBASE_QUICK_START.md"
echo "상세 가이드: FIREBASE_SETUP_GUIDE.md"
echo "프로젝트 요약: SAYTODO_SUMMARY.md"
echo "최종 상태: FINAL_STATUS.md"
echo ""
