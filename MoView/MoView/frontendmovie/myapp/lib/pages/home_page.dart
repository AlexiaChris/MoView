import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/auth_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/genre_filter_sheet.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MovieService _service = MovieService();

  String _selectedType = '';
  String? _selectedGenre;
  String _searchQuery = '';
  List<Movie> _movies = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalResults = 0;
  bool _hasMore = true;

  static const Map<String, String> _typeFilters = {
    'All': '',
    'Movie': 'movie',
    'Series': 'series',
  };

  static const List<String> _trendingKeywords = [
    'avengers', 'inception', 'spider', 'iron man',
    'joker', 'matrix', 'interstellar', 'titanic',
    'thor', 'batman', 'harry potter', 'fast furious',
    'john wick', 'black panther', 'doctor strange',
    'mission impossible', 'transformers', 'avatar',
    'jurassic', 'star wars', 'oppenheimer', 'dune',
    'deadpool', 'guardians', 'captain america',
    'wolves', 'alien', 'predator', 'terminator',
  ];

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _movies = [];
      _currentPage = 1;
      _hasMore = true;
      _totalResults = 0;
    });

    try {
      if (_searchQuery.isNotEmpty) {
        final result = await _service.searchMovies(
          query: _searchQuery,
          type: _selectedType,
          genre: _selectedGenre ?? '',
          page: 1,
        );
        if (mounted) {
          final movies = result['results'] as List<Movie>;
          setState(() {
            _movies = movies;
            _totalResults = result['totalResults'] as int;
            _totalPages = result['totalPages'] as int;
            _hasMore = _currentPage < _totalPages;
            _isLoading = false;
          });
        }
      } else if (_selectedGenre != null) {
        final result = await _service.getMoviesByGenre(
          genre: _selectedGenre!,
          type: _selectedType,
          page: 1,
        );
        if (mounted) {
          final movies = result['results'] as List<Movie>;
          setState(() {
            _movies = movies;
            _totalResults = movies.length;
            _totalPages = 1;
            _hasMore = movies.isNotEmpty;
            _isLoading = false;
          });
        }
      } else {
        final keywords = List<String>.from(_trendingKeywords)..shuffle();
        final picked = keywords.take(4).toList();

        final futures = picked.map((kw) =>
          _service.searchMovies(query: kw, type: _selectedType)
        );

        final results = await Future.wait(futures);
        final allMovies = <Movie>[];
        for (final result in results) {
          final movies = result['results'] as List<Movie>;
          allMovies.addAll(
            movies.where((m) => m.poster.isNotEmpty && m.poster != 'N/A').take(2),
          );
        }
        allMovies.shuffle();

        if (mounted) {
          setState(() {
            _movies = allMovies;
            _totalResults = 0;
            _hasMore = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      List<Movie> newMovies = [];

      if (_searchQuery.isNotEmpty) {
        final result = await _service.searchMovies(
          query: _searchQuery,
          type: _selectedType,
          genre: _selectedGenre ?? '',
          page: _currentPage + 1,
        );
        newMovies = result['results'] as List<Movie>;
      } else if (_selectedGenre != null) {
        final result = await _service.getMoviesByGenre(
          genre: _selectedGenre!,
          type: _selectedType,
          page: _currentPage + 1,
        );
        newMovies = result['results'] as List<Movie>;
      }

      if (mounted) {
        setState(() {
          _movies.addAll(newMovies);
          _currentPage++;
          _hasMore = newMovies.isNotEmpty &&
              (_searchQuery.isNotEmpty ? _currentPage < _totalPages : true);
          _isLoadingMore = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
      _selectedGenre = null;
    });
    _loadMovies();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedGenre = null;
      _totalResults = 0;
    });
    _loadMovies();
  }

  void _openGenreFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GenreFilterSheet(
        selectedGenre: _selectedGenre,
        onApply: (genre) {
          setState(() {
            _selectedGenre = genre;
            _searchQuery = '';
            _searchController.clear();
            _totalResults = 0;
          });
          _loadMovies();
        },
      ),
    );
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _sectionTitle {
    if (_searchQuery.isNotEmpty) return 'Results for "$_searchQuery"';
    if (_selectedGenre != null) return 'Genre: $_selectedGenre';
    return 'Trending Now';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeader(),
          _buildTypeFilter(),
          if (_selectedGenre != null && _searchQuery.isEmpty)
            _buildActiveGenreBadge(),
          _buildMoviesSection(),
          if (_isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFFA600FF),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MoView',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'FrunchySage',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AuthService.isLoggedIn
                  ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') _logout();
                    },
                    color: const Color(0xFF380056),
                    offset: const Offset(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFA600FF), width: 1),
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          AuthService.username ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const PopupMenuDivider(
                        height: 8,
                        thickness: 1,
                        color: Color(0xFFa600ff),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFA600FF), 
                              size: 18
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 14
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF380056),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFA600FF), 
                          width: 1.5
                        ),
                      ),
                      child: Center(
                        child: Text(
                          (AuthService.username ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFA600FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 0.1,
                          ),
                        ),
                      ),
                    ),
                  )
                  : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      ).then((_) => setState(() {}));  //Refresh abis login
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA600FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFA600FF), 
                          width: 1.5
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.login_rounded, 
                            color: Colors.white, 
                            size: 16
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SearchBarWidget(
              controller: _searchController,
              onFilterTap: _openGenreFilter,
              onSubmitted: _onSearch,
              isFilterActive: _selectedGenre != null,
              onClear: _searchQuery.isNotEmpty ? _clearSearch : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: _typeFilters.entries.map((entry) {
            final isActive = _selectedType == entry.value;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedType = entry.value);
                _loadMovies();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFA600FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFA600FF)
                        : const Color(0xFFB1B1B1),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFFB1B1B1),
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActiveGenreBadge() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF380056),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFFA600FF), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_movies_rounded,
                      color: Color(0xFFA600FF), size: 12),
                  const SizedBox(width: 4),
                  Text(
                    _selectedGenre!,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedGenre = null);
                      _loadMovies();
                    },
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesSection() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sectionTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty && !_isLoading)
                    Text(
                      '$_totalResults results found',
                      style: const TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, __) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF380056).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
            )
          else if (_movies.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Icon(Icons.movie_filter_rounded,
                        color: Color(0xFFA600FF), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'No results for "$_searchQuery"'
                          : _selectedGenre != null
                              ? 'No movies found for "$_selectedGenre"'
                              : 'No movies found',
                      style: const TextStyle(
                          color: Color(0xFFB1B1B1), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => MovieCard(movie: _movies[i]),
                childCount: _movies.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
            ),
        ],
      ),
    );
  }
}