class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
  });
  String get fullName => '$firstName $lastName';

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'].toString(),
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        profilePicture: json['image']);
  }
}
