import 'package:flutter/material.dart';
import 'package:thriftly_app/config/app_theme.dart';
import 'package:thriftly_app/models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  Color _getConditionColor() {
    final condition = widget.product.condition.toUpperCase();
    switch (condition) {
      case 'LIKE NEW':
      case 'BARU':
      case 'BARU (TAG)':
        return const Color(0xFF2D3436);
      case 'GOOD':
      case 'KONDISI BAIK':
        return AppTheme.primary;
      case 'RARE':
        return Colors.purple;
      case 'DEFECT':
      case 'ADA MINUS':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getConditionLabel() {
    final condition = widget.product.condition.toUpperCase();
    switch (condition) {
      case 'LIKE NEW':
        return 'LIKE NEW';
      case 'BARU':
      case 'BARU (TAG)':
        return 'BARU';
      case 'GOOD':
      case 'KONDISI BAIK':
        return 'BAIK';
      case 'ADA MINUS':
        return 'MINUS';
      default:
        return condition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            _buildImageSection(),

            // Product info
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            height: 160, // Reduced from 180
            width: double.infinity,
            color: Colors.grey.shade100,
            child: widget.product.imageUrl.isNotEmpty
                ? Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
        ),

        // Condition badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getConditionColor(),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _getConditionLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),

        // Favorite button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              // TODO: Save to favorites in database
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: _isFavorite ? Colors.red : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 50,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(10), // Reduced from 12
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand (if available)
          if (widget.product.brand.isNotEmpty) ...[
            Text(
              widget.product.brand.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
          ],

          // Product name
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMain,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Price
          Text(
            'Rp ${_formatPrice(widget.product.price)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 4),

          // Location and time
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 11,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  widget.product.location.isNotEmpty
                      ? widget.product.location
                      : 'Jakarta',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                ' • ',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
              ),
              Text(
                widget.product.timeAgo,
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
