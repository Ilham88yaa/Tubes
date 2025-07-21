class MedicalRecord {
  final String title;
  final String description;
  final String date;

  MedicalRecord({
    required this.title,
    required this.description,
    required this.date,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'date': date};
  }
}
