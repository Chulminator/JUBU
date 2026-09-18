# JUBU 프로젝트 매뉴얼 (초보자용)

이 문서는 **코드를 잘 몰라도** 앱이 무엇인지, 어디까지 만들어졌는지, **어떻게 눌러서 확인하는지** 안내합니다.

**중요**
- 화면 기준: **Android 폰 / 에뮬레이터** (`flutter run -d android`)
- 앱 UI는 **영어**입니다. (이 매뉴얼만 한국어)
- Firebase **Auth**는 연동됨. 레시피 등 데이터는 아직 앱 메모리(Mock)입니다.

---

## 1. 앱이 뭔가요?

**JUBU** 는 어디서든 요리를 기록·공유하는 Flutter 앱입니다 (해외 거주·현지 재료·단위 차이를 염두에 둔 설계).

지금 할 수 있는 것:
- **Firebase Auth** 로그인 화면: **Sign in** / **Sign up** / **Proceed without it**
- **Sign up** → 온보딩(닉네임·단위·식단) → 피드
- **Sign in** / 게스트 → 바로 피드
- AppBar **설정(톱니바퀴)** → Profile & units / Sign out
- Explore / Friends / Messages / My Log 하단 아이콘 탭에서 레시피·메시지 보기
- 카드 눌러 상세 보기 (세로 스크롤)
- **전역 단위 설정**(Metric ↔ Imperial)에 따라 상세 재료 단위 자동 변환
- **Start cooking mode** 로 단계별 요리 모드 + 타이머
- 요리 완료 후 **별점 대기** → Settings / 상세 스크롤 끝에서 별점·코멘트 제출
- 오른쪽 아래 **+** 로 새 레시피 / 요리 일지 작성 (갤러리 사진 포함)
- 왼쪽 아래 **버그 아이콘** → Debug hub (화면 이동·칭호 해금 데모)

아직 없는 것: Firestore 레시피 저장, 팔로우 소셜, 인분 조절, 리믹스 UI

---

## 2. 앱 실행 방법

1. Cursor에서 `jubu` 폴더를 엽니다.
2. Android 에뮬레이터를 켜거나 폰을 USB로 연결합니다.
3. 터미널에서:

```bash
flutter run -d android
```

기기가 안 보이면 `flutter devices` 로 확인하세요.

성공 기준: **LoginScreen**(Sign in / Sign up / Proceed without it) → (Sign up이면 온보딩) → 주황 AppBar **JUBU** + 설정 톱니바퀴, **하단** 아이콘 탭(돋보기·집·종이비행기·프로필), **+** 버튼.

---

## 3. 화면별 테스트 가이드 (지금 구현된 것)

### 3.0 로그인 (`LoginScreen` + `AuthGate` + `AuthService`)

앱을 켜면 Firebase 초기화 후 **AuthGate**가 인증 상태를 보고 화면을 고릅니다.

| 상태 | 화면 |
|------|------|
| 비로그인 | `LoginScreen` |
| 로그인 + Sign up(온보딩 필요) | `OnboardingScreen` |
| 로그인 + Sign in / 게스트 | `RecipeFeedScreen` |

**LoginScreen에서 확인할 것**
- 중앙 **JUBU** 로고 텍스트
- 소개: *Your cook diary & recipe companion*
- **Sign in** — Google → 피드 (온보딩 스킵)
- **Sign up** — Google → 온보딩 → 피드
- **Proceed without it** — 익명(게스트) → 피드

#### Google 로그인 테스트 (Android — 권장)

1. Firebase Console (`jubu-9d725`) → Authentication → **Google** 및 **Anonymous** 사용 설정
2. **필수: 디버그 SHA-1 등록** (이게 없으면 `sign_in_failed` / `ApiException: 10` / administrators 문구가 납니다)
   - 이 PC의 debug SHA-1:
     `72:51:49:91:4D:24:06:66:AC:E3:68:2B:04:57:3E:AB:C8:26:10:A3`
   - Firebase Console → 톱니바퀴 **Project settings** → **Your apps** → Android (`com.chulminator.jubu`)
   - **Add fingerprint** → 위 SHA-1 붙여넣기 → 저장
   - **Download google-services.json** → `android/app/google-services.json` 교체
   - 앱 완전 종료 후 `flutter clean` → `flutter run -d emulator-5554`
3. 확인: 새 `google-services.json`의 `oauth_client`에 `"client_type": 1` (Android) 항목이 생겨야 정상입니다. (지금 파일에는 Web `type: 3`만 있음)
4. **Sign up** → 계정 선택 → 온보딩 → **Start JUBU** → 피드
5. 설정 → **Sign out** → **Sign in** → 같은 계정이면 **온보딩 없이 피드**
6. 계정 선택 취소 시 로그인 화면 유지 (크래시 없음)

**"This operation is restricted to administrators only"**
- 학교/회사(Google Workspace) 계정은 관리자가 외부 앱 로그인을 막아 둔 경우가 많습니다 → **개인 Gmail**로 시도
- 위 SHA-1 / `google-services.json` 미등록이면 Play Services가 비슷하게 실패할 수 있음 → fingerprint 등록 후 json 재다운로드가 우선

SHA-1을 다시 뽑는 명령 (Android Studio JBR 기준):

```bash
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Google 로그인 테스트 (Chrome / Web)

Web은 OAuth **JavaScript origin** 등록이 필요합니다. 포트가 바뀔 때마다 `origin_mismatch` 가 납니다.

1. **고정 포트로 실행** (코드 기본값 `7357`):

```bash
flutter run -d chrome --web-port=7357
```

2. [Google Cloud Console](https://console.cloud.google.com/) → 프로젝트 **jubu-9d725** → **APIs & Services** → **Credentials**
3. OAuth 2.0 Client ID **Web client** (`…3mlsuhrdgkh1qof78nrllo0ti74pcajj…`) 선택
4. **Authorized JavaScript origins** 에 추가:
   - `http://localhost:7357`
   - `http://127.0.0.1:7357`
5. 저장 후 1~2분 기다렸다가 **Sign in** / **Sign up** 재시도
6. Firebase Console → Authentication → **Settings** → **Authorized domains** 에 `localhost` 포함 확인

**Error 400: origin_mismatch** 가 나오면: 브라우저 주소창의 `http://localhost:포트` 와 Console에 등록한 origin이 **완전히 같아야** 합니다 (포트 포함).

#### 게스트(Proceed without it) 테스트

1. **Proceed without it** 탭
2. 온보딩 없이 **피드** 확인
3. 상세 단위는 `UserProvider` 기본값(Metric)

#### 설정(톱니바퀴) 테스트

1. 피드 AppBar 오른쪽 **설정** 아이콘 → **오른쪽**에서 패널이 열림
2. **Profile photo** → 갤러리 선택 → 하단 My Log 아바타 변경 확인
3. **Profile & units** → Username / 단위 변경 후 Save
4. **Title badge** → 목록에서 장착할 칭호 선택 (None 가능)
5. **Deactivate account** → 확인 후 로그인 화면(mock)
6. **Sign out** → 로그인 화면으로 복귀

**참고:** 레시피 Firestore 저장은 아직 없습니다. Auth 분기만 동작합니다.

**흰 화면만 보일 때 (Chrome)**  
- 앱을 **완전히 다시 실행** (`flutter run -d chrome --web-port=7357`). Hot reload만으로는 `web/index.html` 변경이 반영되지 않을 수 있습니다.

---

### 3.0-b 온보딩 · 전역 단위 설정 (`OnboardingScreen` + `UserProvider`)

**신규 Google 유저** 경로로 들어올 때 온보딩이 뜹니다. 선호값은 아직 기기 메모리(`UserProvider`)에만 저장됩니다.

**온보딩에서 설정하는 것**
1. **Username** — 게시물에 보이는 핸들 (`@username`)
2. **Measurement units** — **Metric** (g, ml) vs **Imperial** (oz, cup) 카드 선택
3. **Preferred cuisines** — Korean / Fusion / Western / Quick Meal 등 `FilterChip` 다중 선택
4. **Start JUBU** — `UserProvider` 저장 + `AuthService.completeOnboarding()` → 피드

**피드에서 다시 바꾸기**
- AppBar 오른쪽 **설정(톱니바퀴)** → **Profile & units**
- 단위를 바꾼 뒤 **Save** → 피드로 돌아옴

#### Metric ↔ Imperial 가 상세 재료에 바로 반영되는지 확인

1. 온보딩(또는 설정 → Profile & units)에서 **Metric** 선택 → **Start JUBU** / **Save**
2. Explore에서 **Spicy Braised Tofu** 등 카드 → 상세
3. **Ingredients**에서 `400 g`, `120 ml`처럼 **g / ml** 가 보이는지 확인
4. 뒤로 가 피드 → 설정 → Profile & units → **Imperial** 선택 → **Save**
5. 같은 레시피 상세를 다시 열면 (이미 열려 있으면 뒤로 갔다가 다시 진입) 재료가 약 **`14.11 oz`**, **`0.5 cup`** 로 바뀌는지 확인  
   - 상세는 `context.watch<UserProvider>().currentUser.preferImperial` 를 읽고 `UnitConverter`로 변환합니다.
6. `tbsp` / `tsp` 는 단위 설정과 관계없이 그대로여야 합니다.

AppBar의 시험관/자 **임시 토글은 제거**되었습니다. 단위는 온보딩/프로필에서만 바꿉니다.

---

### 3.1 피드 (`RecipeFeedScreen`)

**하단** 아이콘 탭 4개 + FAB(+) 입니다. (상단 AppBar에는 탭 없음)

| 아이콘 | 탭 | 무엇을 보나요? |
|--------|----|----------------|
| 집 | Friends (홈) | 세로로 긴 사진(280) + 제목 + **별점 \| @username** + 설명(2줄+More) + `#hashtags` |
| 돋보기 | Explore | 상단 검색창 + **사진만** 3열 그리드 |
| 말풍선 | Messages | 플레이스홀더 (*Coming soon*) |
| 원형 프로필 | My Log | **사진만** 3열 그리드 (Explore와 동일) |

**설정 (톱니바퀴)**  
- 오른쪽 `endDrawer`  
- **Profile photo** / **Profile & units** / **Awaiting your rating**(대기 목록) / **Title badge**(목록에서 장착) / **Deactivate account** / **Sign out**

**디버그 FAB**  
- 피드 **왼쪽 아래** 작은 버그 버튼 → `DebugHubScreen` (Feed / Detail / Create / Cooking / Pending / Rate / Login / Onboarding / 칭호 해금 데모 / pending 큐 추가)

**작성 화면 (`CreateRecipeScreen`)**  
Cover → Title → Time/Category → Description → Hashtags(띄어쓰기마다 `#` 자동) → Ingredients → Steps  
Username·칭호·별점은 저장 시 UserProvider에서 자동 적용 (폼에 없음).


카드를 누르면 **상세**로 이동합니다.  
사진이 회색+포크면 인터넷(Unsplash) 문제일 수 있습니다. 제목·별점은 보여야 합니다.

**Mock 샘플 (영문 UI 기준)**

| Title | Username | Title badge | Notes |
|-------|----------|-------------|--------|
| Spicy Braised Tofu | Chulmin | K-Banchan Craftsman | My Log에도 포함 (`current_user_me`) |
| Kimchi Bacon Pasta | Emily | Fusion Alchemist | |
| Beef Seaweed Soup | Alex | (없음) | |

---

### 3.2 상세 (`RecipeDetailScreen`)

피드 카드 → 상세.

**레이아웃:** 탭 없음. **한 화면 세로 스크롤**  
순서: 커버 사진 → 제목/시간/카테고리 → `@username` | 칭호 → 별점(+선택 코멘트) → 설명 → 해시태그 → **Ingredients** → **Steps**

Cooking Mode를 **Done cooking**하면 바로 `RateRecipeScreen`이 열립니다.

**단위 변환 (전역 설정)**
- `UserProvider.currentUser.preferImperial` 값에 따라 자동 적용 (상세 AppBar 토글 없음)
- Metric: `400 g`, `120 ml`
- Imperial: 약 `14.11 oz`, `0.5 cup`
- `tbsp` / `tsp` 는 그대로
- 바꾸는 방법: §3.0 온보딩/프로필 설정 참고

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
- 마지막 단계 **Done cooking** → 바로 **Rate this cook** 화면
  (0점+빈 코멘트로 Submit하면 Settings **Awaiting your rating**에 남음)

타이머 있는 Mock 예: Spicy Braised Tofu step 3 (5분), Beef Seaweed Soup step 3 (20분)

---

### 3.4 별점 대기 → 제출

**Settings에 두는 이유:** My Log는 사진 아카이브로 두고, “할 일(별점)”은 Settings에서 모아 보는 편이 덜 섞입니다. (알림 탭이 생기면 거기로 옮겨도 됨)

1. Cooking Mode → **Done cooking** → 바로 `RateRecipeScreen` (기본 별점 **0**)
2. 별점/코멘트 입력 후 **Submit** → `satisfactionScore` / `ratingComment` 저장
3. **0점 + 코멘트 없음**으로 Submit → 평가 안 한 것으로 보고 Settings **Awaiting your rating**에 남음
4. Settings → **Awaiting your rating** → 목록에서 다시 Rate 가능

**칭호 해금 화면:** Debug hub → **Unlock title badge** → `TitleBadgeUnlockScreen` 축하 화면.

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
- `authorId: current_user_me`, `username:` 현재 UserProvider username
- Mock 리스트 **맨 앞**에 추가
- 피드로 돌아오면 Explore / My Log에 새 카드가 보여야 함

재료 또는 단계가 비어 있으면 저장되지 않고 SnackBar가 뜹니다.

---

## 4. 구현 체크리스트 (현재)

- [x] 앱 실행 / JUBU AppBar
- [x] 하단 아이콘 탭 Explore / Friends / Messages / My Log + FAB(+)
- [x] 피드 카드: 사진·제목·별점·태그·작성자·칭호
- [x] 상세 세로 스크롤 + 단위 변환 테스트 아이콘
- [x] 요리 노트 카드 (별점·태그·메모)
- [x] Cooking Mode (PageView·타이머·Done cooking)
- [x] 별점 대기 큐 (Settings) + Rate 화면(별·코멘트) + Done cooking 직후 표시
- [x] CreateRecipeScreen (갤러리·다중 태그·fold 옵션)
- [x] Title badge 장착 (Settings) + 해금 축하 화면(디버그)
- [x] Debug hub FAB (화면 네비게이션)
- [ ] Google 로그인 / 온보딩
- [ ] Firestore 연동
- [ ] 인분(Servings) 조절
- [ ] 리믹스 UI
- [ ] 칭호 해금 조건(실제 업적 연동)

---

## 5. 코드 지도 (어디를 보면 되나요?)

```text
lib/
├── main.dart                          ← 앱 시작, AuthGate
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
    │   │     hasRated / isPendingRating
    │   └── views/
    │         recipe_feed_screen.dart
    │         recipe_detail_screen.dart
    │         create_recipe_screen.dart
    │         pending_ratings_screen.dart
    │         rate_recipe_screen.dart
    ├── cooking_mode/views/cooking_mode_screen.dart
    ├── debug/views/debug_hub_screen.dart
    └── auth/
          views/login_screen.dart
          views/title_badge_unlock_screen.dart
          providers/user_provider.dart
```

### 데이터 모델 요약 (`recipe_model.dart`)

- **Ingredient:** `name`, `amount`, `unit`, `storeTip?`  
  (`substitutions` 필드는 **제거됨**)
- **RecipeStep:** `stepNumber`, `instruction`, `timerMinutes?`, `imagePath?` (갤러리 로컬 경로)
- **RecipeModel:** `id`, `title`, `description`, `authorId`, `username`, `authorTitle?`, `imageUrl`, `category`, `cookingTimeMinutes`, `ingredients`, `steps`, `satisfactionScore` (기본 5.0), `hashtags`, `cookNote?`, `ratingComment?`, `parentRecipeId?`, `remixCount`, `createdAt`

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
