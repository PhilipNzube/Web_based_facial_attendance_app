import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String randomId;

  @HiveField(1)
  String surname;

  @HiveField(2)
  String firstname;

  @HiveField(3)
  String middlename;

  @HiveField(4)
  String presentLevel;

  @HiveField(5)
  String department;

  @HiveField(6)
  String originalPassport;

  @HiveField(7)
  String passport;

  @HiveField(8)
  String cloudinaryUrl;

  @HiveField(9)
  int status;

  @HiveField(10)
  String? schoolId;

  @HiveField(11)
  String? studentNin;

  @HiveField(12)
  String? ward;

  @HiveField(13)
  String? gender;

  @HiveField(14)
  String? dob;

  @HiveField(15)
  String? nationality;

  @HiveField(16)
  String? stateOfOrigin;

  @HiveField(17)
  String? lga;

  @HiveField(18)
  String? lgaOfEnrollment;

  @HiveField(19)
  String? communityName;

  @HiveField(20)
  String? residentialAddress;

  @HiveField(21)
  String? yearOfEnrollment;

  @HiveField(22)
  String? parentContact;

  @HiveField(23)
  String? parentOccupation;

  @HiveField(24)
  String? parentPhone;

  @HiveField(25)
  String? parentName;

  @HiveField(26)
  String? parentNin;

  @HiveField(27)
  String? bankName;

  @HiveField(28)
  String? accountNumber;

  @HiveField(29)
  String? passcode;

  @HiveField(30)
  String? createdBy;

  @HiveField(31)
  String? parentBvn;

  Student({
    required this.randomId,
    required this.surname,
    required this.firstname,
    required this.middlename,
    required this.presentLevel,
    required this.department,
    required this.originalPassport,
    required this.passport,
    required this.cloudinaryUrl,
    required this.status,
    this.schoolId,
    this.studentNin,
    this.ward,
    this.gender,
    this.dob,
    this.nationality,
    this.stateOfOrigin,
    this.lga,
    this.lgaOfEnrollment,
    this.communityName,
    this.residentialAddress,
    this.yearOfEnrollment,
    this.parentContact,
    this.parentOccupation,
    this.parentPhone,
    this.parentName,
    this.parentNin,
    this.bankName,
    this.accountNumber,
    this.passcode,
    this.createdBy,
    this.parentBvn,
  });

  Student copyWith({
    String? randomId,
    String? surname,
    String? firstname,
    String? middlename,
    String? presentLevel,
    String? department,
    String? originalPassport,
    String? passport,
    String? cloudinaryUrl,
    int? status,
    String? schoolId,
    String? studentNin,
    String? ward,
    String? gender,
    String? dob,
    String? nationality,
    String? stateOfOrigin,
    String? lga,
    String? lgaOfEnrollment,
    String? communityName,
    String? residentialAddress,
    String? yearOfEnrollment,
    String? parentContact,
    String? parentOccupation,
    String? parentPhone,
    String? parentName,
    String? parentNin,
    String? bankName,
    String? accountNumber,
    String? passcode,
    String? createdBy,
    String? parentBvn,
  }) {
    return Student(
      randomId: randomId ?? this.randomId,
      surname: surname ?? this.surname,
      firstname: firstname ?? this.firstname,
      middlename: middlename ?? this.middlename,
      presentLevel: presentLevel ?? this.presentLevel,
      department: department ?? this.department,
      originalPassport: originalPassport ?? this.originalPassport,
      passport: passport ?? this.passport,
      cloudinaryUrl: cloudinaryUrl ?? this.cloudinaryUrl,
      status: status ?? this.status,
      schoolId: schoolId ?? this.schoolId,
      studentNin: studentNin ?? this.studentNin,
      ward: ward ?? this.ward,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      nationality: nationality ?? this.nationality,
      stateOfOrigin: stateOfOrigin ?? this.stateOfOrigin,
      lga: lga ?? this.lga,
      lgaOfEnrollment: lgaOfEnrollment ?? this.lgaOfEnrollment,
      communityName: communityName ?? this.communityName,
      residentialAddress: residentialAddress ?? this.residentialAddress,
      yearOfEnrollment: yearOfEnrollment ?? this.yearOfEnrollment,
      parentContact: parentContact ?? this.parentContact,
      parentOccupation: parentOccupation ?? this.parentOccupation,
      parentPhone: parentPhone ?? this.parentPhone,
      parentName: parentName ?? this.parentName,
      parentNin: parentNin ?? this.parentNin,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      passcode: passcode ?? this.passcode,
      createdBy: createdBy ?? this.createdBy,
      parentBvn: parentBvn ?? this.parentBvn,
    );
  }
}
