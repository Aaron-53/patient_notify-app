class Patient {
  final String id;
  final String name;
  final String address;
  final DateTime dob;
  final String gender;
  final String email;
  final String phone;

  const Patient({
    required this.id,
    required this.name,
    required this.address,
    required this.dob,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      dob: DateTime.parse(json['dob']),
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'dob': dob.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'gender': gender,
      'email': email,
      'phone': phone,
    };
  }
}

class PatientCreate {
  final String name;
  final String address;
  final DateTime dob;
  final String gender;
  final String email;
  final String phone;

  const PatientCreate({
    required this.name,
    required this.address,
    required this.dob,
    required this.gender,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'dob': dob.toIso8601String().split('T')[0], // YYYY-MM-DD format
      'gender': gender,
      'email': email,
      'phone': phone,
    };
  }
}
