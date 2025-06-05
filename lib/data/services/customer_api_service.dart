import 'dart:convert';
import 'dart:io';

import 'package:cognisto_test/data/models/customer_response.dart';
import 'package:http/http.dart' as http;

class CustomerApiService {
  static String baseUrl(int limit, int skip) =>
      'https://dummyjson.com/users?limit=$limit&skip=$skip';
  static const Duration timeout = Duration(seconds: 30);

  Future<CustomerResponse> getCustomers(int limit, int skip) async {
    final url = Uri.parse(baseUrl(limit, skip));
    try {
      final customerResponse = await http.get(url,
          headers: {'Content-type': 'application/json'}).timeout(timeout);
      print('getCustomers: ${customerResponse.body}');
      if (customerResponse.statusCode == 200) {
        final customerJson = json.decode(customerResponse.body);
        return CustomerResponse.fromJson(customerJson);
      } else {
        throw const HttpException('Error Occureed, Failed to Load Customers');
      }
    } on SocketException catch (_) {
      throw const SocketException('No internet Connection');
    } catch (e) {
      print('exception $e');
      throw Exception('An Unexpected Error Occured');
    }
  }

  Future<CustomerResponse> searchCustomers(String query) async {
    final String queryUrl = 'https://dummyjson.com/users/search?q=$query';
    final url = Uri.parse(queryUrl);
    try {
      final customerResponse = await http.get(url,
          headers: {'Content-type': 'application/json'}).timeout(timeout);
      if (customerResponse.statusCode == 200) {
        final customerJson = json.decode(customerResponse.body);
        return CustomerResponse.fromJson(customerJson);
      } else {
        throw const HttpException('Error Occureed, Failed to Load Customers');
      }
    } on SocketException catch (_) {
      throw const SocketException('No internet Connection');
    } catch (e) {
      throw Exception('An Unexpected Error Occured');
    }
  }
}
