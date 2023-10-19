// import 'dart:convert';

// class CustomerModel {
//   int id;
//   String nameClient;
//   String services;

//   CustomerModel({
//     required this.id,
//     required this.nameClient,
//     required this.services,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'nameClient': nameClient,
//       'username': services,
//     };
//   }

//   factory CustomerModel.fromMap(Map<String, dynamic> map) {
//     return CustomerModel(
//       id: map['id'] ?? '',
//       nameClient: map['nameClient'] ?? '',
//       services: map['username'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory CustomerModel.fromJson(String source) =>
//       CustomerModel.fromMap(json.decode(source));
// }

import 'dart:convert';

class CustomerModel {
  int id;
  String name;
  String username;

  CustomerModel({
    required this.id,
    required this.name,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));
}
