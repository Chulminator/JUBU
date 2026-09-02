# CHANGELOG

JUBU 작업 이력입니다. **최신 항목이 위에** 오도록 적습니다.

기록 형식:

- **날짜/시간:** 작업을 끝낸 시각
- **작업 번호:** 요청 단위를 구분하는 번호 (예: TASK-001)
- **생성/수정된 파일:** 실제로 만든·고친 파일 경로
- **핵심 로직 요약:** 무엇을 넣었는지 한눈에 보이게

---

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
