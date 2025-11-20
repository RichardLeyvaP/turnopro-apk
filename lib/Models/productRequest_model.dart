class ProductRequestModel {
  final String productName;
  final int quantity;
  final double unitPrice;
  final String status;
  final String data;
  final String time;
  final String imageURL;

  ProductRequestModel({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.status,
    required this.data,
    required this.time,
    required this.imageURL
  });

  factory ProductRequestModel.fromJson(Map<String, dynamic> json) {
    return ProductRequestModel(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      data: json['data'] ?? 0,
      time: json['time'] ?? 0,
      imageURL: json['productImage'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'pendiente',
    );
  }
}