class ProductProfessional {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final int discount;
  final double workerPrice;

  ProductProfessional({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.workerPrice,
  });

  factory ProductProfessional.fromJson(Map<String, dynamic> json) {
    return ProductProfessional(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_product'],
      price: (json['price'] as num).toDouble(),
      discount: json['worker_discount'],
      workerPrice: (json['worker_price'] as num).toDouble(),
    );
  }
}
