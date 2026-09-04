# CHANGELOG

JUBU 작업 이력입니다. **최신 항목이 위에** 오도록 적습니다.

기록 형식:

- **날짜/시간:** 작업을 끝낸 시각
- **작업 번호:** 요청 단위를 구분하는 번호 (예: TASK-001)
- **생성/수정된 파일:** 실제로 만든·고친 파일 경로
- **핵심 로직 요약:** 무엇을 넣었는지 한눈에 보이게

---

## [2026-09-04 13:02] [docs]

- **생성/수정된 파일**
  - `PROJECT_MANUAL.md` (전면 갱신)
  - `CHANGELOG.md` (수정)
- **핵심 변경**
  - 매뉴얼을 현재 구현 상태(피드·상세 세로 스크롤·요리 모드·별점 대기·작성 폼·영문 UI·다중 태그·갤러리) 기준으로 다시 작성.
  - 오래된 Hello World / substitutions / 좌우 탭 상세 / 카테고리 칩 안내 제거.

## [2026-09-04 12:44] [feedback]

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Detail screen: removed Overview / Ingredients / Steps tabs and horizontal PageView.
  - Single vertical `ListView` column: cover → meta → cook note → ingredients → steps → rating (if pending).

## [2026-09-04 12:34] [feedback]

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/services/mock_recipe_service.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Category: text field only (suggested chips removed).
  - Tags: `recommendationTags` (List) via comma-separated TextEditingController.
  - Removed Optional cover URL section.
  - Feed cards show photo + title again, plus rating, tags, author, author title.

## [2026-09-04 12:03] [feedback]

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/services/mock_recipe_service.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/cooking_mode/views/cooking_mode_screen.dart`
  - `android/app/src/main/AndroidManifest.xml`
  - `pubspec.yaml` (`image_picker`)
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Create form: category chips + custom text, gallery cover pick, substitutions removed, optional fields folded, optional step photos.
  - Detail: horizontal PageView (Overview / Ingredients / Steps / Rate when pending).
  - After Cooking Mode complete → pending rating queue; rate from Rate page or My Log.
  - Feed cards show only rating, tag, author, author title. All in-app UI strings in English.

## [2026-09-03 15:51] Step 8

- **생성/수정된 파일**
  - `lib/features/recipe/views/create_recipe_screen.dart` (생성)
  - `lib/features/recipe/views/recipe_feed_screen.dart` (수정)
  - `lib/features/recipe/services/mock_recipe_service.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `CreateRecipeScreen`: 기본 정보, 동적 재료/단계 행, 만족도 슬라이더, 추천 태그, 실전 메모 폼. 저장 시 `authorId: current_user_me`, `authorName: 나`.
  - `MockRecipeService.addRecipe`로 메모리 리스트 맨 앞에 삽입.
  - 피드 FAB에서 작성 화면으로 이동하고, pop 후 `setState`로 Explore/My Log 갱신.

## [2026-09-03 14:34] TASK-011 (Step 7)

- **생성/수정된 파일**
  - `lib/features/cooking_mode/views/cooking_mode_screen.dart` (생성)
  - `lib/features/recipe/views/recipe_detail_screen.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `CookingModeScreen`: PageView로 단계 스와이프, `AppTextStyles.cookingMode` 대형 지침, `Timer.periodic` 기반 시작/일시정지/리셋 타이머.
  - 상단 제목 + Step n/N + 닫기(X). 하단 이전/다음, 마지막은 요리 완료 → 다이얼로그 후 pop.
  - 상세 화면「요리 모드 시작」에서 `Navigator.push`로 연결. wakelock 등 외부 패키지 없음.

## [2026-09-03 13:36] TASK-010 (Step 6-2)

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_detail_screen.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - 상세 화면을 StatefulWidget으로 바꾸고 `isImperial`(기본 `false`, Metric) 상태 변수로 사용자 단위 선호를 흉내 냄.
  - 재료는 원본을 그대로 찍지 않고 항상 `UnitConverter.convert` + `formatAmount`를 통과. Imperial: g→oz, ml→cup. Metric: oz→g, cup→ml. tbsp/tsp는 유지.
  - AppBar 작은 아이콘으로 `isImperial` 토글해 즉시 검증 가능 (프로필 연동 전 테스트용).

## [2026-09-03 13:19] TASK-009 (PROJECT_SPEC sync)

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart` (수정)
  - `lib/features/recipe/services/mock_recipe_service.dart` (수정)
  - `lib/features/recipe/views/recipe_detail_screen.dart` (수정)
  - `lib/features/recipe/views/recipe_feed_screen.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `RecipeModel`을 PROJECT_SPEC §5에 맞춤: `authorId` 추가, `baseServings` 제거, `satisfactionScore` 기본 5.0, `recommendationTag` 기본 `microwave only!`.
  - Mock: 두부조림 `authorId: current_user_me`, 나머지 타인 ID. `getMyRecipes()` 헬퍼 추가.
  - 상세: 수동 토글 없음. `isImperial = false` 플레이스홀더 + `UnitConverter` 자동 렌더. 요리 평가 카드·Step 좌측 정렬 유지.
  - 피드: Explore / Friends / **My Log** 3탭 + 작성용 FAB(+), onPressed 빈 람다.

## [2026-09-03 12:04] TASK-008 (Step 6-1)

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart` (수정)
  - `lib/features/recipe/services/mock_recipe_service.dart` (수정)
  - `lib/features/recipe/views/recipe_detail_screen.dart` (수정)
  - `lib/features/recipe/views/recipe_feed_screen.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `RecipeModel`에 `satisfactionScore`(별점), `recommendationTag`(추천 문구), `cookNote`(실전 후기, 선택) 추가.
  - Mock 3개에 현실적인 값 채움. 미역국은 `cookNote` 없음.
  - 상세 화면: Metric/Imperial 토글 제거, 재료는 원본 단위로 표시. Steps는 원형 숫자 뱃지 + 설명을 한 줄 왼쪽 정렬.
  - 상세·피드(Explore 별점, Friends 별점+칩+메모)에 읽기 전용 요리 노트 카드 표시.

## [2026-09-03 10:51] TASK-007 (Step 6)

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_detail_screen.dart` (생성)
  - `lib/features/recipe/views/recipe_feed_screen.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `RecipeDetailScreen`: `Metric / Imperial` `SegmentedButton` 토글에 따라 Ingredients의 g/oz, ml/cup 값을 `UnitConverter`로 변환하고 `formatAmount`로 표시.
  - `substitutions` 또는 `storeTip`이 있는 재료는 Ingredients 아래에 노란 💡 팁 박스를 표시.
  - Steps를 단계별로 나열하고, 하단 고정 액션 바에 `요리 모드 시작` 버튼(동작은 빈 람다).
  - 피드의 카드 `onTap`에서 `Navigator.push`로 해당 `RecipeModel`을 상세 화면으로 전달.


## [2026-09-02 16:28] TASK-006 (Step 5)

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart` (생성)
  - `lib/main.dart` (수정)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `RecipeFeedScreen`: `DefaultTabController`로 Explore(2열 `GridView`, 사진·제목·조리시간) / Friends(1열 와이드 카드, 작성자·칭호·소개·마트 팁·큰 사진).
  - Mock 데이터 직접 바인딩. 카드 `onTap`은 빈 람다. Provider/비동기 없음.
  - `MainApp` home을 피드로 교체하고 `ThemeData`에 `AppColors.primary` 등 적용. AppBar에 검색/알림 더미 아이콘.

## [2026-09-02 14:34] TASK-005 (Step 4)

- **생성/수정된 파일**
  - `lib/features/recipe/services/mock_recipe_service.dart` (생성)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - `MockRecipeService.getRecipes()`가 동기 `List<RecipeModel>` 3개를 반환. Future/Stream/Firebase 없음.
  - 샘플: 매콤 두부조림(철민, K-반찬 장인, 고춧가루 대체), 김치 베이컨 파스타(Emily, 퓨전 연금술사, 생크림 대체), 소고기 미역국(Alex, 칭호 없음, 국간장 대체).
  - 이미지 URL은 Unsplash 플레이스홀더.

## [2026-09-02 14:18] TASK-004 (Step 3)

- **생성/수정된 파일**
  - `lib/core/utils/unit_converter.dart` (생성)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - 순수 Dart `UnitConverter`: g↔oz (`± 28.3495`), ml↔cup (미국 법정 cup `± 240.0`).
  - `formatAmount`로 소수 최대 2자리·불필요 0 제거. tbsp/tsp는 변환하지 않음. `scaleForServings`·UI 없음.

## [2026-09-02 12:38] TASK-003 (Step 2)

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart` (생성)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **핵심 로직 요약**
  - 순수 Dart 모델 3개와 생성자만 추가. UI / Provider / Firestore `toMap`·`fromMap` 없음.
  - `Ingredient`: name, amount, unit, substitutions(현지 대체재 목록), storeTip(마트 코너, 선택).
  - `RecipeStep`: stepNumber, instruction, timerMinutes(선택).
  - `RecipeModel`: id, title, description, authorName, authorTitle(칭호, 선택), imageUrl, category, baseServings, cookingTimeMinutes, ingredients, steps, parentRecipeId(리믹스 원본, 선택), remixCount, createdAt.

## [2026-09-02 12:15] TASK-002 (Step 1)

- **생성/수정된 파일**
  - `lib/core/constants/app_colors.dart` (생성)
  - `lib/core/constants/app_text_styles.dart` (생성)
  - `lib/core/utils/.gitkeep` (생성)
  - `lib/core/widgets/.gitkeep` (생성)
  - `lib/features/auth/.gitkeep` (생성)
  - `lib/features/recipe/.gitkeep` (생성)
  - `lib/features/cooking_mode/.gitkeep` (생성)
  - `PROJECT_MANUAL.md` (수정)
  - `CHANGELOG.md` (수정)
- **폴더 구조**
  - `lib/core/constants/`, `lib/core/utils/`, `lib/core/widgets/`
  - `lib/features/auth/`, `lib/features/recipe/`, `lib/features/cooking_mode/`
- **핵심 로직 요약**
  - Feature-First 빈 디렉터리를 만들고, git이 빈 폴더를 추적하도록 `.gitkeep`을 둠.
  - `AppColors`: primary 웜 오렌지(`#E85D04`), secondary 허브 그린, 카드/배경 뉴트럴 크림, 대체재 강조 앰버.
  - `AppTextStyles`: title / subtitle / body / bodySmall / cookingMode(32pt) 정의.
  - 화면(Screen) 및 `main.dart`는 변경하지 않음.

## [2026-09-02 12:05] TASK-001

- **생성/수정된 파일**
  - `PROJECT_MANUAL.md` (생성)
  - `CHANGELOG.md` (생성)
- **핵심 로직 요약**
  - 앱 개요와 앞으로 채울 기능 테스트 목차만 있는 매뉴얼 뼈대를 추가함.
  - 이후 작업을 쌓아 적을 변경 이력 헤더 템플릿을 추가함.
  - 앱 기능 코드는 변경하지 않음.
