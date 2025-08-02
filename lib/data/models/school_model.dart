class School {
  final String id;
  final String schoolName;
  final String? schoolCategory;
  final String? schoolType;
  final String? lga;

  School(
      {this.schoolCategory,
      this.schoolType,
      this.lga,
      required this.id,
      required this.schoolName});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id']['\$oid'],
      schoolName: json['schoolName'],
      schoolCategory: json['schoolCategory'],
      schoolType: json['schoolType'],
      lga: json['LGA'],
    );
  }
}
