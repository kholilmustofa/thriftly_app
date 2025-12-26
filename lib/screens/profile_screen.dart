import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftly_app/config/app_theme.dart';
import 'package:thriftly_app/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: AppTheme.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.textMain),
            onPressed: () {
              // TODO: Share profile
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textMain),
            onPressed: () {
              // TODO: Settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          _buildProfileHeader(user),

          // Stats Section
          _buildStatsSection(),

          // Action Buttons
          _buildActionButtons(context, authService),

          const SizedBox(height: 16),

          // Tabs
          _buildTabs(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsGrid(),
                _buildProductsGrid(sold: true),
                _buildProductsGrid(liked: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.textSecondary,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Name
          Text(
            user?.displayName ?? 'Sinta Thrift',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),

          const SizedBox(height: 4),

          // Username
          Text(
            '@${user?.email?.split('@')[0] ?? 'sinta_thrift'}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 8),

          // Location & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                'Jakarta, ID',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Penjual Terpercaya',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('45', 'Terjual'),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _buildStatItem('1.2k', 'Pengikut'),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _buildStatItem('4.8', 'Rating'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Edit Profile Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Edit profile
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textMain,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Pesanan Saya Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: My orders
              },
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Pesanan Saya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primary,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: const [
          Tab(text: 'Lemari Saya'),
          Tab(text: 'Ulasan (12)'),
          Tab(text: 'Disukai'),
        ],
      ),
    );
  }

  Widget _buildProductsGrid({bool sold = false, bool liked = false}) {
    // Sample products
    final products = [
      {
        'image': 'https://via.placeholder.com/200',
        'name': 'Kemeja Linen Putih Casual',
        'size': 'Size M',
        'condition': 'Casual',
        'price': 'Rp 120.000',
        'status': 'TERJUAL',
      },
      {
        'image': 'https://via.placeholder.com/200',
        'name': 'Celana Jeans Levi\'s 501',
        'size': 'Size 32',
        'condition': 'Kondisi 10/10',
        'price': 'Rp 250.000',
        'status': null,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              // Status Badge
              if (product['status'] != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Like Button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: AppTheme.textMain,
                  ),
                ),
              ),
            ],
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product['size']} • ${product['condition']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product['price'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
