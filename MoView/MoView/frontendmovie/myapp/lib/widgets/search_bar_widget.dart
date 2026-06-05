import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSubmitted;
  final bool isFilterActive;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onFilterTap,
    required this.onSubmitted,
    this.isFilterActive = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF380056),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              cursorColor: const Color(0xFFA600FF),
              decoration: InputDecoration(
                hintText: 'Search for movies, series...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFA600FF),
                  size: 20,
                ),
                suffixIcon: onClear != null
                    ? GestureDetector(
                        onTap: onClear,
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFFA600FF),
                          size: 18,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFilterTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isFilterActive ? const Color(0xFFA600FF) : const Color(0xFF380056),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA600FF), width: 1.5),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: isFilterActive ? Colors.white : const Color(0xFFA600FF),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}