import 'dart:convert'; // Import the dart:convert library

class PaymentModel {
  final int id;
  final int branchId;
  final int professionalId;
  final String date;
  final String type;
  final double amount;

  PaymentModel({
    required this.id,
    required this.branchId,
    required this.professionalId,
    required this.date,
    required this.type,
    required this.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      branchId: int.tryParse(json['branch_id'] ?? '0') ?? 0,
      professionalId: int.tryParse(json['professional_id'] ?? '0') ?? 0,
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      amount: double.tryParse(json['amount'] ?? '0.0') ?? 0.0,
    );
  }

  static List<PaymentModel> listFromJson(String jsonString) {
    final List<dynamic> parsed =
        json.decode(jsonString); // Use json.decode here
    return parsed.map((json) => PaymentModel.fromJson(json)).toList();
  }
}
