import 'dart:async';

import 'package:cognisto_test/data/models/customer.dart';
import 'package:cognisto_test/repository/customer_repository.dart';
import 'package:flutter/material.dart';

enum CustomerState {
  initial,
  loading,
  loadingMore,
  searching,
  loaded,
  error,
}

class CustomerViewmodel extends ChangeNotifier {
  final CustomerRepository _customerRepository;
  CustomerViewmodel({required CustomerRepository customerRepository})
      : _customerRepository = customerRepository;

  List<Customer> _customers = [];
  CustomerState _state = CustomerState.initial;
  String _errorMessage = '';
  int _currentPage = 0;
  bool _hasMoreData = true;
  bool _isSearchMode = false;
  String _searchQuery = '';
  Timer? _debounceTimer;

  List<Customer> get customers => _customers;
  CustomerState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isSearchMode => _isSearchMode;

  void setState(CustomerState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> fetchCustomers() async {
    _currentPage = 1;
    _hasMoreData = true;
    setState(CustomerState.loading);
    try {
      final customers = await _customerRepository.getCustomers(limit: 10);
      _customers = customers.users;
      _hasMoreData = customers.users.length == 10;
      setState(CustomerState.loaded);
    } catch (e) {
      setState(CustomerState.error);
      _errorMessage = e.toString();
    }
  }

  Future<void> loadMoreCustomers() async {
    if (!_hasMoreData || _state == CustomerState.loadingMore) {
      return;
    }

    setState(CustomerState.loadingMore);
    try {
      _currentPage++;
      final moreCustomers =
          await _customerRepository.getCustomers(limit: 10, skip: _currentPage);
      _customers = moreCustomers.users;
      _hasMoreData = moreCustomers.users.length > 10;
      setState(CustomerState.loaded);
    } catch (e) {
      _currentPage--;
      setState(CustomerState.error);
      _errorMessage = e.toString();
    }
  }

  Future<void> searchCustomers(String query) async {
    _debounceTimer?.cancel();
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      _exitSearchMode();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    _isSearchMode = true;
    setState(CustomerState.searching);
    try {
      final searchResults =
          await _customerRepository.searchCustomers(_searchQuery);
      _customers = searchResults.users;

      setState(CustomerState.loaded);
    } catch (e) {
      setState(CustomerState.error);
      _errorMessage = e.toString();
    }
  }

  void _exitSearchMode() {
    _isSearchMode = false;
    _debounceTimer?.cancel();
    if (_customers.isEmpty) {
      fetchCustomers();
    }
  }

  void clearSearch() {
    _isSearchMode = false;
    _searchQuery = '';
    _exitSearchMode();
  }
}
