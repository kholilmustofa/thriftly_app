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

  // Filter states
  String _selectedCategory = 'Semua';
  RangeValues _priceRange = const RangeValues(50000, 850000);
  String? _selectedSize;
  String? _selectedCondition;
  String? _selectedColor;

  // Expandable sections
  bool _isPriceExpanded = true;
  bool _isSizeExpanded = false;
  bool _isConditionExpanded = false;
  bool _isColorExpanded = false;

  final List<Product> _allProducts = Product.getSampleProducts();
  List<Product> _filteredProducts = [];
  int _activeFiltersCount = 0;

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
        // Category filter
        if (_selectedCategory != 'Semua') {
          // TODO: Add category matching logic
        }

        // Price filter
        if (product.price < _priceRange.start ||
            product.price > _priceRange.end) {
          return false;
        }

        // Search query
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          if (!product.name.toLowerCase().contains(query) &&
              !product.brand.toLowerCase().contains(query)) {
            return false;
          }
        }

        return true;
      }).toList();

      // Count active filters
      _activeFiltersCount = 0;
      if (_selectedCategory != 'Semua') _activeFiltersCount++;
      if (_selectedSize != null) _activeFiltersCount++;
      if (_selectedCondition != null) _activeFiltersCount++;
      if (_selectedColor != null) _activeFiltersCount++;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Semua';
      _priceRange = const RangeValues(50000, 850000);
      _selectedSize = null;
      _selectedCondition = null;
      _selectedColor = null;
      _activeFiltersCount = 0;
      _filteredProducts = _allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pencarian',
          style: TextStyle(
            color: AppTheme.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Category Chips
          _buildCategoryChips(),

          // Filter Section Header
          _buildFilterHeader(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Panels
                  _buildFilterPanels(),

                  const SizedBox(height: 16),

                  // Recommendations Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Rekomendasi untukmu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Products Grid
                  _buildProductsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _applyFilters(),
        decoration: InputDecoration(
          hintText: 'Cari kaos vintage, jaket...',
          hintStyle: TextStyle(
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune, color: AppTheme.textSecondary),
            onPressed: () {
              // Toggle filter panel
            },
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['Semua', 'Pria', 'Wanita', 'Obral'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                  _applyFilters();
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textMain,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primary : Colors.grey.shade300,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Lanjutan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          TextButton(
            onPressed: _resetFilters,
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
    );
  }

  Widget _buildFilterPanels() {
    return Column(
      children: [
        // Price Range
        _buildExpandableFilter(
          title: 'Rentang Harga',
          icon: Icons.attach_money,
          isExpanded: _isPriceExpanded,
          onTap: () => setState(() => _isPriceExpanded = !_isPriceExpanded),
          child: _buildPriceRangeFilter(),
        ),

        // Size
        _buildExpandableFilter(
          title: 'Ukuran',
          icon: Icons.straighten,
          isExpanded: _isSizeExpanded,
          onTap: () => setState(() => _isSizeExpanded = !_isSizeExpanded),
          child: _buildSizeFilter(),
        ),

        // Condition
        _buildExpandableFilter(
          title: 'Kondisi',
          icon: Icons.verified_outlined,
          isExpanded: _isConditionExpanded,
          onTap: () =>
              setState(() => _isConditionExpanded = !_isConditionExpanded),
          child: _buildConditionFilter(),
        ),

        // Color
        _buildExpandableFilter(
          title: 'Warna',
          icon: Icons.palette_outlined,
          isExpanded: _isColorExpanded,
          onTap: () => setState(() => _isColorExpanded = !_isColorExpanded),
          child: _buildColorFilter(),
        ),
      ],
    );
  }

  Widget _buildExpandableFilter({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppTheme.textSecondary),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMain,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.all(16), child: child),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${(_priceRange.start / 1000).toInt()}rb',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Rp ${(_priceRange.end / 1000).toInt()}rb ~ Rp ${(850000 / 1000).toInt()}rb',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Rp 2jt+',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          min: 50000,
          max: 2000000,
          divisions: 39,
          activeColor: AppTheme.primary,
          inactiveColor: Colors.grey.shade300,
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
          onChangeEnd: (values) {
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildSizeFilter() {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((size) {
        final isSelected = _selectedSize == size;
        return ChoiceChip(
          label: Text(size),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedSize = selected ? size : null;
              _applyFilters();
            });
          },
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppTheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConditionFilter() {
    final conditions = ['Baru', 'Like New', 'Baik', 'Ada Minus'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: conditions.map((condition) {
        final isSelected = _selectedCondition == condition;
        return ChoiceChip(
          label: Text(condition),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCondition = selected ? condition : null;
              _applyFilters();
            });
          },
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppTheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMain,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorFilter() {
    final colors = [
      {'name': 'Hitam', 'color': Colors.black},
      {'name': 'Putih', 'color': Colors.white},
      {'name': 'Merah', 'color': Colors.red},
      {'name': 'Biru', 'color': Colors.blue},
      {'name': 'Hijau', 'color': Colors.green},
      {'name': 'Kuning', 'color': Colors.yellow},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((colorData) {
        final isSelected = _selectedColor == colorData['name'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = isSelected ? null : colorData['name'] as String;
              _applyFilters();
            });
          },
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorData['color'] as Color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                colorData['name'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.60,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _filteredProducts[index]);
        },
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // Apply filters and close
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              _activeFiltersCount > 0
                  ? 'Terapkan Filter ($_activeFiltersCount)'
                  : 'Terapkan Filter',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
