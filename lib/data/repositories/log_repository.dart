class Log {
  String message;
  DateTime timestamp;

  Log({required this.message, required this.timestamp});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
