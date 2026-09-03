# JUBU (주부) - Product & Architecture Specification

## 1. Executive Summary
- **Service Name:** JUBU (주부)
- **Core Value Proposition:** 미국 등 해외 거주자를 위한 직관적인 반찬/식단 고민 해결 및 로컬 식재료 기반 다문화 레시피 공유 플랫폼
- **Target Audience:** 
  - "오늘 무슨 반찬 해먹지?"를 매일 고민하는 1인 가구, 유학생, 다문화 가정
  - 한국 식재료를 현지 미국 마트(Trader Joe's, Stop & Shop 등)에서 대체해 요리하려는 사용자
  - 계량단위(Metric vs. Imperial) 차이로 요리에 어려움을 겪는 사용자

---

## 2. Core Functional Pillars

### A. Dynamic Unit & Serving Engine
- **원터치 도량형 토글:** Metric(g, ml) <-> Imperial(oz, cups, tbsp) 실시간 변환
- **인분(Servings) 비례 계산기:** 인분 수 증감(2 -> 4) 시 모든 재료량 실시간 재계산

### B. Local Ingredient Swaps
- 레시피 등록 시 재료별 현지 마트 대체재 정보 첨부 (예: 고춧가루 -> 카이엔 페퍼 + 파프리카 가루)
- 현지 마트 코너 정보 명시 (예: Trader Joe's Spice aisle)

### C. Hands-Free Cooking Mode
- 싱크대 거치 상태에서 멀리서도 잘 보이는 대형 폰트 UI
- 스크롤 없는 단계별 페이지뷰(PageView) 슬라이드
- 조리 시간 원터치 타이머 및 화면 꺼짐 방지(Wakelock)

### D. Recipe Remix (Forking System)
- 기존 레시피를 기반으로 한 로컬 대체 버전 / 식단 맞춤형(비건, 글루텐프리) 파생 레시피 등록
- 원작자 링크 및 레시피 계보(Fork tree) 자동 보존

### E. Gamification & Title System (업적/칭호)
- 활동 기반 칭호 해금 (예: 'K-반찬 장인', '트레이더 조 개척자', '퓨전 연금술사')
- 유저가 획득한 대표 칭호를 닉네임 옆에 장착하여 피드 및 댓글에 노출

---

## 3. UI/UX Layout Architecture
- **Main Feed (Dual Tab View):**
  - Explore Tab (2-Column Grid): 시각적 랜덤 탐색 ("오늘 뭐 먹지?")
  - Friends Tab (1-Column Card): 팔로우한 지인들의 레시피 및 소셜 코멘트
- **Recipe Detail Screen (Sliver Layout):**
  - Metric/Imperial 단위 토글 & Servings 증감 버튼
  - 로컬 마트 대체 식재료 강조 박스
  - 하단 고정 액션 바: [Start Cooking Mode] / [Remix Recipe]
- **Cooking Mode Screen (Full-screen PageView):**
  - 대형 텍스트 단계별 안내 & 내장 타이머

---

## 4. Technical Architecture
- **Framework:** Flutter (Android, iOS, Web)
- **Language:** Dart
- **State Management:** Provider
- **Backend:** Firebase (jubu-9d725)
- **Architecture Pattern:** Feature-First

### Directory Structure
```text
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── recipe/
│   ├── cooking_mode/
│   └── remix/
├── firebase_options.dart
└── main.dart

## 5. Implementation Roadmap
Phase 1: Feature-First 폴더 구축, 단위 변환 유틸, 목데이터(Mock Data) 기반 화면 UI 구현

Phase 2: Firebase Auth(Google Sign-in) 및 Firestore CRUD 연동

Phase 3: 칭호 시스템(달성 조건 체크 로직) 및 소셜 팔로우 기능 탑재

Phase 4: 레시피 리믹스(Fork) 기능 및 요리 모드 최적화
