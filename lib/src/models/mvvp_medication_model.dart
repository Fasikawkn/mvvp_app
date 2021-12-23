class Medication {
  final String name;
  final String dose;
  final String strength;

  Medication({
    required this.name,
    required this.dose,
    required this.strength,
  });

  factory Medication.fromJson(Map<String, dynamic> data) {
    Map<String, dynamic> json = data['associatedDrug'][0];
    // ignore: avoid_print
    print('Json Model data is $json');
    return Medication(
      name: json['name'] ?? "",
      dose: json['dose'] ?? "",
      strength: json['strength'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      name: name,
      dose: dose,
      strength: strength,
    };
  }
}
