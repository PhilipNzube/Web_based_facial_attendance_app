class LGA {
  String name;
  List<String> wards;

  LGA({required this.name, required this.wards});

  factory LGA.fromJson(Map<String, dynamic> json) {
    return LGA(
      name:
          json['lga'].toString().toUpperCase(), // Convert LGA name to uppercase
      wards: (json['wards'] as List<dynamic>)
          .map((ward) =>
              ward.toString().toUpperCase()) // Convert each ward to uppercase
          .toList(),
    );
  }
}
