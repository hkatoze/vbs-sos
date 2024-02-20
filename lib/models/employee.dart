class Employee {
  final int companyId;
  final int employeeId;
  final String firstname;
  final String lastname;
  final String phone_number;
  final String role;
  final String job;

  final String profilUrl;
  final String? tokens;

  Employee(
      {required this.companyId,
      required this.employeeId,
      required this.firstname,
      required this.lastname,
      required this.phone_number,
      this.tokens,
      required this.role,
      required this.job,
      required this.profilUrl});

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
        companyId: map['companyId'],
        tokens: map['tokens'],
        employeeId: map['employeeId'],
        firstname: map['firstname'],
        lastname: map['lastname'],
        phone_number: map['phone_number'],
        role: map['role'],
        job: map['job'],
        profilUrl: map['profilUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'employeeId': employeeId,
      'firstname': firstname,
      'lastname': lastname,
      'phone_number': phone_number,
      'role': role,
      'job': job,
      'tokens': tokens,
      'profilUrl': profilUrl
    };
  }
}
