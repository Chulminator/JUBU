# CHANGELOG

JUBU 작업 이력입니다. **최신 항목이 위에** 오도록 적습니다.

기록 형식:

- **날짜/시간:** 작업을 끝낸 시각
- **작업 번호:** 요청 단위를 구분하는 번호 (예: TASK-001)
- **생성/수정된 파일:** 실제로 만든·고친 파일 경로
- **핵심 로직 요약:** 무엇을 넣었는지 한눈에 보이게

---

## [2026-09-18 15:10] [feedback] Rate after Done cooking + 0-star skip

- **생성/수정된 파일**
  - `lib/features/cooking_mode/views/cooking_mode_screen.dart`
  - `lib/features/recipe/views/rate_recipe_screen.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - **Done cooking** → 바로 Rate this cook (상세 스크롤 프롬프트 제거).
  - Rate 기본 별점 0. 0점+빈 코멘트 Submit 시 awaiting 큐에 유지.

## [2026-09-18 14:30] [feedback] Unlock / debug hub / My Log grid / pending ratings

- **생성/수정된 파일**
  - `lib/features/auth/views/title_badge_unlock_screen.dart`
  - `lib/features/debug/views/debug_hub_screen.dart`
  - `lib/features/recipe/views/pending_ratings_screen.dart`
  - `lib/features/recipe/views/rate_recipe_screen.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/services/mock_recipe_service.dart`
  - `lib/features/auth/providers/user_provider.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Title badge 해금 축하 화면 (`TitleBadgeUnlockScreen`).
  - 피드 왼쪽 아래 Debug FAB → 전체 화면 네비 + 칭호/pending 데모.
  - My Log: Explore와 같은 사진-only 3열 그리드 (Awaiting 제거).
  - Awaiting ratings → Settings 목록 → `RateRecipeScreen`(별점 + 선택 ~20단어 코멘트 → `RecipeModel`).
  - Detail: 스크롤 끝 + 미평가(pending)일 때만 Rate 화면 표시.

## [2026-09-18 14:00] [feedback] Create form trim + title badges + auto #

- **생성/수정된 파일**
  - `lib/features/auth/models/user_model.dart`
  - `lib/features/auth/providers/user_provider.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Create에서 username / title badge / rating 입력 제거 (저장 시 UserProvider 자동 적용).
  - Hashtag 입력: 띄어쓰기마다 다음 태그에 `#` 자동.
  - `UserModel.titleBadges` + `equippedTitle` 설정 드로어에서 장착 선택.

## [2026-09-18 13:45] [feedback] Detail layout + create form + hashtag spaces

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 해시태그 표시 `#a #b` (태그 사이 공백 1칸).
  - Detail: `@username` 왼쪽 / 칭호 오른쪽, 다음 줄 별점, 설명 아래 해시태그. Cook note UI 제거.
  - Create form을 Detail 필드 순서에 맞게 재구성 (cover→title→time/category→user/title→rating→desc→hashtags→ingredients→steps).

## [2026-09-18 11:36] [feedback] Taller home feed photos

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 홈 피드 카드 사진 높이 220 → **280**.

## [2026-09-18 11:35] [feedback] Feed More/hashtag layout

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/services/mock_recipe_service.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - `@username`을 별점 행에서 오른쪽 끝으로 고정.
  - 해시태그 띄어쓰기 제거 (`#a#b`), More와 함께 펼침. More는 설명 2번째 줄 우측.

## [2026-09-18 11:30] [feedback] Feed cards, hashtags, username, deactivate

- **생성/수정된 파일**
  - `lib/features/recipe/models/recipe_model.dart`
  - `lib/features/recipe/services/mock_recipe_service.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `lib/features/recipe/views/create_recipe_screen.dart`
  - `lib/features/auth/models/user_model.dart`
  - `lib/features/auth/providers/user_provider.dart`
  - `lib/features/auth/views/onboarding_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - `recommendationTags` → `hashtags`, 온보딩 Nickname → **Username**, 게시물 `@username` 표시.
  - 홈 카드: 별점|username, 설명 2줄+More, 다음 줄 `#tags`, 사진 더 길게. Explore는 사진만.
  - 설정 endDrawer에 **Deactivate account**(mock 로그아웃) 추가.

## [2026-09-17 13:40] [feedback] Explore search field

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Explore(돋보기) 탭 상단에 검색창 추가. 제목·작성자·카테고리·태그 필터.

## [2026-09-15 12:55] [feedback] Settings drawer, chat icon, utensil loading

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/auth/providers/user_provider.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 설정: 하단 시트 → **오른쪽 endDrawer**. Profile photo / Profile & units / Sign out.
  - Messages 아이콘: 종이비행기 → **말풍선**.
  - Friends·Explore: 당겨서 새로고침 + 하단 로드 시 **포크·나이프(`Icons.restaurant`)** 스피너.

## [2026-09-15 12:45] [feedback] Home tab left + centered title

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 하단 탭 순서: Friends(집) → Explore → Messages → My Log.
  - AppBar `JUBU` 가운데 정렬 (`centerTitle` + leading spacer).

## [2026-09-15 12:40] [feedback] Bottom icon tabs + Messages

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - TabBar를 AppBar 아래에서 **하단**으로 이동.
  - Messages 탭 추가 (플레이스홀더).
  - 탭 라벨 → 아이콘: Explore=돋보기, Friends=집, Messages=종이비행기, My Log=원형 프로필.

## [2026-09-15 11:20] Sync firebase_options to new google-services.json

- **생성/수정된 파일**
  - `lib/firebase_options.dart`
  - `CHANGELOG.md`
- **핵심 변경**
  - 새 `google-services.json` 기준으로 iOS/macOS `iosClientId`·`iosBundleId`(`com.chulminator.jubu`) 동기화.
  - Android `appId`/`package`는 이미 일치. Web client ID(`…3mlsuhr…`)는 유지.
  - 참고: json에 아직 Android OAuth(`client_type: 1`) 없음 → SHA-1 등록 후 재다운로드 필요.

## [2026-09-10 16:25] Firebase Android package sync

- **생성/수정된 파일**
  - `android/settings.gradle.kts` (google-services 4.5.0)
  - `android/build.gradle.kts` (중복 plugins 제거)
  - `lib/firebase_options.dart` (새 Android appId)
  - `android/app/src/main/kotlin/com/chulminator/jubu/MainActivity.kt`
  - `CHANGELOG.md`
- **핵심 변경**
  - Google services 플러그인은 원래 app 모듈에 이미 적용됨. Flutter에서는 Firebase BoM을 app/build.gradle에 넣지 않음 (pubspec FlutterFire가 담당).
  - `com.chulminator.jubu` 패키지와 `firebase_options` / MainActivity 정렬.
  - Google Sign-In은 여전히 SHA-1 등록 후 `client_type: 1`이 json에 생겨야 함.

## [2026-09-10 10:55] [docs] Android Google Sign-In SHA-1

- **생성/수정된 파일**
  - `lib/features/auth/views/login_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Android `sign_in_failed` / administrators 오류 안내 메시지 추가.
  - 매뉴얼에 이 PC debug SHA-1 및 `google-services.json`에 Android OAuth(`client_type: 1`) 필요 조건 명시.

## [2026-09-09 14:55] [feedback]

- **생성/수정된 파일**
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `lib/features/auth/views/login_screen.dart`
  - `lib/features/auth/services/auth_service.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Friends 카드 고정 높이(280) 제거 → bottom overflow 수정.
  - 로그인: **Sign in** / **Sign up** / **Proceed without it** (Sign up만 온보딩).
  - AppBar 톱니바퀴 설정 시트: Profile & units, Sign out.

## [2026-09-09 12:20] [feedback]

- **생성/수정된 파일**
  - `lib/features/auth/views/login_screen.dart`
  - `lib/features/auth/services/auth_service.dart`
  - `lib/features/auth/views/onboarding_screen.dart`
  - `lib/features/auth/providers/user_provider.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 로그인·온보딩 UI 영어화, 글로벌 타깃 카피로 변경 (한국/한인 특화 문구 제거).
  - Web Google 로그인: `signInWithPopup` 사용, `origin_mismatch` 시 안내 메시지 + 고정 포트 `7357` 문서화.
  - 기본 닉네임 `나` → `Chef`, 단위 카드 설명 중립화.

## [2026-09-09 12:10] fix: white screen on web auth

- **생성/수정된 파일**
  - `lib/features/auth/services/auth_service.dart`
  - `lib/features/auth/views/auth_gate.dart`
  - `web/index.html`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Chrome/web에서 `GoogleSignIn` Client ID 미설정으로 AuthService 생성 시 크래시 → 흰 화면이던 문제 수정 (`clientId` + meta 태그, lazy 초기화).
  - `AuthGate`가 `waiting`에 갇히지 않도록 로그인 화면으로 폴백.

## [2026-09-08 17:50] Step 10

- **생성/수정된 파일**
  - `lib/features/auth/services/auth_service.dart` (신규)
  - `lib/features/auth/views/login_screen.dart` (신규)
  - `lib/features/auth/views/auth_gate.dart` (신규)
  - `lib/main.dart`
  - `lib/features/auth/views/onboarding_screen.dart`
  - `pubspec.yaml` (`google_sign_in`)
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - Firebase Auth `AuthService`(Google / 익명 / 로그아웃, `authStateChanges`) 추가.
  - `LoginScreen` + `AuthGate`로 비로그인→로그인, 신규→온보딩, 기존/게스트→피드 분기.
  - `main`에서 `Firebase.initializeApp` 후 `AuthGate`를 home으로 설정.

## [2026-09-08 17:40] Auth entry

- **생성/수정된 파일**
  - `lib/features/auth/views/auth_entry_screen.dart` (신규)
  - `lib/main.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - 앱 시작 화면을 Sign in / Sign up 선택(`AuthEntryScreen`)으로 변경.
  - Sign in → Mock으로 바로 피드, Sign up → 온보딩(프로필·단위·식단) 후 피드.
  - 실제 Firebase/Google Auth는 아직 연동하지 않음.

## [2026-09-08 15:45] Step 9

- **생성/수정된 파일**
  - `lib/features/auth/models/user_model.dart` (신규)
  - `lib/features/auth/providers/user_provider.dart` (신규)
  - `lib/features/auth/views/onboarding_screen.dart` (신규)
  - `lib/main.dart`
  - `lib/features/recipe/views/recipe_detail_screen.dart`
  - `lib/features/recipe/views/recipe_feed_screen.dart`
  - `PROJECT_MANUAL.md`
  - `CHANGELOG.md`
- **핵심 변경**
  - `UserModel` / `UserProvider`(인메모리)와 온보딩 화면(닉네임·Metric/Imperial·선호 식단) 추가.
  - `main`에 `ChangeNotifierProvider` 주입, 시작 화면을 온보딩으로 변경.
  - 상세 화면은 로컬 `isImperial` 토글 대신 `UserProvider.preferImperial` + `UnitConverter`로 전역 반영.
  - 피드 AppBar 프로필 아이콘으로 온보딩(설정) 재진입 가능.

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
