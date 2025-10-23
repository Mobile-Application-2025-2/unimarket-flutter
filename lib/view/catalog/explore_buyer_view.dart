import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/catalog/explore_buyer_viewmodel.dart';
import '../../../data/models/category.dart' as data;
import '../../../view/catalog/home_deliver_view.dart';

class ExploreBuyerView extends StatelessWidget {
  const ExploreBuyerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ExploreBuyerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC436)),
              ),
            );
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.refresh(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return _buildContent(context, viewModel);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ExploreBuyerViewModel viewModel,
  ) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Logo/Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC436),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),

                // Title
                const Text(
                  'Explorar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const Spacer(),

                // Icons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.local_shipping,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                onChanged: (value) => viewModel.setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Buscar en UniMarket',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                  suffixIcon: viewModel.searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () => viewModel.setSearchQuery(''),
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Suggested for you
          _buildSuggestions(context, viewModel),

          const SizedBox(height: 16),

          _buildCategoriesFilter(viewModel),

          const SizedBox(height: 16),

          _buildProductsGrid(viewModel),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, ExploreBuyerViewModel viewModel) {
    final brandYellow = const Color(0xFFFFC436);

    if (viewModel.loadingSuggestions) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Cargando sugerencias...'),
              ],
            ),
          ),
        ),
      );
    }

    if (viewModel.errorSuggestions != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          viewModel.errorSuggestions!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (viewModel.suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: brandYellow.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Suggested for you',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final s = viewModel.suggestions[i];
                    return InkWell(
                      onTap: () => viewModel.selectCategoryType(s.type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: brandYellow.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: brandYellow, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer_rounded,
                                size: 16, color: brandYellow),
                            const SizedBox(width: 6),
                            Text(
                              '${s.type} • ${s.totalSelections}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC436),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HomeDeliverView()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white, size: 24),
          ),

          // Search (Selected)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 24),
          ),

          // Cart
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag, color: Colors.white, size: 24),
          ),

          // Profile
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter(ExploreBuyerViewModel viewModel) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: viewModel.categoryTypes.length,
        itemBuilder: (context, index) {
          final categoryType = viewModel.categoryTypes[index];
          final isSelected = categoryType == viewModel.selectedCategoryType;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => viewModel.selectCategoryType(categoryType),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFC436) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFC436)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForType(categoryType),
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categoryType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(ExploreBuyerViewModel viewModel) {
    if (viewModel.filteredCategories.isEmpty) {
      String message = viewModel.searchQuery.isNotEmpty
          ? 'No se encontraron resultados para "${viewModel.searchQuery}"'
          : 'No hay categorías disponibles';

      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                viewModel.searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.category_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (viewModel.searchQuery.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => viewModel.setSearchQuery(''),
                  child: const Text(
                    'Limpiar búsqueda',
                    style: TextStyle(
                      color: Color(0xFFFFC436),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: viewModel.filteredCategories.length,
          itemBuilder: (context, index) {
            final category = viewModel.filteredCategories[index];
            return _buildCategoryCard(category, viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    data.Category category,
    ExploreBuyerViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement category selection logic if needed
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColorForType(category.type),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _getIconForType(category.type),
                        size: 40,
                        color: Colors.grey[600],
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFC436),
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Title and selection count
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _truncateText(category.name, 20),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.selectionCount} selecciones',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'tutoria':
        return Icons.school;
      case 'papeleria':
        return Icons.content_cut;
      case 'comida':
        return Icons.restaurant;
      case 'emprendimiento':
        return Icons.store;
      case 'todos':
        return Icons.shopping_bag;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getBackgroundColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'tutoria':
        return const Color(0xFFFFF9C4); // Light yellow
      case 'papeleria':
        return const Color(0xFFE8F5E8); // Light green
      case 'comida':
        return const Color(0xFFFFE4E1); // Light pink
      case 'emprendimiento':
        return const Color(0xFFF3E5F5); // Light purple
      default:
        return const Color(0xFFE3F2FD); // Light blue
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
