import 'package:cognisto_test/data/models/customer_response.dart';
import 'package:cognisto_test/data/services/customer_api_service.dart';

class CustomerRepository {
  final CustomerApiService _customerApiService;
  CustomerRepository({CustomerApiService? customerApiService})
      : _customerApiService = customerApiService ?? CustomerApiService();

  Future<CustomerResponse> getCustomers(
      {required int limit, int skip = 0}) async {
    return await _customerApiService.getCustomers(limit, skip);
  }

  Future<CustomerResponse> searchCustomers(String query) async {
    return await _customerApiService.searchCustomers(query);
  }
}
