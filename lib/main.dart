import 'package:cognisto_test/presentation/customer_list_screen.dart';
import 'package:cognisto_test/presentation/viewmodel/customer_viewmodel.dart';
import 'package:cognisto_test/repository/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CustomerViewmodel(customerRepository: CustomerRepository()),
      child: MaterialApp(
        title: 'Customer App',
        home: const ConsumerListScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
      ),
    );
  }
}
