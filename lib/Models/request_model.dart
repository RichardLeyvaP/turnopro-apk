class RequestModel {
  final int id;
  final String date;
  final int amount;
  final String status;
  final bool paid;
  final String? type;
  final String time;
  final String name;

  RequestModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.paid,
    required this.time,
    required this.name,
    this.type,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      date: json['data'] ?? '',
      amount: json['amount'],
      status: json['status'],
      time: json['time'],
      paid: json['paid'] == 1,
      type: json['type'],
      name: json['user_name'],
    );
  }
}
