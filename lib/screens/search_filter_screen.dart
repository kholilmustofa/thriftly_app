import 'package:flutter/material.dart';
import 'package:thriftly_app/config/app_theme.dart';
import 'package:thriftly_app/models/product.dart';
import 'package:thriftly_app/widgets/product_card.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Product> _allProducts = Product.getSampleProducts();
  List<Product> _filteredProducts = [];

  // Filter states
  String _selectedCategory = 'Semua';
  RangeValues _priceRange = const RangeValues(0, 1000000);
  String _selectedCondition = 'Semua';
  bool _showFilters = false;

  final List<String> _categories = [
    'Semua',
    'Atasan',
    'Celana',
    'Jaket',
    'Sepatu',
    'Tas',
    'Aksesoris',
  ];

  final List<String> _conditions = [
    'Semua',
    'Baru',
    'Seperti Baru',
    'Baik',
    'Layak',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        // Search filter
        final searchMatch =
            _searchController.text.isEmpty ||
            product.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        // Category filter
        final categoryMatch =
            _selectedCategory == 'Semua' ||
            product.category == _selectedCategory;

        // Price filter
        final priceMatch =
            product.price >= _priceRange.start &&
            product.price <= _priceRange.end;

        // Condition filter (for now just match all since Product doesn't have condition)
        final conditionMatch = _selectedCondition == 'Semua';

        return searchMatch && categoryMatch && priceMatch && conditionMatch;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Semua';
      _priceRange = const RangeValues(0, 1000000);
      _selectedCondition = 'Semua';
      _filteredProducts = _allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cari & Filter',
          style: TextStyle(
            color: AppTheme.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: AppTheme.primary,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Filter panel (collapsible)
          if (_showFilters) _buildFilterPanel(),

          // Results count
          _buildResultsHeader(),

          // Products grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.textMain,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          hintStyle: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) => _applyFilters(),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category filter
          const Text(
            'Kategori',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                    _applyFilters();
                  });
                },
                backgroundColor: AppTheme.surfaceLight,
                selectedColor: AppTheme.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Price range
          const Text(
            'Harga',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${_priceRange.start.toInt()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'Rp ${_priceRange.end.toInt()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000000,
            divisions: 100,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.primary.withValues(alpha: 0.2),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
            onChangeEnd: (values) {
              _applyFilters();
            },
          ),
          const SizedBox(height: 8),

          // Condition filter
          const Text(
            'Kondisi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _conditions.map((condition) {
              final isSelected = _selectedCondition == condition;
              return ChoiceChip(
                label: Text(condition),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCondition = condition;
                    _applyFilters();
                  });
                },
                backgroundColor: AppTheme.surfaceLight,
                selectedColor: AppTheme.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredProducts.length} produk ditemukan',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          // Sort button (placeholder)
          TextButton.icon(
            onPressed: () {
              // TODO: Implement sort
            },
            icon: const Icon(Icons.sort, size: 18, color: AppTheme.primary),
            label: const Text(
              'Urutkan',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(product: _filteredProducts[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain atau ubah filter',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.backgroundDark,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Reset Filter',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
