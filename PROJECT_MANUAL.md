# JUBU 프로젝트 매뉴얼 (초보자용)

이 문서는 **코드를 잘 몰라도** 앱이 무엇인지, 어디까지 만들어졌는지, **어떻게 눌러서 확인하는지** 안내합니다.

**중요**
- 화면 기준: **Android 폰 / 에뮬레이터** (`flutter run -d android`)
- 앱 안의 버튼·탭·안내 문구는 **영어**입니다. (이 매뉴얼만 한국어)
- Firebase 로그인/클라우드 저장은 **아직 없습니다.** 데이터는 앱 메모리(Mock)에만 있습니다.

---

## 1. 앱이 뭔가요?

**JUBU** 는 해외(특히 미국)에서 반찬·요리를 기록하고 나누는 Flutter 앱입니다.

지금 할 수 있는 것:
- Explore / Friends / My Log 피드에서 레시피 카드 보기
- 카드 눌러 상세 보기 (세로 스크롤)
- 단위 테스트 아이콘으로 g↔oz, ml↔cup 변환 확인
- **Start cooking mode** 로 단계별 요리 모드 + 타이머
- 요리 완료 후 **별점 대기(My Log)** → 상세에서 별점 제출
- 오른쪽 아래 **+** 로 새 레시피 / 요리 일지 작성 (갤러리 사진 포함)

아직 없는 것: Google 로그인, Firestore 저장, 팔로우 소셜, 인분 조절, 리믹스 UI

---

## 2. 앱 실행 방법

1. Cursor에서 `jubu` 폴더를 엽니다.
2. Android 에뮬레이터를 켜거나 폰을 USB로 연결합니다.
3. 터미널에서:

```bash
flutter run -d android
```

기기가 안 보이면 `flutter devices` 로 확인하세요.

성공 기준: 주황 AppBar에 **JUBU**, 아래 탭 **Explore | Friends | My Log**, 오른쪽 아래 **+** 버튼.

---

## 3. 화면별 테스트 가이드 (지금 구현된 것)

### 3.1 피드 (`RecipeFeedScreen`)

탭 3개 + FAB(+) 입니다.

| 탭 | 무엇을 보나요? |
|----|----------------|
| **Explore** | 전체 Mock 레시피 **2열 그리드** |
| **Friends** | 같은 데이터를 **넓은 카드 리스트** |
| **My Log** | `authorId == current_user_me` 인 **내 기록만** + (있으면) **Awaiting your rating** |

**카드에 보이는 것**
1. 사진  
2. 제목  
3. 별점 (이용자/완성도 점수)  
4. 태그(들) — 여러 개면 칩이 여러 개  
5. 만든 사람  
6. 만든 사람 칭호 (없으면 줄 없음)

카드를 누르면 **상세**로 이동합니다.  
사진이 회색+포크면 인터넷(Unsplash) 문제일 수 있습니다. 제목·별점은 보여야 합니다.

**Mock 샘플 (영문 UI 기준)**

| Title | Author | Title badge | Notes |
|-------|--------|-------------|--------|
| Spicy Braised Tofu | Chulmin | K-Banchan Craftsman | My Log에도 포함 (`current_user_me`) |
| Kimchi Bacon Pasta | Emily | Fusion Alchemist | |
| Beef Seaweed Soup | Alex | (없음) | |

---

### 3.2 상세 (`RecipeDetailScreen`)

피드 카드 → 상세.

**레이아웃:** 탭 없음. **한 화면 세로 스크롤**  
순서: 커버 사진 → 제목/시간/카테고리/작성자 → 요리 노트 카드(별·태그·메모) → **Ingredients** → **Steps** → (별점 대기일 때만) **Rate this cook**

**단위 변환 (테스트용)**
- AppBar 오른쪽 아이콘(시험관/자)을 누르면 Metric ↔ Imperial 전환
- 기본 Metric: `400 g`, `120 ml`
- Imperial: 약 `14.11 oz`, `0.5 cup`
- `tbsp` / `tsp` 는 그대로
- 변환은 항상 `UnitConverter` 통과

**Store tip:** 재료에 tip이 있으면 Ingredients 아래 노란 💡 박스 (substitutions 입력/표시는 **없음**)

**하단 고정 버튼:** **Start cooking mode**

---

### 3.3 요리 모드 (`CookingModeScreen`)

상세 → **Start cooking mode**

확인할 것:
- 제목 + `Step 1 / N`, 오른쪽 **Close (X)**
- 큰 글씨 지침 (`AppTextStyles.cookingMode`)
- 좌우 스와이프 또는 **Previous / Next**
- `timerMinutes` 있는 단계: 큰 `MM:SS` + **Start / Pause / Reset**
- 마지막 단계 **Done cooking** → 다이얼로그 → 상세로 복귀  
  동시에 My Log에 **Awaiting your rating** 이 쌓입니다.

타이머 있는 Mock 예: Spicy Braised Tofu step 3 (5분), Beef Seaweed Soup step 3 (20분)

---

### 3.4 별점 대기 → 제출

1. 아무 레시피로 Cooking Mode를 **Done cooking**까지 끝냅니다.
2. **My Log** 탭 → **Awaiting your rating** 목록 확인
3. 항목을 누르면 상세가 열리고, **맨 아래**에 별점 슬라이더 + **Submit rating**
4. 제출하면 대기 목록에서 사라지고 카드 별점이 갱신됩니다.

---

### 3.5 새 레시피 작성 (`CreateRecipeScreen`)

피드 **+** → **New recipe / cook log**

| 구역 | 입력 |
|------|------|
| Basics | Title, Description, Category(텍스트만), Cook time (minutes) |
| Cover photo | **Pick from gallery** (Android 앨범). 안 고르면 기본 Unsplash |
| Ingredients | Name / Amount / Unit. **Store tip** 은 fold(optional) |
| Steps | Instruction 필수. **Timer & photo (optional)** fold 안에 분·갤러리 사진 |
| Cook diary (optional) fold | Satisfaction 슬라이더, **Tags** (쉼표로 여러 개), Cook note |

**Save** 시:
- `authorId: current_user_me`, `authorName: Me`
- Mock 리스트 **맨 앞**에 추가
- 피드로 돌아오면 Explore / My Log에 새 카드가 보여야 함

재료 또는 단계가 비어 있으면 저장되지 않고 SnackBar가 뜹니다.

---

## 4. 구현 체크리스트 (현재)

- [x] 앱 실행 / JUBU AppBar
- [x] Explore / Friends / My Log 피드 + FAB(+)
- [x] 피드 카드: 사진·제목·별점·태그·작성자·칭호
- [x] 상세 세로 스크롤 + 단위 변환 테스트 아이콘
- [x] 요리 노트 카드 (별점·태그·메모)
- [x] Cooking Mode (PageView·타이머·Done cooking)
- [x] 별점 대기 큐 (My Log) + 상세에서 제출
- [x] CreateRecipeScreen (갤러리·다중 태그·fold 옵션)
- [ ] Google 로그인 / 온보딩
- [ ] Firestore 연동
- [ ] 인분(Servings) 조절
- [ ] 리믹스 UI
- [ ] 칭호 해금/장착 시스템

---

## 5. 코드 지도 (어디를 보면 되나요?)

```text
lib/
├── main.dart                          ← 앱 시작, RecipeFeedScreen
├── core/
│   ├── constants/app_colors.dart      ← 색
│   ├── constants/app_text_styles.dart ← 글자 스타일 (cookingMode 포함)
│   └── utils/unit_converter.dart      ← g/oz, ml/cup
└── features/
    ├── recipe/
    │   ├── models/recipe_model.dart
    │   ├── services/mock_recipe_service.dart
    │   │     getRecipes / getMyRecipes / addRecipe
    │   │     addPendingRating / getPendingRatings / submitPendingRating
    │   └── views/
    │         recipe_feed_screen.dart
    │         recipe_detail_screen.dart
    │         create_recipe_screen.dart
    ├── cooking_mode/views/cooking_mode_screen.dart
    └── auth/                          ← 아직 비어 있음
```

### 데이터 모델 요약 (`recipe_model.dart`)

- **Ingredient:** `name`, `amount`, `unit`, `storeTip?`  
  (`substitutions` 필드는 **제거됨**)
- **RecipeStep:** `stepNumber`, `instruction`, `timerMinutes?`, `imagePath?` (갤러리 로컬 경로)
- **RecipeModel:** `id`, `title`, `description`, `authorId`, `authorName`, `authorTitle?`, `imageUrl`, `category`, `cookingTimeMinutes`, `ingredients`, `steps`, `satisfactionScore` (기본 5.0), `recommendationTags` (리스트, 기본 `microwave only!`), `cookNote?`, `parentRecipeId?`, `remixCount`, `createdAt`

### 단위 변환 (`unit_converter.dart`)

| 방향 | 공식 |
|------|------|
| g → oz | ÷ 28.3495 |
| oz → g | × 28.3495 |
| ml → cup | ÷ 240.0 (미국 법정 cup) |
| cup → ml | × 240.0 |

`formatAmount`: 소수 최대 2자리, 끝 0 제거.

### 색 / 글자 바꾸기

- 색: `lib/core/constants/app_colors.dart` 의 `Color(0xFF......)`
- 글자: `lib/core/constants/app_text_styles.dart` (`title`, `subtitle`, `body`, `cookingMode` 등)

화면이 이미 이 상수를 쓰므로, 숫자만 바꾸고 앱을 다시 실행하면 반영됩니다.

---

## 6. 자주 보는 문제

| 증상 | 원인 / 대응 |
|------|-------------|
| 사진이 안 보임 | Unsplash 네트워크. 제목·텍스트는 보여야 정상 |
| 갤러리 선택 안 됨 | Android 사진 권한 허용. `image_picker` + Manifest 권한 필요 |
| 새 글이 My Log에 없음 | Save 시 author는 `Me` / `current_user_me` 여야 함 |
| `flutter test` 실패 | 예전 Hello World 테스트일 수 있음. 기능 확인은 `flutter run` 우선 |
| 분석기 `MyApp` 오류 | 앱 클래스는 `MainApp`. 옛 테스트 이름 불일치 |

작업 이력은 `CHANGELOG.md` (최신이 위)를 보세요. 제품/기술 전체 설계는 `PROJECT_SPEC.md` 입니다.
