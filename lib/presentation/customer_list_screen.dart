import 'package:cognisto_test/presentation/viewmodel/customer_viewmodel.dart';
import 'package:cognisto_test/presentation/widgets/customer_card.dart';
import 'package:cognisto_test/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerListScreen extends StatefulWidget {
  const ConsumerListScreen({super.key});

  @override
  State<ConsumerListScreen> createState() => _ConsumerListScreenState();
}

class _ConsumerListScreenState extends State<ConsumerListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerViewmodel>().fetchCustomers();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerViewmodel>().loadMoreCustomers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SearchBarWidget(),
            Expanded(
              child: Consumer<CustomerViewmodel>(
                builder: (context, value, child) {
                  return _buildBody(value);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(CustomerViewmodel viewmodel) {
    switch (viewmodel.state) {
      case CustomerState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case CustomerState.error:
        return _buildErrorWidget(viewmodel);
      case CustomerState.searching:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 16,
              ),
              Text('Searching customers...')
            ],
          ),
        );
      case CustomerState.loaded:
      case CustomerState.loadingMore:
        if (viewmodel.customers.isEmpty) {
          return _buildEmptyWidget(viewmodel);
        } else {
          return _buildCustomerList(viewmodel);
        }

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCustomerList(CustomerViewmodel viewmodel) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index < viewmodel.customers.length) {
            return CustomerCardWidget(customer: viewmodel.customers[index]);
          }
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
          return null;
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: viewmodel.customers.length +
            (viewmodel.state == CustomerState.loadingMore ? 1 : 0));
  }

  Widget _buildEmptyWidget(CustomerViewmodel viewmodel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off),
          const SizedBox(
            height: 16,
          ),
          Text(viewmodel.isSearchMode
              ? 'No customers found for your search'
              : 'No Customers available'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(CustomerViewmodel viewmodel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Oops, something went wrong ${viewmodel.errorMessage}',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () => viewmodel.fetchCustomers(),
                child: const Text('Retry'))
          ],
        ),
      ),
    );
  }
}
