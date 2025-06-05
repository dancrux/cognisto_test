import 'package:cognisto_test/data/models/customer.dart';
import 'package:flutter/material.dart';

class CustomerCardWidget extends StatelessWidget {
  final Customer customer;
  const CustomerCardWidget({required this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (customer.profilePicture != null &&
                  customer.profilePicture!.isNotEmpty)
              ? NetworkImage(customer.profilePicture!)
              : null,
          child: customer.profilePicture == null ||
                  customer.profilePicture!.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(
          customer.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(customer.email),
      ),
    );
  }
}
