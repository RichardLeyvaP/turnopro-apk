import 'package:turnopro_apk/Models/productRequest_model.dart';
import 'package:turnopro_apk/Models/request_model.dart';

class CombinedDataResponse {
  final List<RequestModel> requests;
  final List<ProductRequestModel> productRequests;
  final int professionalEarnings;
  final int availableCash;
  final int totalNeto;
  final Totals totals;

  CombinedDataResponse({
    required this.requests,
    required this.productRequests,
    required this.professionalEarnings,
    required this.availableCash,
    required this.totalNeto,
    required this.totals,
  });

  factory CombinedDataResponse.fromJson(Map<String, dynamic> json) {
    return CombinedDataResponse(
      requests: (json['data'] as List)
          .map((e) => RequestModel.fromJson(e))
          .toList(),

      productRequests: (json['products'] as List)
          .map((e) => ProductRequestModel.fromJson(e))
          .toList(),
      professionalEarnings: json['professionalEarnings'] ?? 0,
      availableCash: json['availableCash'] ?? 0,
      totalNeto: json['totalNeto'] ?? 0,
      totals: Totals.fromJson(json['totals'] ?? {}),
    );
  }

}

class Totals {
  final int totalAdvance;
  final int totalProduct;
  final int totalPayments;
  final int totalProductPrev;


  Totals({
    required this.totalAdvance,
    required this.totalProduct,
    required this.totalPayments,
    required this.totalProductPrev,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalAdvance: json['totalAdvance'] ?? 0,
      totalProduct: json['totalProduct'] ?? 0,
      totalPayments: json['totalPayments'] ?? 0,
      totalProductPrev: json['totalProductPrev'] ?? 0,
    );
  }
}
