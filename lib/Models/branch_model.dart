// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class BranchModel {
  int branch_id;
  String nameBranch;

  BranchModel({
    required this.branch_id,
    required this.nameBranch,
  });

  Map<String, dynamic> toMap() {
    return {
      'branch_id': branch_id,
      'nameBranch': nameBranch,
    };
  }

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      branch_id: map['branch_id'] ?? 0,
      nameBranch: map['nameBranch'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchModel.fromJson(String source) =>
      BranchModel.fromMap(json.decode(source));
}
