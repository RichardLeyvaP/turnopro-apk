import 'dart:convert';

class ClockModel {
  int clock;
  int timeClock;
  int detached;
  int attended;

  ClockModel({
    required this.clock,
    required this.timeClock,
    required this.detached,
    required this.attended,
  });

  Map<String, dynamic> toMap() {
    return {
      'clock': clock,
      'timeClock': timeClock,
      'detached': detached,
      'attended': attended,
    };
  }

  factory ClockModel.fromMap(Map<String, dynamic> map) {
    return ClockModel(
      clock: map['clock'] ?? 0,
      timeClock: map['timeClock'] ?? 0,
      detached: map['detached'] ?? 0,
      attended: map['attended'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClockModel.fromJson(String source) =>
      ClockModel.fromMap(json.decode(source));
}

class TailsResponse {
  List<ClockModel> tails;

  TailsResponse({
    required this.tails,
  });

  Map<String, dynamic> toMap() {
    return {
      'tails': tails.map((x) => x.toMap()).toList(),
    };
  }

  factory TailsResponse.fromMap(Map<String, dynamic> map) {
    return TailsResponse(
      tails: List<ClockModel>.from(
          map['tails']?.map((x) => ClockModel.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory TailsResponse.fromJson(String source) =>
      TailsResponse.fromMap(json.decode(source));
}
