import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thriftly_app/models/product_model.dart';

/// Firestore service untuk handle semua operasi CRUD products
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _productsRef => _firestore.collection('products');
  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _ordersRef => _firestore.collection('orders');

  /// Get all products (with optional filters)
  Stream<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    int limit = 20,
  }) {
    // Only order by createdAt to avoid composite index requirement
    // Category filtering will be done client-side
    Query query = _productsRef.orderBy('createdAt', descending: true);

    // Limit results (get more if filtering by category)
    query = query.limit(
      category != null && category.isNotEmpty ? limit * 3 : limit,
    );

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Add document ID to data
            data['id'] = doc.id;
            return ProductModel.fromFirestore(data);
          })
          .where((product) {
            // Filter by category (client-side)
            if (category != null && category.isNotEmpty) {
              if (product.category != category) {
                return false;
              }
            }

            // Filter by search query (client-side)
            if (searchQuery != null && searchQuery.isNotEmpty) {
              return product.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  product.description.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
            }
            return true;
          })
          .take(limit) // Limit after filtering
          .toList();
    });
  }

  /// Get single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _productsRef.doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Error mengambil data produk: $e';
    }
  }

  /// Get products by seller
  Stream<List<ProductModel>> getProductsBySeller(String sellerId) {
    return _productsRef
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => ProductModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  /// Create new product
  Future<String> createProduct(ProductModel product) async {
    try {
      final docRef = await _productsRef.add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      throw 'Gagal menambahkan produk: $e';
    }
  }

  /// Update existing product
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      await _productsRef.doc(productId).update(product.toFirestore());
    } catch (e) {
      throw 'Gagal mengupdate produk: $e';
    }
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsRef.doc(productId).delete();
    } catch (e) {
      throw 'Gagal menghapus produk: $e';
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw 'Error mengambil data user: $e';
    }
  }

  /// Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _usersRef.doc(userId).update(data);
    } catch (e) {
      throw 'Gagal mengupdate data user: $e';
    }
  }

  /// Create order
  Future<String> createOrder(Map<String, dynamic> orderData) async {
    try {
      final docRef = await _ordersRef.add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      return docRef.id;
    } catch (e) {
      throw 'Gagal membuat order: $e';
    }
  }

  /// Get orders by user
  Stream<List<Map<String, dynamic>>> getOrdersByUser(String userId) {
    return _ordersRef
        .where('buyerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();
        });
  }

  /// Get orders by seller
  Stream<List<Map<String, dynamic>>> getOrdersBySeller(String sellerId) {
    return _ordersRef
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();
        });
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _ordersRef.doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Gagal mengupdate status order: $e';
    }
  }

  /// Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a simple implementation. For better search, consider:
      // - Algolia
      // - ElasticSearch
      // - Cloud Functions with search indexing

      final snapshot = await _productsRef.get();

      return snapshot.docs
          .map(
            (doc) =>
                ProductModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .where((product) {
            final searchLower = query.toLowerCase();
            return product.name.toLowerCase().contains(searchLower) ||
                product.description.toLowerCase().contains(searchLower) ||
                product.category.toLowerCase().contains(searchLower);
          })
          .toList();
    } catch (e) {
      throw 'Error mencari produk: $e';
    }
  }
}
