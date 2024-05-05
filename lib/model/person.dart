class Person {
  final int personID;
  final String name;
  final DateTime birthDate;
  final double age;
  final int nationalityID;

  Person({
    required this.personID,
    required this.name,
    required this.birthDate,
    required this.age,
    required this.nationalityID,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personID: json['personID'],
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      age: json['age'],
      nationalityID: json['nationalityID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personID': personID,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'age': age,
      'nationalityID': nationalityID,
    };
  }
}
