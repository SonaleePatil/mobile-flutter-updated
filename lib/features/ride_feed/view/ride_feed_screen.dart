import 'dart:io';

import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/feed_posts/models/feed_post_model.dart';
import 'package:adcc/features/feed_posts/repositories/feed_posts_repository.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RideFeedScreen extends StatefulWidget {
  const RideFeedScreen({super.key});

  @override
  State<RideFeedScreen> createState() => _RideFeedScreenState();
}

class _RideFeedScreenState extends State<RideFeedScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  late Future<List<FeedPostModel>> _postsFuture;
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _postsFuture = _repository.fetchPosts();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final isGuest = await TokenStorageService.isGuestUser();
    final token = await TokenStorageService.getAccessToken();
    if (!mounted) return;
    setState(() {
      _isGuest = isGuest || token == null || token.isEmpty;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _repository.fetchPosts();
    });
    await _postsFuture;
  }

  void _showLoginPrompt() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login required'),
        content: const Text('Please login to post or like feed updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreatePost() async {
    if (_isGuest) {
      _showLoginPrompt();
      return;
    }

    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateFeedPostScreen()),
    );

    if (created == true) {
      await _refresh();
    }
  }

  Future<void> _openMyPosts() async {
    if (_isGuest) {
      _showLoginPrompt();
      return;
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const MyFeedPostsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.softCream,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.softCream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.deepRed,
          foregroundColor: Colors.white,
          onPressed: _openCreatePost,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: _FeedHeader(
                    title: 'Ride Feed',
                    trailing: IconButton(
                      onPressed: _openMyPosts,
                      icon: const Icon(Icons.account_circle_outlined),
                      color: AppColors.deepRed,
                      tooltip: 'My posts',
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FeedHeroCard(onTap: _openCreatePost),
                ),
                FutureBuilder<List<FeedPostModel>>(
                  future: _postsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final posts = snapshot.data ?? const [];
                    if (posts.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyFeed(),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 88),
                      sliver: SliverList.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          return FeedPostCard(
                            post: posts[index],
                            isGuest: _isGuest,
                            onLoginRequired: _showLoginPrompt,
                            onChanged: _refresh,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedPostCard extends StatefulWidget {
  final FeedPostModel post;
  final bool isGuest;
  final VoidCallback onLoginRequired;
  final VoidCallback onChanged;

  const FeedPostCard({
    super.key,
    required this.post,
    required this.isGuest,
    required this.onLoginRequired,
    required this.onChanged,
  });

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  late FeedPostModel _post;
  bool _liking = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant FeedPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.likesCount != widget.post.likesCount) {
      _post = widget.post;
    }
  }

  Future<void> _toggleLike() async {
    if (widget.isGuest) {
      widget.onLoginRequired();
      return;
    }
    if (_liking) return;

    setState(() => _liking = true);
    final updated = await _repository.toggleLike(_post.id);
    if (!mounted) return;
    setState(() {
      _liking = false;
      if (updated != null) _post = updated;
    });
  }

  Future<void> _openDetail() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FeedDetailScreen(
          postId: _post.id,
          isGuest: widget.isGuest,
          onLoginRequired: widget.onLoginRequired,
        ),
      ),
    );
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openDetail,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.buttonGuest,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.fromLTRB(12, 13, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: _post),
            if (_post.image.isNotEmpty) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 245,
                  width: double.infinity,
                  child: AdaptiveImage(
                    imagePath: _post.image,
                    fit: BoxFit.cover,
                    errorWidget: const _ImageFallback(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 34, height: 34),
                  onPressed: _toggleLike,
                  icon: Icon(
                    _post.likedByMe ? Icons.favorite : Icons.favorite_border,
                    color: _post.likedByMe
                        ? AppColors.deepRed
                        : const Color(0xFF3C3C3B),
                    size: 21,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 34, height: 34),
                  onPressed: _openDetail,
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Color(0xFF3C3C3B), size: 20),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${_post.likesCount} likes',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121E3F),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              _post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedDetailScreen extends StatefulWidget {
  final String postId;
  final bool isGuest;
  final VoidCallback onLoginRequired;

  const FeedDetailScreen({
    super.key,
    required this.postId,
    required this.isGuest,
    required this.onLoginRequired,
  });

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  final TextEditingController _commentController = TextEditingController();
  late Future<FeedPostModel?> _postFuture;
  FeedPostModel? _post;
  bool _liking = false;
  bool _commenting = false;

  @override
  void initState() {
    super.initState();
    _postFuture = _loadPost();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<FeedPostModel?> _loadPost() async {
    final post = await _repository.fetchPostById(widget.postId);
    _post = post;
    return post;
  }

  Future<void> _toggleLike() async {
    if (widget.isGuest) {
      widget.onLoginRequired();
      return;
    }
    if (_liking || _post == null) return;

    setState(() => _liking = true);
    final updated = await _repository.toggleLike(_post!.id);
    if (!mounted) return;
    setState(() {
      _liking = false;
      if (updated != null) _post = updated;
    });
  }

  Future<void> _addComment() async {
    if (widget.isGuest) {
      widget.onLoginRequired();
      return;
    }
    final text = _commentController.text.trim();
    if (text.isEmpty || _post == null || _commenting) return;

    setState(() => _commenting = true);
    final updated = await _repository.addComment(postId: _post!.id, text: text);
    if (!mounted) return;
    setState(() {
      _commenting = false;
      if (updated != null) {
        _post = updated;
        _commentController.clear();
      }
    });
    if (updated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not add comment. Please try again.')),
      );
    }
  }

  Future<void> _deleteComment(FeedCommentModel comment) async {
    if (_post == null) return;
    final updated = await _repository.deleteComment(
      postId: _post!.id,
      commentId: comment.id,
    );
    if (!mounted) return;
    if (updated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not delete comment. Please try again.')),
      );
      return;
    }
    setState(() {
      _post = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: FutureBuilder<FeedPostModel?>(
          future: _postFuture,
          builder: (context, snapshot) {
            final post = _post ?? snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting &&
                post == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (post == null) {
              return const Center(child: Text('Post not found'));
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              children: [
                const _FeedHeader(title: 'Feed Detail'),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.buttonGuest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PostHeader(post: post),
                      if (post.image.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AdaptiveImage(
                            imagePath: post.image,
                            width: double.infinity,
                            height: 310,
                            fit: BoxFit.cover,
                            errorWidget: const _ImageFallback(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        post.description,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          height: 1.45,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(
                              post.likedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.likedByMe
                                  ? AppColors.deepRed
                                  : const Color(0xFF3C3C3B),
                            ),
                          ),
                          Text('${post.likesCount} likes'),
                          const SizedBox(width: 18),
                          const Icon(Icons.chat_bubble_outline, size: 20),
                          const SizedBox(width: 6),
                          Text('${post.commentsCount} comments'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _CommentComposer(
                  controller: _commentController,
                  enabled: !widget.isGuest,
                  submitting: _commenting,
                  onSubmit: _addComment,
                  onLoginRequired: widget.onLoginRequired,
                ),
                const SizedBox(height: 14),
                if (post.comments.isEmpty)
                  const Text(
                    'No comments yet.',
                    style: TextStyle(
                        fontFamily: 'Outfit', color: Color(0xFF6B7280)),
                  )
                else
                  ...post.comments.map(
                    (comment) => _CommentTile(
                      comment: comment,
                      onDelete: comment.canDeleteByMe
                          ? () => _deleteComment(comment)
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CreateFeedPostScreen extends StatefulWidget {
  const CreateFeedPostScreen({super.key});

  @override
  State<CreateFeedPostScreen> createState() => _CreateFeedPostScreenState();
}

class _CreateFeedPostScreenState extends State<CreateFeedPostScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  bool _submitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 82);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
    });
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something for your post.')),
      );
      return;
    }

    setState(() => _submitting = true);
    final ok =
        await _repository.createPost(description: description, image: _image);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not submit your post. Please try again.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post submitted'),
        content: const Text(
            'Your post has been submitted and is pending admin approval.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          children: [
            const _FeedHeader(title: 'Create Post'),
            TextField(
              controller: _descriptionController,
              minLines: 6,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Share your ride update...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_image!,
                    height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_outlined),
              label:
                  Text(_image == null ? 'Add optional image' : 'Change image'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit for approval'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFeedPostsScreen extends StatefulWidget {
  const MyFeedPostsScreen({super.key});

  @override
  State<MyFeedPostsScreen> createState() => _MyFeedPostsScreenState();
}

class _MyFeedPostsScreenState extends State<MyFeedPostsScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  late Future<List<FeedPostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _repository.fetchMyPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: FutureBuilder<List<FeedPostModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final posts = snapshot.data ?? const [];
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              itemCount: posts.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) return const _FeedHeader(title: 'My Posts');
                final post = posts[index - 1];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _StatusPill(status: post.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${post.likesCount} likes - ${_timeAgo(post.createdAt)}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _FeedHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 18,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              color: AppColors.deepRed,
            ),
          ),
          Positioned(
            top: 23,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.deepRed,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null)
            Positioned(
              right: 4,
              top: 18,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

class _FeedHeroCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FeedHeroCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 162,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/community_ride.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.deepRed.withValues(alpha: 0.9),
                        AppColors.goldenOchre.withValues(alpha: 0.76),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 34, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share your ride with the community',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Posts appear after admin approval.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final FeedPostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.goldenOchre,
          child: ClipOval(
            child: post.authorAvatar.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : AdaptiveImage(
                    imagePath: post.authorAvatar,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorWidget: const Icon(Icons.person, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C3C3B),
                ),
              ),
              Text(
                _timeAgo(post.createdAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.5,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final FeedCommentModel comment;
  final VoidCallback? onDelete;

  const _CommentTile({required this.comment, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.goldenOchre,
            child: ClipOval(
              child: comment.authorAvatar.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 17)
                  : AdaptiveImage(
                      imagePath: comment.authorAvatar,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorWidget: const Icon(Icons.person,
                          color: Colors.white, size: 17),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: Color(0xFF8A8175),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text,
                    style: const TextStyle(fontFamily: 'Outfit')),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.deepRed),
            ),
        ],
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onLoginRequired;

  const _CommentComposer({
    required this.controller,
    required this.enabled,
    required this.submitting,
    required this.onSubmit,
    required this.onLoginRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              onTap: enabled ? null : onLoginRequired,
              decoration: InputDecoration(
                hintText: enabled ? 'Write a comment...' : 'Login to comment',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed:
                submitting ? null : (enabled ? onSubmit : onLoginRequired),
            icon: submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: AppColors.deepRed),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final approved = status == 'approved';
    final rejected = status == 'rejected';
    final color = approved
        ? const Color(0xFF208A4B)
        : rejected
            ? AppColors.deepRed
            : const Color(0xFFB7791F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        approved
            ? 'Approved'
            : rejected
                ? 'Rejected'
                : 'Pending',
        style: TextStyle(
          fontFamily: 'Outfit',
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No approved posts yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF6B7280),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE6E1D8),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined,
          color: Color(0xFF8A8175)),
    );
  }
}

String _timeAgo(DateTime? dateTime) {
  if (dateTime == null) return 'Recently';
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
