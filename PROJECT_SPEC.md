# JUBU (주부) - Product & Architecture Specification

## 1. Executive Summary
- **Service Name:** JUBU (주부)
- **Core Value Proposition:** 미국 등 해외 거주자를 위한 직관적인 반찬/식단 고민 해결 및 로컬 식재료 기반 다문화 레시피 공유 & 개인 요리 다이어리 플랫폼
- **Target Audience:**
  - '오늘 무슨 반찬 해먹지?'를 매일 고민하는 1인 가구, 유학생, 다문화 가정
  - 자기가 만든 요리와 레시피, 실전 팁을 인스타그램처럼 기록하고 관리하려는 사용자
  - 한국 식재료를 현지 미국 마트(Trader Joe's, Stop & Shop 등)에서 대체해 요리하려는 사용자
  - 계량단위(Metric vs. Imperial) 차이로 요리에 어려움을 겪는 사용자

---

## 2. Core Functional Pillars

### A. User Profile & Unit Preference Engine
- **온보딩 가입 설정:** 가입 시 선호 도량형(Metric: g, ml vs. Imperial: oz, cups) 및 주식/선호 식단(Cuisines) 선택.
- **자동 단위 렌더링:** 상세 화면에서 매번 번거롭게 토글할 필요 없이, 유저 프로필 설정에 맞춰 UnitConverter가 모든 재료를 선호 단위로 자동 변환하여 출력.

### B. Personal Cook Log & Diary (인스타형 다이어리)
- **My Log (내 요리 일지):** 내가 직접 요리하고 기록한 레시피들을 캘린더/그리드 피드 형태로 아카이빙.
- **실전 요리 평가 메저 (Cook Measures):**
  - 요리 만족도/완성도 (Satisfaction Score, 5점 만점)
  - 작성자 실전 메모 (Cook Note: '간장을 반 스푼 줄일 것', '중불에서 2분 더 굽기' 등)
  - 독자가 별점 매길 수 있는 시스템 0개부터 0.5개씩 5개까지
  
### C. Recipe Creator & Swaps Input
- 단계별 조리법, 타이머 시간, 재료 수치 및 미국 현지 대체재(substitutions), 마트 코너 팁(storeTip) 등록 폼.

### D. Local Ingredient Swaps
- 현지 마트 대체재 정보 첨부 (예: 고춧가루 -> 카이엔 페퍼 + 파프리카 가루 / Trader Joe's Spice aisle).

### E. Hands-Free Cooking Mode
- 싱크대 거치 상태에서 멀리서도 잘 보이는 대형 폰트 UI, 스크롤 없는 단계별 페이지뷰(PageView) 슬라이드, 조리 시간 내장 타이머.

### F. Gamification & Title System (업적/칭호)
- 활동 기반 칭호 해금 (예: 'K-반찬 장인', '트레이더 조 개척자', '퓨전 연금술사') 및 대표 칭호 장착.

---

## 3. UI/UX Layout Architecture
- **Onboarding / Sign-Up Flow:**
  - Google Sign-In -> 기본 단위 선택 (Metric vs Imperial)
  - 선호 요리/식단 선택 (Korean, Fusion, Western, Quick Meal 등)
- **Main Feed (Triple Tab View):**
  - [Explore] (2열 그리드): 오늘 뭐 먹지? 비주얼 탐색
  - [Friends] (1열 카드): 팔로우한 친구들의 최신 요리 및 소셜 피드
  - [My Log] (인스타 프로필형 그리드): 내가 올린 요리 다이어리 & 통계
  - Floating Action Button: [+] 새 레시피 / 오늘 요리 기록 추가
- **Recipe Detail Screen:**
  - 유저 기본 단위 자동 변환 렌더링
  - 완성도(별점), 추천 태그, 실전 메모 카드
  - [요리 모드 시작] 버튼
- **Create Recipe / Cook Log Screen:**
  - 기본 정보, 재료 및 대체재 등록
  - 완성도 별점, 추천 태그, 실전 후기 메모 작성
- **Cooking Mode Screen:**
  - 풀스크린 대형 폰트 & 타이머

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
```

---

## 5. Domain Data Models (Dart)

### A. User Model (온보딩 및 단위 설정 반영)
```dart
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final bool preferImperial;
  final List<String> preferredCuisines;
  final String? equippedTitle;
  final List<String> unlockedTitles;
  final List<String> followingUids;

  UserModel({
    required this.uid;
    required this.displayName;
    required this.email;
    required this.photoUrl;
    this.preferImperial = false;
    this.preferredCuisines = const ['Korean'];
    this.equippedTitle;
    this.unlockedTitles = const [];
    this.followingUids = const [];
  });
}
```

### B. Recipe Model (요리 다이어리 & 평가 필드 반영)
```dart
class Ingredient {
  final String name;
  final double amount;
  final String unit;
  final List<String> substitutions;
  final String? storeTip;

  Ingredient({
    required this.name;
    required this.amount;
    required this.unit;
    this.substitutions = const [];
    this.storeTip;
  });
}

class RecipeStep {
  final int stepNumber;
  final String instruction;
  final int? timerMinutes;

  RecipeStep({
    required this.stepNumber;
    required this.instruction;
    this.timerMinutes;
  });
}

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String? authorTitle;
  final String imageUrl;
  final String category;
  final int cookingTimeMinutes;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final double satisfactionScore;
  final String recommendationTag;
  final String? cookNote;
  final String? parentRecipeId;
  final int remixCount;
  final DateTime createdAt;

  RecipeModel({
    required this.id;
    required this.title;
    required this.description;
    required this.authorId;
    required this.authorName;
    this.authorTitle;
    required this.imageUrl;
    required this.category;
    required this.cookingTimeMinutes;
    required this.ingredients;
    required this.steps;
    this.satisfactionScore = 5.0;
    this.recommendationTag = '친구들에게 추천!';
    this.cookNote;
    this.parentRecipeId;
    this.remixCount = 0;
    required this.createdAt;
  });
}
```

---

## 6. Implementation Roadmap
- **Phase 1-A (현재):** 뼈대 화면 UI & 더미 데이터 기반 완성 (Explore / Friends / My Log 3탭 피드, 사용자 설정 기반 자동 단위 변환 상세 화면)
- **Phase 1-B:** 요리 모드 & 레시피 작성 폼 UI (단계별 전체화면 요리 모드, 새 레시피 및 요리 기록 작성 화면 CreateRecipeScreen)
- **Phase 2:** 온보딩 및 Firebase 연동 (온보딩 화면, Google Auth, Firestore CRUD 연동)
- **Phase 3:** 소셜 및 칭호 시스템 (팔로우 기반 Friends 피드, 활동별 칭호 해금 및 장착)
- **Phase 4:** 리믹스 및 배포 최적화 (레시피 Fork 계보 관리, Cooking Mode 최적화)
