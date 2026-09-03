import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../product/product_listing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _recentSearches = [
    'MacBook Pro M3',
    'Gaming laptop RTX 4080',
    'Dell XPS 13',
    'Thunderbolt dock',
  ];

  final List<_Suggestion> _trending = [
    _Suggestion(icon: Icons.laptop_mac_outlined, label: 'Laptops'),
    _Suggestion(icon: Icons.sports_esports_outlined, label: 'Gaming'),
    _Suggestion(icon: Icons.business_center_outlined, label: 'Business'),
    _Suggestion(icon: Icons.memory_outlined, label: 'Workstations'),
    _Suggestion(icon: Icons.headphones_outlined, label: 'Accessories'),
    _Suggestion(icon: Icons.star_outline, label: 'Top Rated'),
  ];

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit([String? override]) {
    final q = (override ?? _controller.text).trim();
    if (q.isEmpty) return;
    setState(() {
      _recentSearches.remove(q);
      _recentSearches.insert(0, q);
      if (_recentSearches.length > 6) _recentSearches.removeLast();
    });
    _focusNode.unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductListingScreen(initialQuery: q)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = responsiveHPadding(screenWidth);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Container(
              color: AppColors.navForeground,
              padding: EdgeInsets.fromLTRB(8, 8, hPad, 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Row(
                    children: [
                      if (Navigator.of(context).canPop())
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.primaryFixedDim),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      else
                        const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            onChanged: (v) => setState(() => _query = v),
                            onSubmitted: _submit,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Search laptops, specs, brands…',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.outline),
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.outline, size: 20),
                              suffixIcon: _query.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close,
                                          color: AppColors.outline, size: 18),
                                      onPressed: () {
                                        _controller.clear();
                                        setState(() => _query = '');
                                      },
                                    )
                                  : null,
                              filled: false,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _submit(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryFixedDim,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: const Text('Search',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_query.isEmpty && _recentSearches.isNotEmpty) ...[
                          _SectionHeader(
                            title: 'Recent',
                            action: TextButton(
                              onPressed: () =>
                                  setState(() => _recentSearches.clear()),
                              child: const Text('Clear all'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._recentSearches.map((term) => _RecentTile(
                                term: term,
                                onTap: () {
                                  _controller.text = term;
                                  setState(() => _query = term);
                                  _submit(term);
                                },
                                onRemove: () => setState(
                                    () => _recentSearches.remove(term)),
                              )),
                          const SizedBox(height: 32),
                        ],

                        _SectionHeader(title: 'Browse by Category'),
                        const SizedBox(height: 16),
                        // Responsive category chips — Wrap naturally reflows
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _trending
                              .map((s) => _TrendingChip(
                                    suggestion: s,
                                    onTap: () => _submit(s.label),
                                  ))
                              .toList(),
                        ),

                        if (_query.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          _SectionHeader(title: 'Suggestions'),
                          const SizedBox(height: 8),
                          ..._buildSuggestions(_query),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSuggestions(String q) {
    final lower = q.toLowerCase();
    final matches = <String>{
      ..._trending
          .map((s) => s.label)
          .where((l) => l.toLowerCase().contains(lower)),
      ..._recentSearches.where((r) => r.toLowerCase().contains(lower)),
    };
    if (matches.isEmpty) {
      return [_RecentTile(term: q, icon: Icons.search, onTap: () => _submit(q))];
    }
    return matches
        .map((m) => _RecentTile(
              term: m,
              icon: Icons.search,
              onTap: () => _submit(m),
            ))
        .toList();
  }
}

// ── Small composable widgets ─────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (action != null) action!,
      ],
    );
  }
}

class _RecentTile extends StatelessWidget {
  final String term;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _RecentTile({
    required this.term,
    this.icon = Icons.history,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Text(term,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.onSurface)),
            ),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close,
                    size: 16, color: AppColors.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final _Suggestion suggestion;
  final VoidCallback onTap;
  const _TrendingChip({required this.suggestion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(suggestion.icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              suggestion.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Suggestion {
  final IconData icon;
  final String label;
  const _Suggestion({required this.icon, required this.label});
}
