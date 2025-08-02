import '../repositories/log_repository.dart';

class Registrar {
  String email;
  String password;
  String fullName;
  String lga;
  String gender;
  String phone;
  String passport;
  String address;
  String bankName;
  String bvn;
  String nin;
  int accountNumber;
  bool isActive;
  int randomId;
  DateTime lastLogged;
  List<String> roles;
  List<Log> logs;
  Map<String, dynamic> other;

  Registrar({
    required this.email,
    required this.password,
    required this.fullName,
    required this.lga,
    required this.gender,
    required this.phone,
    required this.passport,
    required this.address,
    required this.bankName,
    required this.bvn,
    required this.nin,
    required this.accountNumber,
    required this.isActive,
    required this.randomId,
    required this.lastLogged,
    required this.roles,
    required this.logs,
    required this.other,
  });

  factory Registrar.fromJson(Map<String, dynamic> json) {
    return Registrar(
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      lga: json['lga'],
      gender: json['gender'],
      phone: json['phone'],
      passport: json['passport'],
      address: json['address'],
      bankName: json['bankName'],
      bvn: json['bvn'],
      nin: json['nin'],
      accountNumber: json['accountNumber'],
      isActive: json['isActive'],
      randomId: json['randomId'],
      lastLogged: DateTime.parse(json['lastLogged']),
      roles: json['roles'].cast<String>(),
      logs: json['logs'].map<Log>((log) => Log.fromJson(log)).toList(),
      other: json['other'],
    );
  }
}
