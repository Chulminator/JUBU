import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/user_provider.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/views/onboarding_screen.dart';
import '../../debug/views/debug_hub_screen.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';
import 'create_recipe_screen.dart';
import 'pending_ratings_screen.dart';
import 'recipe_detail_screen.dart';

/// Bottom-nav home: Friends / Explore / Messages / My Log + FAB.
class RecipeFeedScreen extends StatefulWidget {
  const RecipeFeedScreen({super.key});

  @override
  State<RecipeFeedScreen> createState() => _RecipeFeedScreenState();
}

class _RecipeFeedScreenState extends State<RecipeFeedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _openCreateRecipe() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CreateRecipeScreen(),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = MockRecipeService.getRecipes();
    final myRecipes = MockRecipeService.getMyRecipes();
    final photoUrl =
        context.watch<UserProvider>().currentUser.photoUrl.trim();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        endDrawer: _SettingsEndDrawer(onChanged: () => setState(() {})),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          centerTitle: true,
          // Balance the two action icons so "JUBU" sits visually centered.
          leadingWidth: 96,
          leading: const SizedBox.shrink(),
          title: Text(
            'JUBU',
            style: AppTextStyles.title.copyWith(color: AppColors.onPrimary),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
              tooltip: 'Notifications',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                _RecipeOnlyMetaList(recipes: recipes),
                _RecipeOnlyMetaGrid(recipes: recipes),
                const _MessagesPlaceholder(),
                _MyLogView(recipes: myRecipes),
              ],
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: FloatingActionButton.small(
                heroTag: 'debug_hub_fab',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DebugHubScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onPrimary,
                tooltip: 'Debug screens',
                child: const Icon(Icons.bug_report_outlined),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: AppColors.cardBackground,
          elevation: 8,
          child: SafeArea(
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                const Tab(icon: Icon(Icons.home_outlined)),
                const Tab(icon: Icon(Icons.search)),
                const Tab(icon: Icon(Icons.chat_bubble_outline)),
                Tab(icon: _ProfileAvatar(photoUrl: photoUrl, radius: 12)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'create_recipe_fab',
          onPressed: _openCreateRecipe,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          tooltip: 'New recipe',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Settings panel that slides in from the right.
class _SettingsEndDrawer extends StatelessWidget {
  const _SettingsEndDrawer({required this.onChanged});

  final VoidCallback onChanged;

  Future<void> _pickProfilePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file == null || !context.mounted) {
      return;
    }
    context.read<UserProvider>().updatePreferences(photoUrl: file.path);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final int pendingCount = MockRecipeService.getPendingRatings().length;

    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Settings', style: AppTextStyles.subtitle),
            ),
            const Divider(height: 1),
            ListTile(
              leading: _ProfileAvatar(photoUrl: user.photoUrl, radius: 22),
              title: const Text('Profile photo'),
              subtitle: Text(
                user.photoUrl.trim().isEmpty
                    ? 'Add a photo from your gallery'
                    : 'Tap to change',
                style: AppTextStyles.bodySmall,
              ),
              onTap: () => _pickProfilePhoto(context),
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('Profile & units'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const OnboardingScreen(fromSettings: true),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Awaiting your rating'),
              subtitle: Text(
                pendingCount == 0
                    ? 'No cooks waiting'
                    : '$pendingCount waiting to rate',
                style: AppTextStyles.bodySmall,
              ),
              trailing: pendingCount > 0
                  ? CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.swapHighlight,
                      child: Text(
                        '$pendingCount',
                        style: const TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PendingRatingsScreen(),
                  ),
                );
                onChanged();
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Title badge', style: AppTextStyles.subtitle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Shown next to @${user.username} on your posts',
                style: AppTextStyles.bodySmall,
              ),
            ),
            ListTile(
              title: const Text('None'),
              trailing: user.equippedTitle == null
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                context.read<UserProvider>().setEquippedTitle(null);
              },
            ),
            ...user.titleBadges.map(
              (String badge) => ListTile(
                title: Text(badge),
                trailing: user.equippedTitle == badge
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<UserProvider>().setEquippedTitle(badge);
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_off_outlined),
              title: const Text('Deactivate account'),
              subtitle: Text(
                'Sign out and pause this account (mock)',
                style: AppTextStyles.bodySmall,
              ),
              onTap: () async {
                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Deactivate account?'),
                      content: const Text(
                        'This mock flow signs you out. '
                        'Cloud deactivate comes later with Firebase.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: Text(
                            'Deactivate',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (confirmed != true || !context.mounted) {
                  return;
                }
                Navigator.of(context).pop();
                await context.read<AuthService>().signOut();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(
                'Sign out',
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await context.read<AuthService>().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular profile avatar (network or local file path).
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.photoUrl, this.radius = 12});

  final String photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final String url = photoUrl.trim();
    ImageProvider<Object>? image;
    if (url.isNotEmpty) {
      if (url.startsWith('http')) {
        image = NetworkImage(url);
      } else {
        final File file = File(url);
        if (file.existsSync()) {
          image = FileImage(file);
        }
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceMuted,
      foregroundImage: image,
      child: image == null
          ? Icon(
              Icons.person,
              size: radius,
              color: AppColors.textSecondary,
            )
          : null,
    );
  }
}

/// Spinning restaurant (fork & knife) mark for pull / load-more.
class _ForkKnifeLoader extends StatefulWidget {
  const _ForkKnifeLoader({this.active = true});

  final bool active;

  @override
  State<_ForkKnifeLoader> createState() => _ForkKnifeLoaderState();
}

class _ForkKnifeLoaderState extends State<_ForkKnifeLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _ForkKnifeLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: const Icon(
            Icons.restaurant,
            size: 32,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Placeholder until messaging is implemented.
class _MessagesPlaceholder extends StatelessWidget {
  const _MessagesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text('Messages', style: AppTextStyles.subtitle),
            const SizedBox(height: 6),
            Text(
              'Coming soon — chat with cooks you follow.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Feed card: photo + meta (home) or photo-only (explore).
class _RecipeMetaCard extends StatelessWidget {
  const _RecipeMetaCard({
    required this.recipe,
    this.wide = false,
    this.photoOnly = false,
  });

  final RecipeModel recipe;
  final bool wide;
  final bool photoOnly;

  Widget _cover() {
    final url = recipe.imageUrl;
    if (!url.startsWith('http')) {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      }
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return ColoredBox(
          color: AppColors.surfaceMuted,
          child: Icon(Icons.restaurant, color: AppColors.textSecondary),
        );
      },
    );
  }

  Future<void> _openDetail(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photoOnly) {
      return Material(
        color: AppColors.cardBackground,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openDetail(context),
          child: AspectRatio(
            aspectRatio: 1,
            child: _cover(),
          ),
        ),
      );
    }

    final double photoHeight = wide ? 280 : 110;

    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: wide ? MainAxisSize.min : MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: photoHeight,
              width: double.infinity,
              child: _cover(),
            ),
            Padding(
              padding: EdgeInsets.all(wide ? 14 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.swapHighlight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.satisfactionScore.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.swapHighlight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '@${recipe.username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (recipe.description.trim().isNotEmpty ||
                      recipe.hashtagsLine.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    _ExpandableDescription(
                      text: recipe.description,
                      hashtags: recipe.hashtagsLine,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Description (~2 lines) with More on the right of line 2.
/// Hashtags expand together with More (no spaces between tags).
class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({
    required this.text,
    required this.hashtags,
  });

  final String text;
  final String hashtags;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  bool _exceedsTwoLines(double maxWidth, TextStyle style) {
    final String body = widget.text.trim();
    if (body.isEmpty) {
      return widget.hashtags.isNotEmpty;
    }
    final TextPainter painter = TextPainter(
      text: TextSpan(text: body, style: style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines || widget.hashtags.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = AppTextStyles.bodySmall;
    final TextStyle moreStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );
    final TextStyle tagStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w600,
    );

    if (_expanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.text.trim().isNotEmpty)
            Text(widget.text, style: bodyStyle),
          if (widget.hashtags.isNotEmpty) ...<Widget>[
            if (widget.text.trim().isNotEmpty) const SizedBox(height: 4),
            Text(widget.hashtags, style: tagStyle),
          ],
          GestureDetector(
            onTap: () => setState(() => _expanded = false),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Less', style: moreStyle),
              ),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool showMore =
            _exceedsTwoLines(constraints.maxWidth, bodyStyle);
        final String preview = widget.text.trim().isEmpty
            ? widget.hashtags
            : widget.text;

        return Stack(
          children: <Widget>[
            Text(
              preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: widget.text.trim().isEmpty ? tagStyle : bodyStyle,
            ),
            if (showMore)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => setState(() => _expanded = true),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    color: AppColors.cardBackground,
                    child: Text('More', style: moreStyle),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Shared pull-to-refresh + bottom load-more with fork/knife spinner.
mixin _UtensilScrollLoading<T extends StatefulWidget> on State<T> {
  final ScrollController utensilScrollController = ScrollController();
  bool utensilLoadingMore = false;

  @override
  void initState() {
    super.initState();
    utensilScrollController.addListener(_onUtensilScroll);
  }

  @override
  void dispose() {
    utensilScrollController.removeListener(_onUtensilScroll);
    utensilScrollController.dispose();
    super.dispose();
  }

  void _onUtensilScroll() {
    if (!utensilScrollController.hasClients || utensilLoadingMore) {
      return;
    }
    final position = utensilScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      _runLoadMore();
    }
  }

  Future<void> _runLoadMore() async {
    setState(() => utensilLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => utensilLoadingMore = false);
    }
  }

  Future<void> utensilRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  Widget utensilRefreshControl() {
    return CupertinoSliverRefreshControl(
      onRefresh: utensilRefresh,
      builder: (
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent,
      ) {
        final bool spin = refreshState == RefreshIndicatorMode.refresh ||
            refreshState == RefreshIndicatorMode.armed ||
            refreshState == RefreshIndicatorMode.done;
        return _ForkKnifeLoader(active: spin);
      },
    );
  }
}

class _RecipeOnlyMetaGrid extends StatefulWidget {
  const _RecipeOnlyMetaGrid({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  State<_RecipeOnlyMetaGrid> createState() => _RecipeOnlyMetaGridState();
}

class _RecipeOnlyMetaGridState extends State<_RecipeOnlyMetaGrid>
    with _UtensilScrollLoading<_RecipeOnlyMetaGrid> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<RecipeModel> get _filtered {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return widget.recipes;
    }
    return widget.recipes.where((RecipeModel r) {
      final String tags = r.hashtags.join(' ').toLowerCase();
      return r.title.toLowerCase().contains(q) ||
          r.username.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q) ||
          tags.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<RecipeModel> recipes = _filtered;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _search,
            style: AppTextStyles.body,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search recipes, cooks, tags…',
              hintStyle: AppTextStyles.bodySmall,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (String value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            controller: utensilScrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              utensilRefreshControl(),
              if (recipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No recipes match “$_query”.',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(2),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _RecipeMetaCard(
                          recipe: recipes[index],
                          photoOnly: true,
                        );
                      },
                      childCount: recipes.length,
                    ),
                  ),
                ),
              if (utensilLoadingMore)
                const SliverToBoxAdapter(child: _ForkKnifeLoader()),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecipeOnlyMetaList extends StatefulWidget {
  const _RecipeOnlyMetaList({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  State<_RecipeOnlyMetaList> createState() => _RecipeOnlyMetaListState();
}

class _RecipeOnlyMetaListState extends State<_RecipeOnlyMetaList>
    with _UtensilScrollLoading<_RecipeOnlyMetaList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: utensilScrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: <Widget>[
        utensilRefreshControl(),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecipeMetaCard(
                    recipe: widget.recipes[index],
                    wide: true,
                  ),
                );
              },
              childCount: widget.recipes.length,
            ),
          ),
        ),
        if (utensilLoadingMore)
          const SliverToBoxAdapter(child: _ForkKnifeLoader()),
      ],
    );
  }
}

class _MyLogView extends StatelessWidget {
  const _MyLogView({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return Center(
        child: Text(
          'No cook logs yet.\nTap + to add one.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return _RecipeMetaCard(
          recipe: recipes[index],
          photoOnly: true,
        );
      },
    );
  }
}
