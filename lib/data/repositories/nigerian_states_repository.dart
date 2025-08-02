import '../repositories/lga_repository.dart';

class NigerianStates {
  String name;
  List<LGA> lgas;

  NigerianStates({required this.name, required this.lgas});

  factory NigerianStates.fromJson(Map<String, dynamic> json) {
    final lgas = (json['lgas'] as List<dynamic>)
        .map((lga) => LGA.fromJson(lga))
        .toList()
        .cast<LGA>();

    return NigerianStates(
      name: json['state']
          .toString()
          .toUpperCase(), // Convert state name to uppercase
      lgas: lgas,
    );
  }
}
