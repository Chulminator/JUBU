# JUBU 프로젝트 매뉴얼 (초보자용)

이 문서는 **코드를 잘 몰라도** 앱이 무엇인지, 무엇을 확인하면 되는지 안내합니다.  
기능이 추가될 때마다 아래 목차에 테스트 방법이 채워집니다.

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

---

## 3. 폴더가 왜 이렇게 나뉘어 있나요? (Feature-First)

기능을 종류별로 나눠 두는 방식입니다. **공통 색/글꼴 + 레시피 데이터 설계도**까지 있습니다. 화면은 아직 없습니다.

```text
lib/
├── core/                 ← 여러 화면이 같이 쓰는 공통 것
│   ├── constants/        ← 색상, 글자 스타일 (여기 파일이 있음)
│   ├── utils/            ← 나중에 단위 변환 같은 계산 도구
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

4. **Step 1 확인:** 위 두 테마 파일과 `lib/features/` 아래 `auth`, `recipe`, `cooking_mode` 폴더가 있으면 됩니다. 화면은 `Hello World!` 여도 정상입니다.

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
- `baseServings` — 이 재료 양이 **몇 인분 기준**인지 (인분을 늘릴 때 출발점)
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

---

## 4. 지금 당장 할 수 있는 확인 (앱 실행)

아직 화면 기능 테스트 항목은 없습니다. 앱이 **켜지는지**만 확인하면 됩니다.

1. Cursor 또는 VS Code에서 이 프로젝트 폴더(`jubu`)를 엽니다.
2. 터미널에서 프로젝트 루트(이 `PROJECT_MANUAL.md`가 있는 폴더)인지 확인합니다.
3. 아래 명령을 실행합니다.

```bash
flutter run
```

4. 에뮬레이터 또는 연결된 폰에 기본 Flutter 화면이 뜨면 성공입니다.
5. 문제가 나면 `CHANGELOG.md` 최신 항목과 이 매뉴얼을 함께 보면서 어디까지 만들었는지 확인하세요.

> 팁: `flutter doctor` 를 실행하면 Flutter/Android/iOS 도구가 설치되어 있는지 점검할 수 있습니다.

---

## 5. 기능 테스트 가이드 목차 (앞으로 채워짐)

아래 항목은 **아직 비어 있습니다.** 해당 기능을 만들 때 여기에 “어디를 누르고, 무엇이 보여야 하는지”를 적습니다.

- [ ] 5.1 앱 실행 / 첫 화면
- [ ] 5.2 로그인 (Google 등)
- [ ] 5.3 메인 피드 — Explore (탐색)
- [ ] 5.4 메인 피드 — Friends (친구)
- [ ] 5.5 레시피 상세 — 단위 토글 (Metric / Imperial)
- [ ] 5.6 레시피 상세 — 인분(Servings) 조절
- [ ] 5.7 로컬 식재료 대체(Swap) 정보
- [ ] 5.8 요리 모드 (Cooking Mode)
- [ ] 5.9 레시피 리믹스 (Remix / Fork)
- [ ] 5.10 칭호(업적) 시스템

---

## 6. 코드를 볼 때 (아주 짧게)

기능을 만들면 보통 `lib/` 아래에 파일이 생깁니다.

- `lib/main.dart` — 앱 입구 (아직 테마 파일과 연결하지 않음)
- `lib/core/constants/` — 색상·글자 스타일
- `lib/features/recipe/models/recipe_model.dart` — 레시피 데이터 설계도
- `lib/features/` — 로그인, 레시피, 요리 모드 등 **기능별** 폴더

모르는 파일이 보이면 **이 매뉴얼의 해당 번호**와 `CHANGELOG.md`의 파일 목록을 같이 보면 됩니다.
