class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final String condition; // LIKE NEW, GOOD, RARE, DEFECT
  final String category; // Atasan, Celana, Jaket, Sepatu
  final String imageUrl;
  final String timeAgo;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.condition,
    required this.category,
    required this.imageUrl,
    required this.timeAgo,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      description: json['description'],
      price: json['price'].toDouble(),
      condition: json['condition'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      timeAgo: json['timeAgo'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'price': price,
      'condition': condition,
      'category': category,
      'imageUrl': imageUrl,
      'timeAgo': timeAgo,
      'isFavorite': isFavorite,
    };
  }

  // Sample data for demonstration
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Jaket Denim 90s',
        brand: 'Levi\'s',
        description:
            'Jaket denim vintage dari era 90an dalam kondisi sangat baik',
        price: 250000,
        condition: 'LIKE NEW',
        category: 'Jaket',
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5',
        timeAgo: '2 jam lalu',
      ),
      Product(
        id: '2',
        name: 'Vintage Nike Tee',
        brand: 'Nike',
        description: 'Kaos Nike vintage dengan logo klasik',
        price: 125000,
        condition: 'GOOD',
        category: 'Atasan',
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
        timeAgo: '5 jam lalu',
      ),
      Product(
        id: '3',
        name: 'Knit Sweater Wool',
        brand: 'Ralph Lauren',
        description: 'Sweater wool berkualitas tinggi, rare item',
        price: 350000,
        condition: 'RARE',
        category: 'Atasan',
        imageUrl:
            'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633',
        timeAgo: '1 hari lalu',
      ),
      Product(
        id: '4',
        name: 'Boots Leather 1460',
        brand: 'Doc Martens',
        description: 'Boots kulit dengan sedikit cacat di bagian sol',
        price: 600000,
        condition: 'DEFECT',
        category: 'Sepatu',
        imageUrl:
            'https://images.unsplash.com/photo-1608256246200-53e635b5b65f',
        timeAgo: '2 hari lalu',
      ),
    ];
  }
}
