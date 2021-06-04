import 'package:flutter/material.dart';
import 'package:budget_tracker/src/blocs/budget_provider.dart';

class Refresh extends StatelessWidget {
  Widget child;

  Refresh({required this.child});

  Widget build(context) {
    final bloc = BudgetProvider.of(context);
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          await bloc.fetchItems();
        });
  }
}
