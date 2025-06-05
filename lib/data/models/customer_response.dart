import 'package:cognisto_test/data/models/customer.dart';

class CustomerResponse {
  final List<Customer> users;
  final int total;
  final int skip;
  final int limit;

  CustomerResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      users: json["users"] == null
          ? []
          : List<Customer>.from(
              json["users"]!.map((x) => Customer.fromJson(x))),
      // (json['users'] as List)
      //     .map((item) => Customer.fromJson(json))
      //     .toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
