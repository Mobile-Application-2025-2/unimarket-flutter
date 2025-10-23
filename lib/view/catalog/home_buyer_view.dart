import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/catalog/home_buyer_viewmodel.dart';

class HomeBuyerView extends StatelessWidget {
  const HomeBuyerView({super.key});

  static const _brandYellow = Color(0xFFFFC107);
  static const _chipRadius = 22.0;
  static const _cardRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBuyerViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (viewModel.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.refreshData(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildContent(context, viewModel);
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeBuyerViewModel viewModel) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const Text('🛒', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              'UniMarket',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          _AppBarIcon(icon: Icons.local_shipping_outlined, tooltip: 'Domicilio'),
          _AppBarIcon(icon: Icons.favorite_border, tooltip: 'Favoritos'),
          SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.refreshData(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            _SearchBar(
              onChanged: (value) => viewModel.setSearchQuery(value),
              initialValue: viewModel.searchQuery,
            ),
            const SizedBox(height: 12),
            _CategoryChipsRow(
              categories: viewModel.categoryTypes,
              selectedCategory: viewModel.selectedCategory,
              onCategorySelected: (category) => viewModel.selectCategory(category),
            ),
            const SizedBox(height: 12),
            const _SubfiltersRow(),
            const SizedBox(height: 12),
            ...viewModel.ventureCards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _VentureCard(
                imageUrl: card.imageUrl,
                title: card.title,
                subtitle: card.subtitle,
                rating: card.rating,
                comments: card.comments,
                isFavorite: card.isFavorite,
              ),
            )),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _brandYellow,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 6),
                color: Color(0x33000000),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _BottomItem(icon: Icons.home_filled, selected: true),
              _BottomItem(icon: Icons.search),
              _BottomItem(icon: Icons.chat_bubble_outline),
              _BottomItem(icon: Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }
}

/// ======= AppBar iconito =======
class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({required this.icon, required this.tooltip});
  final IconData icon;
  final String tooltip;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      tooltip: tooltip,
      icon: Icon(icon),
    );
  }
}

/// ======= Search =======
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.onChanged,
    required this.initialValue,
  });
  
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        hintText: 'Buscar en UniMarket',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// ======= Filtros principales (fila de chips) =======
class _CategoryChipsRow extends StatelessWidget {
  const _CategoryChipsRow({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  static const _brandYellow = HomeBuyerView._brandYellow;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final label in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onCategorySelected(label),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: label == selectedCategory ? _brandYellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(HomeBuyerView._chipRadius),
                    border: Border.all(
                      color: label == selectedCategory ? _brandYellow : const Color(0xFFE0E0E0),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      label,
                      style: text.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: label == selectedCategory ? Colors.black : const Color(0xFF555555),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ======= Subfiltros (iconitos con texto) =======
class _SubfiltersRow extends StatelessWidget {
  const _SubfiltersRow();

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall;

    final items = <(IconData, String)>[
      (Icons.local_pizza, 'Pizza'),
      (Icons.set_meal, 'Carne'),
      (Icons.ramen_dining, 'Sushi'),
      (Icons.rice_bowl, 'Pasta'),
      (Icons.shopping_bag, 'Útiles'),
      (Icons.calculate, 'Tutorías'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (icon, label) in items)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          offset: Offset(0, 2),
                          color: Color(0x14000000),
                        ),
                      ],
                    ),
                    child: Icon(icon),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: small),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// ======= Card de emprendimiento =======
class _VentureCard extends StatelessWidget {
  const _VentureCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.comments,
    required this.isFavorite,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final double rating;
  final int comments;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(HomeBuyerView._cardRadius);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: radius,
          border: Border.all(color: const Color(0xFFE6B800), width: 1.2), // borde ámbar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen superior
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: radius.topLeft,
                topRight: radius.topRight,
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título + favorito
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: const Color(0xFF666666)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // rating + comentarios
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Color(0xFFFFC107)),
                      const SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      const Icon(Icons.mode_comment_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('$comments'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======= Bottom nav visual =======
class _BottomItem extends StatelessWidget {
  const _BottomItem({required this.icon, this.selected = false});
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: selected ? Colors.black : Colors.black87,
      size: selected ? 28 : 26,
    );
  }
}
