import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';
import '../services/rating_service.dart';
import 'auth_page.dart';

class DetailPage extends StatefulWidget {
  final String imdbId;

  const DetailPage({super.key, required this.imdbId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final MovieService _movieService = MovieService();
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RatingService _ratingService = RatingService(); 


  MovieDetail? _movie;
  List<Map<String, dynamic>> _comments = [];
  Map<int, Map<String, dynamic>> _commentMap = {};
  bool _isLoading = true;
  bool _isLoadingComments = true;
  bool _isSubmitting = false;
  String? _error;

  //Reply
  int? _replyToId;
  String? _replyToUsername;

//Rating
  double? _averageRating;
  int? _ratingCount;
  int? _userRating;
  bool _isLoadingRating = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final movie = await _movieService.getMovieById(widget.imdbId);
      if (mounted) {
        setState(() { _movie = movie; _isLoading = false; });
        _loadComments();
        _loadRatings();
      }
    } 
    catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _commentService.getComments(widget.imdbId);
      if (mounted) {
        _commentMap = {};
        _buildCommentMap(comments);
        
        setState(() { 
          _comments = comments; 
          _isLoadingComments = false; 
        });
      }
    } 
    catch (_) {
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _loadRatings() async {
    try {
      final data = await _ratingService.getMovieRatings(widget.imdbId);
      if (mounted) {
        setState(() {
          _averageRating = data['average'] != null ? double.parse(data['average'].toString()) : null;
          _ratingCount = data['count'];
          _userRating = data['userRating'];
          _isLoadingRating = false;
        });
      }
    } 
    catch (_) {
      if (mounted) setState(() => _isLoadingRating = false);
    }
  }

  Future<void> _submitRating(int rating) async {
    if (!AuthService.isLoggedIn) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A0528),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Login Required',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'You need to login to rate movies. Would you like to login now?',
            style: TextStyle(color: Color(0xFFB1B1B1)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFFB1B1B1))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFA600FF)),
              child: const Text('Login'),
            ),
          ],
        ),
      );

      if (result == true && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      }
      return;
    }

    try {
      await _ratingService.addOrUpdateRating(widget.imdbId, rating);
      await _loadRatings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating submitted!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } 
    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _deleteRating() async {
    if (!AuthService.isLoggedIn) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0528),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Rating',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold
          ),
        ),
        content: const Text(
          'Are you sure you want to remove your rating?',
          style: TextStyle(color: Color(0xFFB1B1B1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFB1B1B1))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _ratingService.deleteRating(widget.imdbId);
      await _loadRatings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating removed!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  void _buildCommentMap(List<Map<String, dynamic>> comments) {
    for (var c in comments) {
      _commentMap[c['id']] = c;
      
      final replies = (c['replies'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (replies.isNotEmpty) {
        _buildCommentMap(replies);
      }
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (!AuthService.isLoggedIn) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A0528),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Login Required',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'You need to login to write reviews. Would you like to login now?',
            style: TextStyle(color: Color(0xFFB1B1B1)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel', 
                style: TextStyle(color: Color(0xFFB1B1B1))
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFA600FF)),
              child: const Text('Login'),
            ),
          ],
        ),
      );

      if (result == true && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _commentService.addComment(
        widget.imdbId, 
        text,
        parentId: _replyToId,
      );
      _commentController.clear();
      
      setState(() {
        _replyToId = null;
        _replyToUsername = null;
      });
      
      await _loadComments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_replyToId != null ? 'Reply posted!' : 'Review posted!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0528),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Comment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will also delete all replies to this comment. Continue?',
          style: TextStyle(color: Color(0xFFB1B1B1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFB1B1B1))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _commentService.deleteComment(commentId);
      await _loadComments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment deleted'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  void _setReplyTo(int commentId, String username) {
    setState(() {
      _replyToId = commentId;
      _replyToUsername = username;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyToId = null;
      _replyToUsername = null;
    });
  }

  String _timeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
      return '${(diff.inDays / 365).floor()}y ago';
    } catch (_) {
      return '';
    }
  }

  String _getParentUsername(Map<String, dynamic> comment) {
    final parentId = comment['parent_id'];
    if (parentId == null) return 'someone';
    
    final parentComment = _commentMap[parentId];
    if (parentComment != null) {
      final user = parentComment['User'] as Map<String, dynamic>?;
      return user?['username'] ?? 'someone';
    }
    
    return 'someone';

  }

  List<Map<String, dynamic>> _getAllRepliesFlat(List<Map<String, dynamic>> replies) {
    List<Map<String, dynamic>> allReplies = [];
    
    void collectReplies(List<Map<String, dynamic>> replyList) {
      for (var reply in replyList) {
        allReplies.add(reply);
        
        final nestedReplies = (reply['replies'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        if (nestedReplies.isNotEmpty) {
          collectReplies(nestedReplies);
        }
      }
    }
    
    collectReplies(replies);
    return allReplies;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFA600FF)))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final m = _movie!;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildPosterHeader(m),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${m.year} · ${m.genre.split(',').map((g) => g.trim()).join(',  ')}',
                  style: const TextStyle(color: Color(0xFFB1B1B1), fontSize: 15),
                ),
                const SizedBox(height: 24),
                _buildRatingsRow(m),
                const SizedBox(height: 24),
                const Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  m.plot,
                  style: const TextStyle(
                    color: Color(0xFFB1B1B1),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                _buildCommentsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCommentInput(),
        const SizedBox(height: 20),
        
        if (_isLoadingComments)
          const Center(
            child: CircularProgressIndicator(color: Color(0xFFA600FF)),
          )
        else if (_comments.isEmpty)
          Center(
            child: Text(
              'No reviews yet. Be the first!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) => _buildCommentItem(_comments[i], level: 0),
          ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_replyToId != null)
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA600FF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFA600FF).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.reply_rounded,
                  size: 16,
                  color: Color(0xFFA600FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Replying to $_replyToUsername',
                    style: const TextStyle(
                      color: Color(0xFFA600FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cancelReply,
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF380056),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: const Color(0xFFA600FF),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: _replyToId != null 
                        ? 'Write a reply...' 
                        : 'Add a review...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _isSubmitting ? null : _submitComment,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFFA600FF),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Color(0xFFA600FF),
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, {int level = 0}) {
    final user = comment['User'] as Map<String, dynamic>?;
    final username = user?['username'] ?? 'Unknown';
    final commentText = comment['comment'] ?? '';
    final createdAt = comment['createdAt'] ?? comment['created_at'] ?? '';
    final commentId = comment['id'];
    final userId = comment['user_id'];
    final replies = (comment['replies'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    final currentUserId = AuthService.userId;
    final isOwner = currentUserId != null && userId == currentUserId;

    final isReply = level > 0;

    return Container(
      margin: EdgeInsets.only(
        left: isReply ? 40.0 : 0,  
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF380056),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Color(0xFFA600FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _timeAgo(createdAt),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        if (isOwner)
                          InkWell(
                            onTap: () => _deleteComment(commentId),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.withOpacity(0.6),
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    if (isReply)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.reply,
                              size: 12,
                              color: const Color(0xFFA600FF).withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Replying to ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '@${_getParentUsername(comment)}',
                              style: const TextStyle(
                                color: Color(0xFFA600FF),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    Text(
                      commentText,
                      style: const TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    InkWell(
                      onTap: () => _setReplyTo(commentId, username),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.reply_rounded,
                              size: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (replies.isNotEmpty && level == 0) ...[
            const SizedBox(height: 8),
            ..._getAllRepliesFlat(replies).map((reply) => _buildCommentItem(
              reply,
              level: 1,
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPosterHeader(MovieDetail m) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 320,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (m.poster.isNotEmpty && m.poster != 'N/A')
              Image.network(
                m.poster,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderBg(),
              )
            else
              _placeholderBg(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.2), Colors.black],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded, 
                        color: Colors.white, 
                        size: 16
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Back', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 15, 
                          fontWeight: FontWeight.w500
                        )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              child: Container(
                width: 90,
                height: 124,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 16)],
                ),
                clipBehavior: Clip.hardEdge,
                child: m.poster.isNotEmpty && m.poster != 'N/A'
                    ? Image.network(m.poster, fit: BoxFit.cover)
                    : Container(
                        color: const Color(0xFF380056),
                        child: const Icon(Icons.movie_rounded, color: Color(0xFFA600FF)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsRow(MovieDetail m) {
    return Column(
      children: [
        Row(
          children: [
            _ratingBox(
              label: 'IMDb',
              value: m.imdbRating,
              icon: Icons.star_rounded,
              color: const Color(0xFFFBBF24),
            ),
            const SizedBox(width: 10),
            _ratingBox(
              label: 'Rotten Tomatoes',
              value: m.rottenTomatoesRating,
              icon: Icons.local_fire_department_rounded,
              color: const Color(0xFFEF4444),
              
            ),
          ],
        ),
        
        const SizedBox(height: 10),
        
      
        _moviewRatingBox(),
        
        const SizedBox(height: 16),
        
        _buildStarRating(),
        
      ],
    );
  }

  Widget _ratingBox({required String label, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF380056).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFA600FF).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            label == 'Rotten Tomatoes'
                ? Image.asset('assets/Rotten_Tomatoes.png', width: 20, height: 20)
                : Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value, 
                  style: TextStyle(
                    color: color, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                    )),
                Text(
                  label, 
                  style: const TextStyle(
                    color: Color(0xFFB1B1B1), 
                    fontSize: 14
                  )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0528),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA600FF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Rate this movie',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_userRating != null) ...[
                const Spacer(),
                Text(
                  'Your rating: $_userRating★',
                  style: const TextStyle(
                    color: Color(0xFFA600FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final isSelected = _userRating != null && starValue <= _userRating!;
              
              return GestureDetector(
                onTap: () => _submitRating(starValue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isSelected ? const Color(0xFFA600FF) : Colors.white.withOpacity(0.3),
                    size: 36,
                  ),
                ),
              );
            }),
          ),

          if (_userRating != null) ...[
            const SizedBox(height: 4),
            Center(
              child: TextButton.icon(
                onPressed: _deleteRating,
                label: const Text(
                  'Remove Rating',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero, 
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _moviewRatingBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF380056).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA600FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFA600FF).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFFA600FF),
              size: 20,

            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MoView Rating',
                  style: TextStyle(
                    color: Color(0xFFB1B1B1),
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 2),
                _isLoadingRating
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFA600FF),
                      ),
                    )

                  : _averageRating != null
                    ? Row(
                      children: [
                        Text(
                          _averageRating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFFA600FF),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '/5',
                          style: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '($_ratingCount ${_ratingCount == 1 ? 'rating' : 'ratings'})',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )

                  : Text(
                    'No ratings yet',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderBg() {
    return Container(
      color: const Color(0xFF380056),
      child: const Center(child: Icon(Icons.movie_rounded, color: Color(0xFFA600FF), size: 64)),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFB1B1B1), size: 48),
          const SizedBox(height: 12),
          const Text('Film tidak ditemukan', style: TextStyle(color: Color(0xFFB1B1B1), fontSize: 14)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA600FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}