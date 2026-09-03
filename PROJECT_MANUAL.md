# JUBU 프로젝트 매뉴얼 (초보자용)

이 문서는 **코드를 잘 몰라도** 앱이 무엇인지, 무엇을 확인하면 되는지 안내합니다.  
기능이 추가될 때마다 아래 목차에 테스트 방법이 채워집니다.

**화면 기준:** 지금은 **Android 폰/에뮬레이터** 기준으로 레이아웃을 맞춥니다. Chrome(웹)으로 확인하지 않아도 됩니다.

---

## 1. 앱이 뭔가요?

**JUBU(주부)** 는 해외(특히 미국)에서 사는 사람을 위한 **반찬/레시피** 앱입니다.

- 오늘 뭐 해먹지 고민할 때 레시피를 찾아봅니다.
- 그램(g) ↔ 온스/컵 같은 **단위**를 쉽게 바꿉니다.
- 한국 재료를 **현지 마트 대체재**로 바꿔 볼 수 있게 하려는 앱입니다.

지금은 Flutter로 만든 **초기 프로젝트** 단계입니다. 화면 기능은 아직 거의 없고, 앞으로 하나씩 붙입니다.

---

## 2. 이 폴더에서 중요한 파일

| 파일 | 무엇을 위한 파일인가요? |
|------|-------------------------|
| `PROJECT_MANUAL.md` | 지금 읽고 있는 문서. **어떻게 테스트할지** 적어 둡니다. |
| `CHANGELOG.md` | **언제, 무엇을 바꿨는지** 기록합니다. |
| `PROJECT_SPEC.md` | 제품/기술 설계서 (기능 목록이 자세히 적혀 있음). |
| `lib/main.dart` | 앱이 시작되는 Dart 파일. |
| `pubspec.yaml` | 앱 이름과 사용하는 패키지 목록. |
| `lib/core/constants/app_colors.dart` | 앱 전체에서 쓰는 **색상 이름표**. |
| `lib/core/constants/app_text_styles.dart` | 제목/본문/요리 모드용 **글자 크기·굵기**. |
| `lib/features/recipe/models/recipe_model.dart` | 레시피 한 건을 담는 **데이터 설계도** (화면 없음). |
| `lib/core/utils/unit_converter.dart` | g↔oz, ml↔cup **숫자 계산기** (화면 없음). |
| `lib/features/recipe/services/mock_recipe_service.dart` | 화면 만들기 전에 쓰는 **가짜 레시피 3개**. |
| `lib/features/recipe/views/recipe_feed_screen.dart` | 메인 피드 (Explore / Friends / My Log). |
| `lib/features/recipe/views/create_recipe_screen.dart` | 새 레시피·요리 일지 **작성 폼**. |

---

## 3. 폴더가 왜 이렇게 나뉘어 있나요? (Feature-First)

기능을 종류별로 나눠 두는 방식입니다. **공통 색/글꼴 + 레시피 데이터 설계도**까지 있습니다. 화면은 아직 없습니다.

```text
lib/
├── core/                 ← 여러 화면이 같이 쓰는 공통 것
│   ├── constants/        ← 색상, 글자 스타일 (여기 파일이 있음)
│   ├── utils/            ← 단위 변환 (`unit_converter.dart`)
│   └── widgets/          ← 나중에 여러 화면에서 재사용할 작은 UI
├── features/             ← 기능별 방
│   ├── auth/             ← 로그인
│   ├── recipe/           ← 레시피 (지금은 models만 있음)
│   └── cooking_mode/     ← 요리 모드
└── main.dart
```

빈 폴더 안의 `.gitkeep` 은 “이 폴더를 git에 남기기 위한 표시”일 뿐, 앱 동작과는 관계 없습니다.

### 색이나 글꼴을 바꾸고 싶을 때 (초보자용)

화면을 아직 만들지 않아서 **앱을 실행해도 새 색이 바로 보이지는 않습니다.**  
나중에 화면이 이 파일을 가져다 쓰면, **한 곳만 고치면 전체가 바뀝니다.**

1. **주황/초록/카드 배경/대체재 강조색을 바꾸려면**  
   `lib/core/constants/app_colors.dart` 를 엽니다.  
   이름 옆의 `Color(0xFF......)` 숫자만 바꾸면 됩니다.  
   - `primary` — 버튼·브랜드 주황 (식욕을 돋우는 웜 오렌지)  
   - `secondary` — 보조 초록  
   - `cardBackground` / `background` — 카드·화면 배경의 뉴트럴 톤  
   - `swapHighlight` / `swapHighlightLight` — 대체 식재료를 눈에 띄게 하는 앰버(노란 톤)

2. **글자를 더 크게/굵게 하려면**  
   `lib/core/constants/app_text_styles.dart` 를 엽니다.  
   - `title` — 큰 제목  
   - `subtitle` — 작은 제목  
   - `body` / `bodySmall` — 본문  
   - `cookingMode` — 멀리서도 보이게 한 **요리 모드용 대형 글자** (`fontSize: 32`)

3. 저장한 뒤, 나중에 화면이 연결되면 앱을 다시 실행(`flutter run`)해서 확인합니다.

4. **Step 1 확인:** 위 두 테마 파일과 `lib/features/` 아래 `auth`, `recipe`, `cooking_mode` 폴더가 있으면 됩니다.

---

## 3.1 레시피 데이터 모델이 뭔가요? (Step 2)

앱 화면이 아니라 **한 장의 레시피를 컴퓨터가 기억하는 칸**입니다.  
엑셀 표의 열 이름이라고 생각하면 됩니다. 파일 위치:

`lib/features/recipe/models/recipe_model.dart`

이 파일에는 클래스(설계도)가 **3개** 있습니다.

### Ingredient (재료 한 줄)

레시피 재료 목록의 **한 칸**입니다.

- `name` — 재료 이름 (예: 고춧가루)
- `amount` — 숫자 양 (예: 10)
- `unit` — 단위 글자 (`g`, `ml`, `oz`, `tbsp`, `cup` 같은 것)
- `substitutions` — **현지에서 바꿔 쓸 수 있는 재료 이름 목록**  
  예: 고춧가루를 미국 마트에서 구하기 어려우면 `["cayenne pepper", "paprika"]`  
  나중에 노란(앰버) 박스로 “이걸로 바꿔도 돼요”라고 보여줄 칸입니다.
- `storeTip` — 없어도 됨. 있으면 **어느 마트 어느 코너**인지 (예: Trader Joe's spice aisle)

### RecipeStep (요리 순서 한 장)

요리 모드에서 **한 단계**입니다.

- `stepNumber` — 몇 번째 단계인지 (1, 2, 3…)
- `instruction` — 무엇을 하라는 설명
- `timerMinutes` — 없어도 됨. 있으면 그 단계용 **타이머(분)**

### RecipeModel (레시피 전체 한 건)

피드 카드·상세 화면에 올릴 **레시피 한 장 전체**입니다.

- `id` — 이 레시피만의 고유 번호
- `title`, `description` — 제목과 소개
- `authorName` — 작성자 닉네임
- `authorTitle` — 없어도 됨. 있으면 닉네임 옆에 다는 **칭호**  
  예: `K-반찬 장인`, `트레이더 조 개척자`  
  칭호 시스템을 아직 만들지 않았지만, 데이터 칸은 미리 잡아 둔 것입니다.
- `imageUrl`, `category` — 사진 주소, 분류(반찬 등)
- `baseServings` — (구버전 필드, 최신 PROJECT_SPEC에서는 제거됨)
- `authorId` — 작성자 고유 ID (내 다이어리 필터에 사용, 예: `current_user_me`)
- `satisfactionScore` — 작성자 완성도 별점 (기본 5.0)
- `recommendationTag` — 추천 칩 문구 (기본 `microwave only!`)
- `cookNote` — 실전 후기 메모 (없어도 됨)
- `cookingTimeMinutes` — 총 조리 시간(분)
- `ingredients` — 위의 Ingredient 여러 개
- `steps` — 위의 RecipeStep 여러 개
- `parentRecipeId` — 없어도 됨. **리믹스(다른 사람 레시피를 바탕으로 만든 버전)** 일 때, 원본 레시피의 `id`  
  값이 없으면 “처음부터 만든 원작”, 있으면 “이 번호 레시피의 파생작”
- `remixCount` — 이 레시피에서 몇 번 리믹스가 나왔는지
- `createdAt` — 만든 시각

### Step 2를 어떻게 확인하나요?

1. 위 파일이 있는지만 보면 됩니다. 앱을 실행해도 **화면에 레시피가 나오지 않는 것이 정상**입니다. (아직 화면에 연결하지 않음)
2. 파일을 열어서 `class Ingredient`, `class RecipeStep`, `class RecipeModel` 세 이름이 보이면 성공입니다.
3. `toMap` / `fromMap` 같은 Firestore 저장 코드는 **아직 없습니다.** 일부러 빼 두었습니다.

### Step 3 단위 변환기 (`UnitConverter`)

파일: `lib/core/utils/unit_converter.dart`  
아직 **버튼이나 화면은 없습니다.** 나중에 레시피 상세의 Metric/Imperial 토글이 이 계산을 호출합니다.

**지원하는 공식 (순수 나눗셈/곱셈, 패키지 없음)**

| 방향 | 공식 |
|------|------|
| g → oz | `양 / 28.3495` |
| oz → g | `양 * 28.3495` |
| ml → cup | `양 / 240.0` (미국 법정 cup) |
| cup → ml | `양 * 240.0` |

- `tbsp`, `tsp` 는 **다른 단위로 바꾸지 않습니다.** 이름 그대로 둡니다.
- 인분을 늘리는 `scaleForServings` 는 **아직 없습니다.**
- `formatAmount`: `1.0` → `"1"`, `1.50` → `"1.5"`, `0.3333` → `"0.33"` (소수 최대 2자리, 쓸데없는 0 제거)

초보자용 사용 예시 (한 줄):

```dart
UnitConverter.formatAmount(UnitConverter.convert(amount: 100, fromUnit: 'g', toUnit: 'oz'));
```

100g을 온스로 바꾼 뒤, 화면에 넣을 짧은 글자로 만듭니다.

**확인 방법:** `UnitConverter` 함수 이름이 파일에 있으면 됩니다. 화면 확인은 아래 Step 5를 보세요.

### Step 4 더미 레시피 (`MockRecipeService`)

Firebase에 아직 레시피를 저장하지 않아도, 나중에 목록/상세 화면을 그릴 때 **가짜 데이터**가 필요합니다.  
인터넷이나 로그인 없이 같은 3개가 항상 나옵니다.

파일: `lib/features/recipe/services/mock_recipe_service.dart`

지금 들어 있는 샘플:

| 제목 | 작성자 | 칭호 | 대체 팁이 있는 재료 |
|------|--------|------|-------------------|
| 매콤 두부조림 | 철민 | K-반찬 장인 | 고춧가루 (Trader Joe's Spice aisle) |
| 김치 베이컨 파스타 | Emily | 퓨전 연금술사 | 생크림 (미국 마트 Dairy) |
| 소고기 미역국 | Alex | 없음 (`null`) | 국간장 (Whole Foods 아시안) |

코드에서 꺼내는 방법:

```dart
final recipes = MockRecipeService.getRecipes();
```

**새 테스트 레시피를 넣고 싶을 때**

1. 위 파일을 엽니다.
2. `_recipes` 리스트 **안**에 `RecipeModel( ... ),` 를 하나 더 붙입니다. (맨 위 3개 중 하나를 복사해 제목·재료만 바꿔도 됩니다.)
3. `id` 는 다른 레시피와 **겹치지 않게** 적습니다.
4. 저장합니다. 피드 화면이 이 리스트를 읽으므로, 앱을 **다시 실행**(`flutter run` 또는 `r` 핫 리로드)하면 Explore/Friends에 카드가 늘어납니다.

빼려면 그 `RecipeModel(...)` 덩어리만 지우면 됩니다.

### Step 5 메인 피드 화면 (`RecipeFeedScreen`)

`lib/main.dart` 가 이제 이 화면을 첫 화면으로 엽니다. `Hello World!` 는 더 이상 나오지 않습니다.

파일: `lib/features/recipe/views/recipe_feed_screen.dart`

---

## 4. 앱 실행 후 화면 테스트 (초보자용)

1. Cursor에서 `jubu` 폴더가 열린 상태로 터미널을 엽니다.
2. **Android 에뮬레이터**를 켜거나, USB로 폰을 연결합니다. (Android Studio의 Device Manager에서 Pixel 같은 기기를 실행하면 됩니다.)
3. 실행합니다.

```bash
flutter run
```

기기를 고르라는 목록이 나오면 **android** / **emulator** 항목의 번호를 입력합니다.  
웹(Chrome)은 지금은 쓰지 않습니다. 한 번에 지정하려면:

```bash
flutter run -d android
```

에뮬레이터가 안 보이면 `flutter devices` 로 연결된 기기를 확인하세요.

4. **맨 위 주황 바**에 큰 글자 **JUBU** 가 보이고, 오른쪽 끝에 검색(돋보기)·알림(종) 아이콘이 있으면 성공입니다. (아이콘을 눌러도 아직 아무 일도 없습니다.)
5. 주황 바 **아래 탭**이 **세 개**입니다: **Explore** | **Friends** | **My Log**
6. 화면 **오른쪽 아래**에 주황 **+** 버튼(FAB)이 있습니다. 누르면 작성 화면이 열립니다.

### Explore 탭 (기본으로 열려 있음)

- **오늘 뭐 먹지?** 용 탐색 화면입니다.
- 카드가 **2열**로 나열됩니다.
- 각 카드: **위**에 음식 사진, **아래**에 제목(매콤 두부조림 등)과 조리 시간(`20 min`). 폰을 세로로 들었을 때 한 화면에 2열이 보이면 정상입니다.
- 카드를 **누르면** 상세 화면으로 이동합니다.

레시피가 3개면 위 2개 + 아래 1개가 보이면 정상입니다.

### Friends 탭으로 바꾸는 방법

1. 상단에서 **Friends** 글자를 **한 번 탭**(또는 클릭)합니다.
2. 화면이 **한 줄짜리 큰 카드** 목록으로 바뀝니다.
3. 각 카드에서 확인할 것:
   - 큰 음식 사진
   - 작성자 이름 (철민, Emily, Alex)
   - 칭호: 철민은 `K-반찬 장인`, Emily는 `퓨전 연금술사`, Alex는 칭호 줄이 **없음**
   - 짧은 소개 글 + 노란 박스의 마트 팁 (Trader Joe's / Dairy / Whole Foods)
4. **Explore** 를 다시 누르면 2열 그리드로 돌아갑니다.

### My Log 탭

1. 상단 **My Log**를 탭합니다.
2. 내가 올린 요리만 2열 그리드로 보입니다. (Mock: 매콤 두부조림)
3. 우측 아래 **+** 를 누르면 새 레시피 작성 화면이 열립니다.

사진이 안 뜨고 회색+포크 아이콘이면, 인터넷이 막혀 Unsplash 이미지를 못 받은 것입니다. 제목·시간은 그대로 보여야 합니다.

> `flutter test` 는 예전 `Hello World!` 화면을 찾는 파일이 남아 있으면 실패할 수 있습니다. Step 5 확인은 **`flutter run` 화면**으로 하세요.

> 팁: `flutter doctor` 로 도구 설치를 점검할 수 있습니다.

### 빨간 오류: `The name 'MyApp' isn't a class`

이건 앱이 고장난 게 아니라 **테스트 파일 이름 불일치**였습니다.

- `lib/main.dart` 의 앱 클래스 이름은 `MainApp` 입니다.
- 예전 템플릿 테스트 `test/widget_test.dart` 가 없는 이름 `MyApp` 과 카운터(0, + 버튼)를 찾고 있었습니다.
- 지금은 `MainApp` 을 켜고 화면에 `Hello World!` 가 있는지만 검사합니다.

에디터에서 오류가 사라졌는지 확인한 뒤, 터미널에서:

```bash
flutter test
```

모두 통과하면 성공입니다.

### Step 6 / 6-1 / SPEC 동기화 — 상세·자동 단위·My Log

상세 화면은 피드 카드를 누르면 열립니다.

1. `flutter run -d android` 로 앱을 실행합니다.
2. **Explore / Friends / My Log** 중 아무 카드나 누릅니다.
3. 상세에서 확인할 것:
   - 상단: 이미지, 제목, 조리시간, 작성자(칭호 배지)
   - AppBar **오른쪽 아이콘**(시험관/자 모양)은 **테스트용 단위 전환**입니다. 나중에 프로필 설정으로 대체됩니다.
     - 기본은 Metric (`isImperial = false`): 두부 `400 g`, 물 `120 ml`
     - 아이콘을 한 번 누르면 Imperial: 두부 약 `14.11 oz`, 물 `0.5 cup`
     - `tbsp` / `tsp`는 **항상 그대로**입니다.
     - 숫자는 항상 `UnitConverter.formatAmount`를 거친 뒤 표시됩니다.
   - 요리 평가 카드: 별점 + 추천 칩 + 따옴표 실전 메모(`cookNote`가 있을 때만)
   - Steps: 주황 원형 번호 뱃지와 설명이 **한 줄 왼쪽**에 맞춰져 있으면 성공

**My Log 탭**
1. 상단 **My Log**를 탭합니다.
2. `authorId == current_user_me` 인 레시피만 나옵니다. (지금은 **매콤 두부조림** 1개)
3. 헤더에 `My Cook Log` / `1개의 요리 기록`이 보이면 정상입니다.

**피드에서 별점/추천**
- Explore: 카드 오른쪽 별 + 점수
- Friends: 별점 + 초록 추천 칩 + 메모 박스(있을 때)

### Step 7 요리 모드 (`CookingModeScreen`)

멀리서도 보이게 큰 글씨로 단계만 보여주는 화면입니다.

1. 아무 레시피 상세로 들어갑니다.
2. 맨 아래 **요리 모드 시작**을 누릅니다.
3. 확인할 것:
   - 위에 요리 제목 + `Step 1 / N`, 오른쪽 **X**로 닫기
   - 가운데 큰 글씨로 조리 지침 (좌우 스와이프 또는 하단 버튼으로 이동)
   - `timerMinutes`가 있는 단계(예: 두부조림 3단계 5분, 미역국 3단계 20분):
     - 큰 카운트다운 `MM:SS`
     - **시작** → 숫자가 줄어듦 / **일시정지** → 멈춤 / **리셋** → 처음 시간으로
   - 마지막 단계에서 버튼이 **요리 완료**로 바뀌고, 누르면 축하 다이얼로그 후 상세로 돌아감

### Step 8 새 레시피 작성 (`CreateRecipeScreen`)

1. 피드에서 오른쪽 아래 **+** 를 누릅니다.
2. 제목·설명·카테고리·조리 시간(분)을 적습니다. 이미지 URL은 비워 둬도 됩니다.
3. **재료 추가**로 행을 늘릴 수 있습니다. 대체재는 쉼표로 여러 개 (`Cayenne, Paprika`).
4. **단계 추가**로 조리 순서를 늘립니다. 타이머 분은 비워 둬도 됩니다.
5. 만족도 슬라이더(0~5, 0.5 단위), 추천 태그, 실전 메모를 채웁니다.
6. **저장하기**를 누릅니다.
7. 피드로 돌아오면 **Explore** 맨 앞과 **My Log**에 방금 만든 글이 보여야 합니다. (작성자 이름은 `나`, `authorId`는 `current_user_me`)
8. 재료나 단계가 비어 있으면 저장되지 않고 안내 메시지가 뜹니다.

---

## 5. 기능 테스트 가이드 목차 (앞으로 채워짐)

아래 항목은 **아직 비어 있습니다.** 해당 기능을 만들 때 여기에 “어디를 누르고, 무엇이 보여야 하는지”를 적습니다.

- [x] 5.1 앱 실행 / 첫 화면 — `flutter run` 후 주황 AppBar에 **JUBU**
- [ ] 5.2 로그인 (Google 등)
- [x] 5.3 메인 피드 — Explore (2열 그리드, 사진·제목·조리시간)
- [x] 5.4 메인 피드 — Friends (와이드 카드, 작성자·칭호·팁)
- [x] 5.4b 메인 피드 — My Log (내 요리 다이어리 그리드) + FAB(+)
- [x] 5.5 레시피 상세 — 자동 단위 변환 + 별점/추천/요리 메모
- [ ] 5.6 레시피 상세 — 인분(Servings) 조절
- [x] 5.7 로컬 식재료 대체(Swap) 정보 — 상세 Ingredients 팁 박스
- [x] 5.8 요리 모드 (Cooking Mode) — PageView 단계 + 타이머 + 요리 완료
- [x] 5.8b 새 레시피 작성 (CreateRecipeScreen) — FAB(+) 저장 후 피드 갱신
- [ ] 5.9 레시피 리믹스 (Remix / Fork)
- [ ] 5.10 칭호(업적) 시스템

---

## 6. 코드를 볼 때 (아주 짧게)

기능을 만들면 보통 `lib/` 아래에 파일이 생깁니다.

- `lib/main.dart` — 앱 입구 (`RecipeFeedScreen` + `AppColors` 테마)
- `lib/core/constants/` — 색상·글자 스타일
- `lib/core/utils/unit_converter.dart` — g/oz, ml/cup 계산
- `lib/features/recipe/models/recipe_model.dart` — 레시피 데이터 설계도 (`authorId` 포함)
- `lib/features/recipe/services/mock_recipe_service.dart` — `getRecipes()` / `getMyRecipes()`
- `lib/features/recipe/views/recipe_feed_screen.dart` — Explore / Friends / My Log + FAB
- `lib/features/recipe/views/create_recipe_screen.dart` — 새 레시피 작성 폼
- `lib/features/recipe/views/recipe_detail_screen.dart` — 자동 단위 + 요리 평가 카드
- `lib/features/cooking_mode/views/cooking_mode_screen.dart` — 요리 집중 모드 (큰 글씨·타이머)
- `lib/features/` — 로그인, 레시피, 요리 모드 등 **기능별** 폴더

모르는 파일이 보이면 **이 매뉴얼의 해당 번호**와 `CHANGELOG.md`의 파일 목록을 같이 보면 됩니다.
