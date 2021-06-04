import 'package:flutter/material.dart';
import 'package:budget_tracker/src/screens/budget_screen.dart';
import 'package:budget_tracker/src/blocs/budget_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return BudgetProvider(
      key: Key('budgetList'),
      child: MaterialApp(
        title: 'Budget App',
        theme: ThemeData(primaryColor: Colors.white),
        home: BudgetScreen(),
      ),
    );
  }
}
