import 'package:flutter/material.dart';

class GenreFilterSheet extends StatelessWidget {
  final String? selectedGenre;
  final ValueChanged<String?> onApply;

  const GenreFilterSheet({
    super.key,
    this.selectedGenre,
    required this.onApply,
  });

  static const List<String> genres = [
    'Action', 'Adventure', 'Animation', 'Biography',
    'Comedy', 'Crime', 'Documentary', 'Drama',
    'Fantasy', 'Horror', 'Musical', 'Mystery',
    'Romance', 'Sci-Fi', 'Thriller',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Color(0xFF380056),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
            color: Color(0xFFA600FF),
            width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Filter by Genre',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip(context, null),
              ...genres.map((genre) => _buildChip(context, genre)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String? genre) {
    final isSelected = selectedGenre == genre;
    final label = genre ?? 'All';

    return GestureDetector(
      onTap: () {
        onApply(genre);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFF67447A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFFB1B1B1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFB1B1B1),
            fontSize: 12,
            height: 1.2,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}